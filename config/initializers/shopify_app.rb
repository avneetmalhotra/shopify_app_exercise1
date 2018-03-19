ShopifyApp.configure do |config|
  config.application_name = "exercise 1-2"
  config.api_key = ENV['shopifyapp_api_key']
  config.secret = ENV['shopifyapp_secret']
  config.scope = "read_orders, write_orders"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
