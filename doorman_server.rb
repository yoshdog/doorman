require 'sinatra'
require 'jwt'
require 'net/http'
require 'uri'
require_relative 'request_signing'

secret_store = {
  "zis_engine123" => "abc1234",
  "aws_integration123" => "abc1234"
}

doorman_secret = "secret_key"

account_info = {
  account_id: 1,
  user: 2
}

before do
  begin
    RequestSigning.verify!(request, secret_store)
  rescue RequestSigning::RequestVerificationError => e
    puts e
    halt 401
  end
end

%i(get post put delete patch).each do |method|
   send method, '/*' do
    jwt_token = JWT.encode account_info, doorman_secret, 'HS256'
    # Proxy request but include doorman headers
    uri = URI('http://localhost:2222/ping')

    proxied_request = Net::HTTP::Get.new(uri)
    proxied_request['X-Zendesk-Doorman'] = jwt_token
    proxied_request['X-Zendesk-Doorman-Auth-Response'] = 200
    proxied_response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(proxied_request)
    end
    status proxied_response.code
   end
 end
