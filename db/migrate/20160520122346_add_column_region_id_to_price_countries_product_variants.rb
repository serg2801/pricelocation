class AddColumnRegionIdToPriceCountriesProductVariants < ActiveRecord::Migration
  def change
    add_reference :price_countries_product_variants, :region, index: true, foreign_key: true
  end
end
