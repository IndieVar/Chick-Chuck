# frozen_string_literal: true

require_relative '../../db/seed_data/services'

namespace :services do
  # Languages
  desc 'Start'
  task start: :environment do
    # Create Admin
    if Service.exists?
      p 'Service already exists!'
    else
      ServiceSeedData::SERVICES.each do |service|
        Service.create(service)
      end

      p "Created #{Service.count} services"
    end
  end
end
