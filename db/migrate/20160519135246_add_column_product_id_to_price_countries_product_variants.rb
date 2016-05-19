class AddColumnProductIdToPriceCountriesProductVariants < ActiveRecord::Migration
  def change
    add_column :price_countries_product_variants, :product_id, :integer
  end
end
