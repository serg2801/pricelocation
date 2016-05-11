class HomeController < AuthenticatedController
  require 'geoip'
  def index
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
    
    @geoip ||= GeoIP.new("db/GeoIP.dat")    
    remote_ip = request.remote_ip 
    binding.pry
    if remote_ip != "127.0.0.1" #todo: check for other local addresses or set default value
      location_location = @geoip.country(remote_ip)
      if location_location != nil     
        @country = location_location[2]
      end
    end
  end
end
