require 'sinatra'
require_relative 'simple_request_signing'
require 'uri'

secret_key = "abc1234"
before do
  if request.env['HTTP_AUTHORIZATION'] != SimpleRequestSigning.sign(request.request_method, URI(request.url), secret_key)
    halt 401
  end
end

%i(get post put delete patch).each do |method|
   send method, '/*' do
    status 200
   end
 end
