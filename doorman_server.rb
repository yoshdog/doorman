require 'sinatra'

%i(get post put delete patch).each do |method|
   send method, '/*' do
    status 200
   end
 end
