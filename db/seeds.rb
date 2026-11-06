# frozen_string_literal: true

require 'faker'
require 'securerandom'

module DemoSeedData
  extend self

  LOCATIONS = [
    {
      district: { en: 'Tel Aviv District', ru: 'Тель-Авивский округ', uk: 'Тель-Авівський округ', he: 'מחוז תל אביב' },
      cities: [
        { en: 'Tel Aviv', ru: 'Тель-Авив', uk: 'Тель-Авів', he: 'תל אביב' },
        { en: 'Ramat Gan', ru: 'Рамат-Ган', uk: 'Рамат-Ган', he: 'רמת גן' },
        { en: 'Holon', ru: 'Холон', uk: 'Холон', he: 'חולון' }
      ]
    },
    {
      district: { en: 'Jerusalem District', ru: 'Иерусалимский округ', uk: 'Єрусалимський округ', he: 'מחוז ירושלים' },
      cities: [
        { en: 'Jerusalem', ru: 'Иерусалим', uk: 'Єрусалим', he: 'ירושלים' },
        { en: 'Beit Shemesh', ru: 'Бейт-Шемеш', uk: 'בית שמש', he: 'בית שמש' }
      ]
    },
    {
      district: { en: 'Central District', ru: 'Центральный округ', uk: 'Центральний округ', he: 'מחוז המרכז' },
      cities: [
        { en: 'Petah Tikva', ru: 'Петах-Тиква', uk: 'Петах-Тіква', he: 'פתח תקווה' },
        { en: 'Rishon LeZion', ru: 'Ришон-ле-Цион', uk: 'Рішон-ле-Ціон', he: 'ראשון לציון' },
        { en: 'Netanya', ru: 'Нетания', uk: 'Нетанія', he: 'נתניה' }
      ]
    },
    {
      district: { en: 'Haifa District', ru: 'Хайфский округ', uk: 'Хайфський округ', he: 'מחוז חיפה' },
      cities: [
        { en: 'Haifa', ru: 'Хайфа', uk: 'Хайфа', he: 'חיפה' },
        { en: 'Tirat Carmel', ru: 'Тират-Кармель', uk: 'Тірат-Кармель', he: 'טירת כרמל' }
      ]
    },
    {
      district: { en: 'Northern District', ru: 'Северный округ', uk: 'Північний округ', he: 'מחוז הצפון' },
      cities: [
        { en: 'Nazareth', ru: 'Назарет', uk: 'Назарет', he: 'נצרת' },
        { en: 'Tiberias', ru: 'Тверия', uk: 'Тверія', he: 'טבריה' }
      ]
    },
    {
      district: { en: 'Southern District', ru: 'Южный округ', uk: 'Південний округ', he: 'מחוז הדרום' },
      cities: [
        { en: 'Beersheba', ru: 'Беэр-Шева', uk: 'Беер-Шева', he: 'באר שבע' },
        { en: 'Ashdod', ru: 'Ашдод', uk: 'Ашдод', he: 'אשדוד' }
      ]
    }
  ].freeze

  CATALOG = [
    {
      category: { en: 'Furniture', ru: 'Мебель', uk: 'Меблі', he: 'ריהוט' },
      things: [
        { en: 'Sofa', ru: 'Диван', uk: 'Диван', he: 'ספה' },
        { en: 'Dining table', ru: 'Обеденный стол', uk: 'Обідній стіл', he: 'שולחן אוכל' },
        { en: 'Wardrobe', ru: 'Шкаф', uk: 'Шафа', he: 'ארון בגדים' },
        { en: 'Bookshelf', ru: 'Книжный шкаф', uk: 'Книжкова шафа', he: 'כוננית ספרים' }
      ]
    },
    {
      category: { en: 'Home appliances', ru: 'Бытовая техника', uk: 'Побутова техніка', he: 'מכשירי חשמל לבית' },
      things: [
        { en: 'Refrigerator', ru: 'Холодильник', uk: 'Холодильник', he: 'מקרר' },
        { en: 'Washing machine', ru: 'Стиральная машина', uk: 'Пральна машина', he: 'מכונת כביסה' },
        { en: 'Vacuum cleaner', ru: 'Пылесос', uk: 'Пилосос', he: 'שואב אבק' },
        { en: 'Microwave oven', ru: 'Микроволновая печь', uk: 'Мікрохвильова піч', he: 'מיקרוגל' }
      ]
    },
    {
      category: { en: 'Electronics', ru: 'Электроника', uk: 'Електроніка', he: 'אלקטרוניקה' },
      things: [
        { en: 'Television', ru: 'Телевизор', uk: 'Телевізор', he: 'טלוויזיה' },
        { en: 'Computer monitor', ru: 'Монитор', uk: 'Монітор', he: 'מסך מחשב' },
        { en: 'Laptop', ru: 'Ноутбук', uk: 'Ноутбук', he: 'מחשב נייד' },
        { en: 'Speaker system', ru: 'Акустическая система', uk: 'Акустична система', he: 'מערכת רמקולים' }
      ]
    },
    {
      category: { en: 'Kitchen and dining', ru: 'Кухня и столовая', uk: 'Кухня та їдальня', he: 'מטבח ופינת אוכל' },
      things: [
        { en: 'Dining chairs', ru: 'Обеденные стулья', uk: 'Обідні стільці', he: 'כיסאות אוכל' },
        { en: 'Cookware set', ru: 'Набор посуды', uk: 'Набір посуду', he: 'ערכת כלי בישול' },
        { en: 'Coffee machine', ru: 'Кофемашина', uk: 'Кавомашина', he: 'מכונת קפה' },
        { en: 'Kitchen cabinet', ru: 'Кухонный шкаф', uk: 'Кухонна шафа', he: 'ארון מטבח' }
      ]
    },
    {
      category: { en: 'Moving supplies', ru: 'Всё для переезда', uk: 'Все для переїзду', he: 'ציוד למעבר דירה' },
      things: [
        { en: 'Moving boxes', ru: 'Коробки для переезда', uk: 'Коробки для переїзду', he: 'ארגזי מעבר' },
        { en: 'Protective blankets', ru: 'Защитные одеяла', uk: 'Захисні ковдри', he: 'שמיכות הגנה' },
        { en: 'Hand truck', ru: 'Грузовая тележка', uk: 'Візок для вантажу', he: 'עגלת משא' },
        { en: 'Storage shelves', ru: 'Стеллажи для хранения', uk: 'Стелажі для зберігання', he: 'מדפי אחסון' }
      ]
    },
    {
      category: { en: 'Home and garden', ru: 'Дом и сад', uk: 'Дім і сад', he: 'בית וגינה' },
      things: [
        { en: 'Desk', ru: 'Письменный стол', uk: 'Письмовий стіл', he: 'שולחן כתיבה' },
        { en: 'Office chair', ru: 'Офисное кресло', uk: 'Офісне крісло', he: 'כיסא משרדי' },
        { en: 'Floor lamp', ru: 'Торшер', uk: 'Торшер', he: 'מנורת רצפה' },
        { en: 'Garden furniture', ru: 'Садовая мебель', uk: 'Садові меблі', he: 'ריהוט גן' }
      ]
    }
  ].freeze

  LANGUAGES = %w[עברית العربية English Русский Українська].freeze
  CLIENT_COUNT = 100
  COMPANY_COUNT = 50
  COMPANY_IMAGE_COUNT = 3
  PRODUCT_COUNT = 200
  REVIEWS_PER_COMPANY = 3

  def run
    ActiveRecord::Base.transaction do
      locations = seed_locations
      languages = seed_languages
      things = seed_catalog
      clients = seed_clients
      companies = seed_companies(locations, languages)
      seed_company_images(companies)
      seed_reviews(clients, companies)
      seed_products(clients, companies, locations, things)

      puts "Demo data ready: #{clients.size} clients, #{companies.size} carriers, " \
           "#{Review.where(reviewable_type: 'Company', reviewable_id: companies.map(&:id)).count} carrier reviews, " \
           "#{Product.where('title LIKE ?', 'Demo listing %').count} products."
    end
  end

  private

  def seed_locations
    cities = LOCATIONS.flat_map do |location|
      district = District.find_or_create_by!(en: location[:district][:en]) do |record|
        record.assign_attributes(location[:district])
      end

      location[:cities].map do |attributes|
        City.find_or_create_by!(en: attributes[:en], district:) do |record|
          record.assign_attributes(attributes)
        end
      end
    end
    cities
  end

  def seed_languages
    LANGUAGES.map { |title| Language.find_or_create_by!(title:) }
  end

  def seed_catalog
    CATALOG.flat_map do |data|
      category = find_or_create_localized(Category, data[:category])
      data[:things].map do |attributes|
        find_or_create_localized(Thing, attributes.merge(category:))
      end
    end
  end

  def find_or_create_localized(model, attributes)
    model.find_by(en: attributes[:en]) ||
      model.find_by(ru: attributes[:ru]) ||
      model.find_by(he: attributes[:he]) ||
      model.create!(attributes)
  end

  def seed_clients
    CLIENT_COUNT.times.map do |index|
      Faker::Config.random = Random.new(10_000 + index)
      Client.find_or_create_by!(email: format('demo.client.%03d@example.test', index + 1)) do |client|
        client.assign_attributes(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          password: SecureRandom.hex(24),
          confirmed_at: Time.current,
          locale: %w[en ru uk he][index % 4]
        )
      end
    end
  end

  def seed_companies(cities, languages)
    hebrew = languages.find { |language| language.title == 'עברית' }
    english = languages.find { |language| language.title == 'English' }

    COMPANY_COUNT.times.map do |index|
      Faker::Config.random = Random.new(20_000 + index)
      city = cities[index % cities.length]
      Company.find_or_create_by!(email: format('demo.carrier.%03d@example.test', index + 1)) do |company|
        company.assign_attributes(
          title: "#{Faker::Company.name} Moving #{index + 1}",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          password: SecureRandom.hex(24),
          confirmed_at: Time.current,
          city:,
          description: Faker::Lorem.paragraph(sentence_count: 3),
          website: "https://#{Faker::Internet.domain_name}",
          districts: [city.district],
          languages: [hebrew, english]
        )
      end
    end
  end

  def seed_reviews(clients, companies)
    now = Time.current
    rows = companies.each_with_index.flat_map do |company, company_index|
      REVIEWS_PER_COMPANY.times.filter_map do |review_index|
        client = clients[(company_index * REVIEWS_PER_COMPANY + review_index) % clients.length]
        next if Review.exists?(user_id: client.id, reviewable_type: company.class.name, reviewable_id: company.id)

        Faker::Config.random = Random.new(30_000 + company_index * REVIEWS_PER_COMPANY + review_index)
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
    end

    # Bulk insert keeps seeding synthetic reviews from queuing notification emails.
    Review.insert_all!(rows) if rows.any?

    companies.each do |company|
      reviews = company.reviews
      company.update!(rating: reviews.average(:rating), price: reviews.average(:price)) if reviews.exists?
    end
  end

  def seed_company_images(companies)
    avatar_path = Rails.root.join('app/assets/images/bg/bg-truck-1000-rtl.png')
    gallery_paths = Dir[Rails.root.join('app/assets/images/seed/products/*.jpg')].sort
    raise "No carrier gallery images found in #{Rails.root.join('app/assets/images/seed/products')}" if gallery_paths.empty?

    companies.each_with_index do |company, company_index|
      if company.avatar.blank?
        File.open(avatar_path) { |file| company.update!(avatar: file) }
      end

      while company.images.count < COMPANY_IMAGE_COUNT
        image_index = (company_index * COMPANY_IMAGE_COUNT + company.images.count) % gallery_paths.length
        File.open(gallery_paths[image_index]) { |file| company.images.create!(file:) }
      end
    end
  end

  def seed_products(clients, companies, cities, things)
    PRODUCT_COUNT.times do |index|
      Faker::Config.random = Random.new(40_000 + index)
      thing = things[index % things.length]
      city = cities[(index * 7) % cities.length]
      seller = index % 5 == 0 ? companies[(index / 5) % companies.length] : clients[index % clients.length]
      title = format('Demo listing %03d: %s', index + 1, thing.en)

      product = Product.find_or_create_by!(title:) do |record|
        record.assign_attributes(
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
        )
      end
      attach_product_image(product, index)
    end
  end

  def attach_product_image(product, index)
    return if product.images.exists?

    image_path = Rails.root.join('app/assets/images/seed/products', "#{(index % 7) + 1}.jpg")
    File.open(image_path) { |file| product.images.create!(file:) }
  end
end

DemoSeedData.run
