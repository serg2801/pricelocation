ShopifyApp.configure do |config|
  config.api_key = "e520db04e2eff2f5052dbb73ff673834"
  config.secret = "25f72f67fe9c83066ea8a8d8a90b2bdf"
  config.redirect_uri = "https://pricelocation.herokuapp.com/auth/shopify/callback"
  config.scope = "read_orders, read_products, write_products"
  config.embedded_app = true
end
