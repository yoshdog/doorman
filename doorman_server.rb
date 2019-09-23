require 'sinatra'
require_relative 'request_signing'

before do
  if request.env['HTTP_AUTHORIZATION'] != "tacos is the password"
    halt 401
  end
end

%i(get post put delete patch).each do |method|
   send method, '/*' do
    status 200
   end
 end
