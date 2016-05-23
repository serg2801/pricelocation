class ChangePriceColumnTypeInPriceCountriesProductVariants < ActiveRecord::Migration
  def self.up
    change_table :price_countries_product_variants do |t|
      t.change :price, :float
    end
  end
  
  def self.down
    change_table :price_countries_product_variants do |t|
      t.change :price, :integer
    end
  end
end
