require 'net/http'
require 'uri'
require_relative './request_signing'
require 'securerandom'

# uri = URI('https://support.zd-dev.com/api/services/zis/configs/salesforce?scope=*')
uri = URI('http://localhost:1111/ping')
request = Net::HTTP::Get.new(uri)

secret_id = "zis_engine123" # KRAGLE_OAUTH_SECRET
secret_key = "abc1234" # KRAGLE_OAUTH_KEY

auth_header = "tacos is the password"
request['Authorization'] = auth_header
puts auth_header

response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

puts "Status: #{response.code}"
