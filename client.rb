require 'net/http'
require 'uri'
require_relative './request_signing'

# uri = URI('https://support.zd-dev.com/api/services/zis/configs/salesforce?scope=*')
uri = URI('http://localhost:1111/ping')
request = Net::HTTP::Get.new(uri)

password = "tacos is the password"
request['Authorization'] = password
puts request['Authorization']

response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

puts "Status: #{response.code}"
