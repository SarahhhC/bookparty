CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAJKY47ZNUUMA3I2JA',                        # required
    aws_secret_access_key: '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',                        # required
    region:                'ap-northeast-1'                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'bookpartyimage'                          # required
end
