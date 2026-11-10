# frozen_string_literal: true

require_relative '../../db/seed_data/locations'

namespace :districts do
  # Districts
  desc 'Start'
  task start: :environment do
    if District.exists?
      p 'Districts already exists!'
    else
      LocationsSeedData::DISTRICTS.each do |district|
        District.create(district[:name])
        next unless district[:cities].present?

        district[:cities].each do |city|
          District.find_by(en: district[:name][:en].to_s).cities.create(city)
        end
      end

      p "Created #{District.count} districts and #{City.count} cities"
    end
  end
end
