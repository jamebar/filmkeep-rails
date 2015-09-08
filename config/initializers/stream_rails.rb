require 'stream_rails'
# StreamRails.enabled = false
if Rails.env.development?
  StreamRails.configure do |config|
    config.api_key     = "4j8dz2dp5vjn"
    config.api_secret  = "3gzp62asbcwjxjyfx7yvrbmctxykwrqc27ypxvnj7xyfu7uygz9rcrdshmvb4fey"
    config.api_site_id = '1072'
    config.location = 'us-east'
  end
else
  ##Production
  # StreamRails.configure do |config|
  #   config.api_key     = "dppcz8n6xmkc"
  #   config.api_secret  = "a4ze5h59su875zxuthz3je7xxz4cf23g9aqtbwzs3vc7gtr2rxx6rcezqs8eapsj"
  #   config.api_site_id = '2271'
  #   config.location = 'us-east'
  # end

  #staging
  StreamRails.configure do |config|
    config.api_key     = "bmn8pwxbswp7"
    config.api_secret  = "jgwcam5sa96unam7726rygu5gzhcbtdfr3fuvhwhc79ra8w3pakxywz38kpjcp3s"
    config.api_site_id = '1784'
    config.location = 'us-east'
  end
end