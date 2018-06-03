require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  database_config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
  database_config['pool'] = ENV['DB_POOL'] || 5 unless Rails.env.development?

  ActiveRecord::Base.establish_connection(database_config)
end

unless Rails.env.development?
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [SETTINGS[:sidekiq_web][:user], SETTINGS[:sidekiq_web][:passwd]]
  end
end
