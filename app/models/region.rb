class Region < ActiveRecord::Base
    has_many :ips
    has_many :price_countries_product_variants
end
