# frozen_string_literal: true

require_relative '../../db/seed_data/catalog'
require_relative '../../db/seed_data/locations'

module ReferenceSeedSync
  LOCALES = %i[en ru he].freeze

  def self.upsert(model, attributes, scope = model.all, locales: LOCALES)
    matches = locales.filter_map { |locale| scope.find_by(locale => attributes[locale]) }.uniq(&:id)
    raise "Ambiguous #{model.name} match for #{attributes.slice(*LOCALES).inspect}" if matches.size > 1

    record = matches.first || model.new
    status = record.new_record? ? :created : :unchanged
    record.assign_attributes(attributes)
    status = :updated if status == :unchanged && record.changed?
    record.save! if record.new_record? || record.changed?
    [record, status]
  end
end

namespace :seed_data do
  desc 'Safely synchronize catalog and Israel location reference data'
  task refresh: :environment do
    dry_run = ENV['DRY_RUN'] == '1'
    counts = Hash.new(0)

    ActiveRecord::Base.transaction do
      categories = CatalogSeedData::CATALOG.map do |data|
        category, status = ReferenceSeedSync.upsert(Category, data[:name])
        counts[:"categories_#{status}"] += 1
        category
      end

      CatalogSeedData::CATALOG.each_with_index do |data, index|
        data[:things].each do |attributes|
          _, status = ReferenceSeedSync.upsert(Thing, attributes.merge(category: categories[index]))
          counts[:"things_#{status}"] += 1
        end
      end

      LocationsSeedData::DISTRICTS.each do |data|
        district, status = ReferenceSeedSync.upsert(District, data[:name])
        counts[:"districts_#{status}"] += 1

        ambiguous_city_names = %i[en ru].flat_map do |locale|
          data.fetch(:cities, []).group_by { |attributes| attributes[locale] }.filter_map do |name, entries|
            [locale, name] if entries.map { |attributes| attributes[:he] }.uniq.size > 1
          end
        end

        data.fetch(:cities, []).each do |attributes|
          distinct_hebrew_name = %i[en ru].any? do |locale|
            ambiguous_city_names.include?([locale, attributes[locale]])
          end
          match_locales = distinct_hebrew_name ? [:he] : ReferenceSeedSync::LOCALES
          _, city_status = ReferenceSeedSync.upsert(
            City, attributes.merge(district:), district.cities, locales: match_locales
          )
          counts[:"cities_#{city_status}"] += 1
        end
      end

      puts counts.sort.map { |name, count| "#{name}=#{count}" }.join(', ')
      raise ActiveRecord::Rollback if dry_run
    end

    puts(dry_run ? 'Dry run complete; all changes rolled back.' : 'Reference seed data synchronized.')
  end
end
