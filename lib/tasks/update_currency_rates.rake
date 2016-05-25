desc "make tea"
task :update_currency_rates => :environment do 
  require 'open-uri'
  require 'json'
  currency_rates = JSON.parse(open("https://openexchangerates.org/api/latest.json?app_id=54723a7be9e748f3a24125d88f10b915&base=EUR").string)
  p currency_rates
end