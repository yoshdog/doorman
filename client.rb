require 'net/http'
require 'uri'
require_relative './simple_request_signing'
require 'digest'
require 'openssl'
require 'base64'

# uri = URI('https://support.zd-dev.com/api/services/zis/configs/salesforce?scope=*')
uri = URI('http://localhost:1111/ping')
request = Net::HTTP::Get.new(uri)

secret_key = "abc1234"
auth_header = SimpleRequestSigning.sign("GET", uri, secret_key)
request['Authorization'] = auth_header
puts auth_header

response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

puts "Status: #{response.code}"
