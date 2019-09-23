require 'net/http'
require 'uri'

# uri = URI('https://support.zd-dev.com/api/services/zis/configs/salesforce?scope=*')
uri = URI('http://localhost:1111/ping')
request = Net::HTTP::Get.new(uri)

response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

puts "Status: #{response.code}"
