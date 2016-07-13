class ProductsInfoController < ApplicationController
  GEOIP_SERVICE_HOST = "http://ip2c.org/"
  
  require 'open-uri'
  
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end
  
  def show
    @gbp_rate = JSON.parse(open("public/currency_rates.txt").read)["GBP"]
    products_ids = params[:products_ids]
    #remote_ip = '217.173.208.0' 
    #217.173.208.0 Ireland
    #185.54.84.0 UK
    #217.199.80.0 Rest of Europe
    remote_ip = request.remote_ip
    country_name = open("#{GEOIP_SERVICE_HOST}?ip=#{remote_ip}") { |country_data| country_data.read }.split(";").last
    country = Country.where(name: country_name)[0]
    if country.nil?
      region_id = 4
    else
      region_id = country.region.id
    end
    @price_countries_product_variants = PriceCountriesProductVariant.where("product_id in (#{products_ids.join(',')}) and region_id = #{region_id}")
    respond_to do |format|
      format.json #{ render status: :ok, :callback => params[:callback] }
    end
  end
end
