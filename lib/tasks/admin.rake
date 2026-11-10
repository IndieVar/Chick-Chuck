# frozen_string_literal: true

namespace :admin do
  # Languages
  desc 'Start'
  task start: :environment do
    if Admin.exists?
      puts 'Admin already exists!'
    else
      email = ENV.fetch('ADMIN_EMAIL') { raise 'Set ADMIN_EMAIL to create the admin account' }
      password = ENV.fetch('ADMIN_PASSWORD') { raise 'Set ADMIN_PASSWORD to create the admin account' }

      Admin.create!(email: email, password: password, password_confirmation: password,
                    confirmed_at: Time.current)
      puts 'Admin created'
    end

    languages = %w[עברית عربي አማርኛ English Русский Українська Français Español Italiano]
    languages.each { |language| Language.find_or_create_by!(title: language) }

    puts "Languages ready (#{Language.count})"
  end
end

# export ADMIN_EMAIL='admin@example.com'
# printf 'Admin password: '
# read -s ADMIN_PASSWORD
# printf '\n'
# export ADMIN_PASSWORD

# bundle exec rake admin:start
