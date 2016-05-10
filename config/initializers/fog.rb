CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAI5FTQWJBDVRB4XBA',                        # required
    aws_secret_access_key: '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',                        # required
    region:                'ap-northeast-1'                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'bookparty'                          # required
end
