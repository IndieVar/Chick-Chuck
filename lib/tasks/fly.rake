# frozen_string_literal: true

namespace :fly do
  desc 'Start'
  task :start do
    start_tasks = %w[admin:start catalog:start districts:start services:start]

    if ENV['FLY_APP_NAME'].present?
      start_tasks.each { |task_name| Rake::Task[task_name].invoke }
    else
      start_tasks.each do |task_name|
        sh %(fly ssh console --pty -C "/rails/bin/rails #{task_name}")
      end
    end
  end

  task :console do
    sh 'fly ssh console --pty -C "/rails/bin/rails console"'
  end

  task :dbconsole do
    sh 'fly ssh console --pty -C "/rails/bin/rails dbconsole"'
  end

  task :dbstatus do
    sh 'fly ssh console --pty -C "/rails/bin/rails db:migrate:status"'
  end

  task :tmp_clear do
    sh 'fly ssh console --pty -C "/rails/bin/rails tmp:clear"'
  end

  task :assets_clean do
    sh 'fly ssh console --pty -C "/rails/bin/rails assets:clean"'
  end

  task :assets_clobber do
    sh 'fly ssh console --pty -C "/rails/bin/rails assets:clobber"'
  end

  task :assets_precompile do
    sh 'fly ssh console --pty -C "/rails/bin/rails assets:precompile"'
  end
end
