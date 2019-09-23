require 'sinatra'
require_relative 'request_signing'

password = "tacos is the password"

before do
  if request.env['HTTP_AUTHORIZATION'] != password
    halt 401
  end
end

%i(get post put delete patch).each do |method|
   send method, '/*' do
    status 200
   end
 end
