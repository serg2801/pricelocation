json.products @price_countries_product_variants do |product| 
  json.(product, :product_id, :price, :currency, :variant_id)
end
json.gbp_rate @gbp_rate