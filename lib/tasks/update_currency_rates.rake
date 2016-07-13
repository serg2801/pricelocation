desc "Update currency rates, prices of variants in shopify and in app db"
task :update_currency_rates => :environment do 
  require 'open-uri'
  require 'json'
  
  currency_rates = JSON.parse(open("http://api.fixer.io/latest?symbols=GBP").string)
  File.open('public/currency_rates.txt', 'w') do |f|
    gbp_rate = JSON.generate(currency_rates["rates"])
    f.write(gbp_rate)
  end
  gbp_rate = currency_rates["rates"]["GBP"]
  variants_with_pound_price = PriceCountriesProductVariant.where(currency:"STG")
  variants_with_pound_price.each do |variant|
    _price_in_euros = (variant.price / gbp_rate).round(2)
    variant.update_attributes(price_in_euros: _price_in_euros)
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