desc "Imports ips, related to country, to region [:region_name, :country1_name, :country2_name, ...]"
task :import_ip_range_to_region, [:region_name] => :environment do |t, args|
  require 'geoip'
  region_name = args[:region_name]
  @region = Region.find_by(name: region_name) || Region.create(name: region_name)
  @geoip ||= GeoIP.new("db/GeoIP.dat")
  country_ip_hash = {}
  @geoip.each_by_ip do |ip|
    country_ip_hash[@geoip.country(IPAddr.new(ip, Socket::AF_INET).to_s).country_name] ||= []
    country_ip_hash[@geoip.country(IPAddr.new(ip, Socket::AF_INET).to_s).country_name].push IPAddr.new(ip, Socket::AF_INET).to_s
  end
  
  args.extras.each do |country_name|
    country_ip_hash[country_name].each do |ip|
      @ip = Ip.find_by(:address => ip) || Ip.create(:address => ip, :region_id => @region.id)
    end
  end
  
end


