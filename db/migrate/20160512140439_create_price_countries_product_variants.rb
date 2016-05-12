class CreatePriceCountriesProductVariants < ActiveRecord::Migration
  def change
    create_table :price_countries_product_variants do |t|
      
      t.integer :variant_id
      t.string :name
      t.decimal :price, :precision => 8, :scale => 2
      t.string :currency

      t.timestamps null: false
    end
  end
end
