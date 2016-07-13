desc "Update currency rates, prices of variants in shopify and in app db"
task :update_currency_rates => :environment do 
  require 'open-uri'
  require 'json'
  
  currency_rates = JSON.parse(open("http://api.fixer.io/latest?symbols=GBP").string)
  File.write('db/currency_rates.txt', currency_rates["rates"])
  gbp_rate = currency_rates["rates"]["GBP"]
  binding.pry
  variants_with_pound_price = PriceCountriesProductVariant.where(currency:"STG")
  variants_with_pound_price.each do |variant|
    variant.update_attributes(price_in_euros: (variant.price / gbp_rate))
  end
  shop = Shop.first
  session = ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token) 
  ShopifyAPI::Base.activate_session(session)
  variants_with_pound_price.each do |variant|
    shopify_variant_id = variant.variant_id
    begin
      shopify_variant = ShopifyAPI::Variant.find(shopify_variant_id)
    rescue
      variant.destroy
    else
     shopify_variant.update_attributes(price: variant.price_in_euros)
    end
  end
end