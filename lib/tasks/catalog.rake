# frozen_string_literal: true

require_relative '../../db/seed_data/catalog'

namespace :catalog do
  # Catalog
  desc 'Start'
  task start: :environment do
    if Category.exists?
      p 'Catalog already exists!'
    else
      CatalogSeedData::CATALOG.each do |category_data|
        category = Category.create(category_data[:name])
        category_data[:things].each { |thing| category.things.create(thing) }
      end

      p "Created #{Category.count} categories and #{Thing.count} things"
    end
  end
end
