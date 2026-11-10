# frozen_string_literal: true

CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      provider: 'AWS', # required
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], # required
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # required
      region: ENV.fetch('AWS_REGION', 'auto'),
      endpoint: ENV['AWS_ENDPOINT_URL_S3'],
      path_style: true
      # use_iam_profile:       true,                           # optional, defaults to false
      # host:                  's3.example.com',               # optional, defaults to nil
      # endpoint:              'https://s3.example.com:8080'   # optional, defaults to nil
    }
    config.fog_directory  = ENV['BUCKET_NAME']                                    # required
    config.fog_public     = false                                                 # optional, defaults to true
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
    # For an application which utilizes multiple servers but does not need caches persisted across requests,
    # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
    # config.cache_storage = :file
    config.storage = :fog

  # store files locally in test and development environments
  else
    config.storage = :file
    config.enable_processing = false
    # config.root = "#{Rails.root}/tmp"
  end
end
