class ProductsInfoController < ApplicationController
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
    products_ids = params[:products_ids]
    #remote_ip = '220.100.128.0' 
    #217.173.208.0 Ireland
    #220.100.128.0 UK
    #217.199.80.0 Rest of Europe
    remote_ip = request.remote_ip
    @ip = Ip.find_by(address: remote_ip)
    if @ip.nil?
      @region_id = 4
    else
      @region_id = @ip.region_id
    end
    @price_countries_product_variants = PriceCountriesProductVariant.where("product_id in (#{products_ids.join(',')}) and region_id = #{@region_id}")
    respond_to do |format|
      format.json #{ render status: :ok, :callback => params[:callback] }
    end
  end
end
