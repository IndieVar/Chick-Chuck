# frozen_string_literal: true

require 'faker'
require 'securerandom'
require_relative 'seed_data/catalog'
require_relative 'seed_data/locations'
require_relative 'seed_data/services'

module DemoSeedData
  extend self

  DISTRICTS = LocationsSeedData::DISTRICTS.map { |district| district[:name] }

  CATALOG = CatalogSeedData::CATALOG

  LANGUAGES = %w[עברית العربية English Русский Українська].freeze
  CLIENT_COUNT = 100
  COMPANY_COUNT = 50
  COMPANY_IMAGE_COUNT = 3
  PRODUCT_COUNT = 200
  REVIEWS_PER_COMPANY = 3

  def run
    ActiveRecord::Base.transaction do
      districts, locations = seed_districts_and_locations
      languages = seed_languages
      things = seed_catalog
      services = seed_services
      clients = seed_clients
      companies = seed_companies(locations, districts, languages, services)
      seed_company_images(companies)
      seed_reviews(clients, companies)
      seed_products(clients, companies, locations, things)

      puts "Demo data ready: #{clients.size} clients, #{companies.size} carriers, " \
           "#{Review.where(reviewable_type: 'Company', reviewable_id: companies.map(&:id)).count} carrier reviews, " \
           "#{Product.where('title LIKE ?', 'Demo listing %').count} products."
    end
  end

  def seed_districts
    DISTRICTS.map do |attributes|
      district = District.find_by(en: attributes[:en]) ||
                 District.find_by(ru: attributes[:ru]) ||
                 District.find_by(he: attributes[:he]) ||
                 District.new
      district.assign_attributes(attributes)
      district.save! if district.new_record? || district.changed?
      district
    end
  end

  private

  def seed_districts_and_locations
    districts = seed_districts
    [districts, seed_locations]
  end

  def seed_locations
    LocationsSeedData::DISTRICTS.flat_map do |location|
      next [] unless location[:cities].present?

      district = District.find_or_create_by!(en: location[:name][:en]) do |record|
        record.assign_attributes(location[:name])
      end

      location[:cities].map do |attributes|
        City.find_or_create_by!(en: attributes[:en], district:) do |record|
          record.assign_attributes(attributes)
        end
      end
    end
  end

  def seed_languages
    languages = Language.where(title: LANGUAGES).order(:id).each_with_object({}) do |language, records|
      records[language.title] ||= language
    end
    LANGUAGES.map { |title| languages[title] || Language.create!(title:) }
  end

  def seed_catalog
    categories = find_or_create_localized_records(Category, CATALOG.map { |data| data[:name] })
    thing_attributes = catalog_thing_attributes(categories)

    find_or_create_localized_records(Thing, thing_attributes)
  end

  def catalog_thing_attributes(categories)
    seen_translations = %i[en ru he].to_h { |locale| [locale, {}] }

    CATALOG.each_with_index.flat_map do |data, index|
      data[:things].filter_map do |attributes|
        next if seen_translations.any? { |locale, values| values.key?(attributes[locale]) }

        seen_translations.each { |locale, values| values[attributes[locale]] = true }
        attributes.merge(category: categories[index])
      end
    end
  end

  def seed_services
    find_or_create_localized_records(Service, ServiceSeedData::SERVICES)
  end

  def find_or_create_localized_records(model, attribute_sets)
    records = localized_records(model, attribute_sets)
    attribute_sets.map do |attributes|
      localized_record(records, attributes) || model.create!(attributes).tap { |record| records << record }
    end
  end

  def localized_records(model, attribute_sets)
    return [] if attribute_sets.empty?

    model.where(en: attribute_sets.map { |attributes| attributes[:en] })
         .or(model.where(ru: attribute_sets.map { |attributes| attributes[:ru] }))
         .or(model.where(he: attribute_sets.map { |attributes| attributes[:he] }))
         .order(:id)
         .to_a
  end

  def localized_record(records, attributes)
    records.find { |record| record.en == attributes[:en] } ||
      records.find { |record| record.ru == attributes[:ru] } ||
      records.find { |record| record.he == attributes[:he] }
  end

  def seed_clients
    emails = CLIENT_COUNT.times.map { |index| demo_email('client', index) }
    clients_by_email = Client.where(email: emails).index_by(&:email)

    CLIENT_COUNT.times.map { |index| seed_client(index, emails[index], clients_by_email) }
  end

  def seed_client(index, email, clients_by_email)
    Faker::Config.random = Random.new(10_000 + index)
    clients_by_email[email] || Client.find_or_create_by!(email:) do |client|
      client.assign_attributes(client_attributes(index))
    end
  end

  def client_attributes(index)
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      password: SecureRandom.hex(24),
      confirmed_at: Time.current,
      locale: %w[en ru uk he][index % 4]
    }
  end

  def seed_companies(cities, districts, languages, services)
    hebrew = languages.find { |language| language.title == 'עברית' }
    english = languages.find { |language| language.title == 'English' }
    emails = COMPANY_COUNT.times.map { |index| demo_email('carrier', index) }
    companies_by_email = Company.where(email: emails).index_by(&:email)
    seed_data = { emails:, companies_by_email:, cities:, districts:, languages: [hebrew, english], services: }

    COMPANY_COUNT.times.map { |index| seed_company(index, seed_data) }
  end

  def seed_company(index, seed_data)
    Faker::Config.random = Random.new(20_000 + index)
    company = company_record(index, seed_data)
    city = seed_data[:cities][index % seed_data[:cities].length]
    company.districts = company_districts(index, city, seed_data[:districts])
    company.services = company_services(index, seed_data[:services])
    company
  end

  def company_record(index, seed_data)
    email = seed_data[:emails][index]
    city = seed_data[:cities][index % seed_data[:cities].length]
    seed_data[:companies_by_email][email] || create_company(index, email, city, seed_data[:languages])
  end

  def create_company(index, email, city, languages)
    Company.find_or_create_by!(email:) do |record|
      record.assign_attributes(company_attributes(index, city, languages))
    end
  end

  def company_attributes(index, city, languages)
    {
      title: "#{Faker::Company.name} Moving #{index + 1}",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      password: SecureRandom.hex(24),
      confirmed_at: Time.current,
      city:,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      website: "https://#{Faker::Internet.domain_name}",
      districts: [city.district],
      languages:
    }
  end

  def company_services(index, services)
    [services[index % services.length], services[(index + 1) % services.length]]
  end

  def company_districts(index, city, districts)
    service_districts = districts.reject { |district| district.en == 'All Israel' }
    additional_district = service_districts.rotate(index).find { |district| district.id != city.district_id }

    [city.district, additional_district].compact.uniq
  end

  def seed_reviews(clients, companies)
    now = Time.current
    assignments = review_assignments(clients, companies)
    existing_reviews = existing_review_keys(assignments, companies)
    rows = build_review_rows(assignments, existing_reviews, now)

    # Bulk insert keeps seeding synthetic reviews from queuing notification emails.
    Review.insert_all!(rows) if rows.any?

    refresh_company_ratings(companies)
  end

  def refresh_company_ratings(companies)
    ratings = Review.where(reviewable_type: Company.name, reviewable_id: companies.map(&:id))
                    .group(:reviewable_id)
                    .pluck(:reviewable_id, Arel.sql('AVG(rating)'), Arel.sql('AVG(price)'))
                    .to_h { |company_id, rating, price| [company_id, [rating, price]] }

    companies.each do |company|
      rating, price = ratings[company.id]
      company.update!(rating:, price:) if rating
    end
  end

  def review_assignments(clients, companies)
    companies.each_with_index.flat_map do |company, company_index|
      REVIEWS_PER_COMPANY.times.map do |review_index|
        client = clients[(company_index * REVIEWS_PER_COMPANY + review_index) % clients.length]
        [company, company_index, review_index, client]
      end
    end
  end

  def existing_review_keys(assignments, companies)
    Review.where(
      user_id: assignments.map { |_, _, _, client| client.id }.uniq,
      reviewable_type: Company.name,
      reviewable_id: companies.map(&:id)
    ).pluck(:user_id, :reviewable_id).to_h { |key| [key, true] }
  end

  def build_review_rows(assignments, existing_reviews, now)
    assignments.filter_map do |company, company_index, review_index, client|
      review_key = [client.id, company.id]
      next if existing_reviews.key?(review_key)

      existing_reviews[review_key] = true
      Faker::Config.random = Random.new(30_000 + company_index * REVIEWS_PER_COMPANY + review_index)
      review_attributes([company, company_index, review_index, client], now)
    end
  end

  def review_attributes(assignment, now)
    company, company_index, review_index, client = assignment
    {
      rating: 4 + ((company_index + review_index) % 2),
      price: 3 + ((company_index + review_index) % 3),
      title: %w[Careful and reliable Excellent moving service Friendly professional team][review_index],
      content: Faker::Lorem.sentence(word_count: 18),
      user_id: client.id,
      reviewable_type: company.class.name,
      reviewable_id: company.id,
      created_at: now - (company_index + review_index).days,
      updated_at: now
    }
  end

  def seed_company_images(companies)
    gallery_paths = Dir[Rails.root.join('app/assets/images/seed/products/*.jpg')].sort
    raise "No carrier gallery images found in #{Rails.root.join('app/assets/images/seed/products')}" if gallery_paths.empty?

    image_counts = company_image_counts(companies)
    companies.each_with_index do |company, company_index|
      seed_company_images_for(company, company_index, image_counts.fetch(company.id, 0), gallery_paths)
    end
  end

  def company_image_counts(companies)
    Image.where(imageable_type: Company.name, imageable_id: companies.map(&:id))
         .group(:imageable_id)
         .count
  end

  def seed_company_images_for(company, company_index, image_count, gallery_paths)
    avatar_path = Rails.root.join('app/assets/images/bg/bg-truck-1000-rtl.png')
    File.open(avatar_path) { |file| company.update!(avatar: file) } if company.avatar.blank?

    while image_count < COMPANY_IMAGE_COUNT
      image_index = (company_index * COMPANY_IMAGE_COUNT + image_count) % gallery_paths.length
      File.open(gallery_paths[image_index]) { |file| company.images.create!(file:) }
      image_count += 1
    end
  end

  def seed_products(clients, companies, cities, things)
    titles = PRODUCT_COUNT.times.map { |index| product_title(index, things) }
    products_by_title = Product.where(title: titles).index_by(&:title)
    products = PRODUCT_COUNT.times.map do |index|
      plan = product_seed_plan(index, clients, companies, cities, things)
      seed_product(index, titles[index], products_by_title, plan)
    end

    attach_missing_product_images(products)
  end

  def product_seed_plan(index, clients, companies, cities, things)
    thing = things[index % things.length]
    city = cities[(index * 7) % cities.length]
    seller = index % 5 == 0 ? companies[(index / 5) % companies.length] : clients[index % clients.length]

    [seller, city, thing]
  end

  def seed_product(index, title, products_by_title, plan)
    Faker::Config.random = Random.new(40_000 + index)
    seller, city, thing = plan
    product = products_by_title[title] || Product.create!(product_attributes(index, title, seller, city, thing))

    [product, index]
  end

  def product_attributes(index, title, seller, city, thing)
    {
      title:,
      user: seller,
      category: thing.category,
      thing:,
      district: city.district,
      city:,
      condition: index.even? ? 1 : 2,
      delivery: index % 3 == 0 ? 0 : city.district_id,
      price: 50 + ((index * 137) % 4_950),
      description: Faker::Lorem.sentence(word_count: 16),
      published: true,
      sold: false
    }
  end

  def product_title(index, things)
    format('Demo listing %03d: %s', index + 1, things[index % things.length].en)
  end

  def attach_missing_product_images(products)
    products_with_images = existing_product_image_ids(products)

    products.each do |product, index|
      attach_product_image(product, index) unless products_with_images.key?(product.id)
    end
  end

  def existing_product_image_ids(products)
    product_ids = products.map { |product, _| product.id }
    Image.where(imageable_type: Product.name, imageable_id: product_ids)
         .distinct
         .pluck(:imageable_id)
         .to_h { |id| [id, true] }
  end

  def attach_product_image(product, index)
    image_path = Rails.root.join('app/assets/images/seed/products', "#{(index % 7) + 1}.jpg")
    File.open(image_path) { |file| product.images.create!(file:) }
  end

  def demo_email(kind, index)
    format("demo.#{kind}.%03d@example.test", index + 1)
  end
end

DemoSeedData.run
