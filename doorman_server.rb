require 'sinatra'
require_relative 'request_signing'

secret_key = "abc1234"
password = "tacos is the password"
algorithm = OpenSSL::Digest::SHA256.new

before do
  if request.env['HTTP_AUTHORIZATION'] != Base64.strict_encode64(OpenSSL::HMAC.digest(algorithm, secret_key, password))
    halt 401
  end
end

%i(get post put delete patch).each do |method|
   send method, '/*' do
    status 200
   end
 end
