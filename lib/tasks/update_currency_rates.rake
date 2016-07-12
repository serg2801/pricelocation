desc "Update currency rates, prices of variants in shopify and in app db"
task :update_currency_rates => :environment do 
  require 'open-uri'
  require 'json'
  currency_rates = JSON.parse(open("http://api.fixer.io/latest?symbols=GBP").string)
  File.write('db/currency_rates.txt', currency_rates["rates"])
  gbp_rate = currency_rates["rates"]["GBP"]
  PriceCountriesProductVariant.where(currency:"STG").each do |price_variant|
    price_variant.update_attributes(price_in_euros: (price_variant.price / gbp_rate))
  end
  ShopifyAPI::Session.setup({:api_key => ShopifyApp.configuration.api_key, :secret => ShopifyApp.configuration.secret})
  scope = ["write_products"]
  shop_domain = Shop.first.shopify_domain 
  binding.pry
end