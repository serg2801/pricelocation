class AddColumnPriceInEurosToPriceCountriesProductVariants < ActiveRecord::Migration
  def change
    add_column :price_countries_product_variants, :price_in_euros, :float
  end
end
