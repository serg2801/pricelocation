class CreatePriceCountriesProductVariants < ActiveRecord::Migration
  def change
    create_table :price_countries_product_variants do |t|
      
      t.integer :variant_id, :limit => 8
      t.string :name
      t.integer :price
      t.string :currency

      t.timestamps null: false
    end
  end
end
