require 'net/http'
require 'uri'
require_relative './request_signing'
require 'digest'
require 'openssl'
require 'base64'

# uri = URI('https://support.zd-dev.com/api/services/zis/configs/salesforce?scope=*')
uri = URI('http://localhost:1111/ping')
request = Net::HTTP::Get.new(uri)


secret_key = "abc1234"
password = "tacos is the password"
algorithm = OpenSSL::Digest::SHA256.new

auth_header = Base64.strict_encode64(OpenSSL::HMAC.digest(algorithm, secret_key, password))
request['Authorization'] = auth_header
puts auth_header

response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

puts "Status: #{response.code}"
