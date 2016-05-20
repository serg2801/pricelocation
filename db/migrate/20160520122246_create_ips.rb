class CreateIps < ActiveRecord::Migration
  def change
    create_table :ips do |t|
      t.string :address
      t.references :region, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
