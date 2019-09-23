require 'sinatra'
require_relative 'request_signing'

secret_store = {
  "zis_engine123" => "abc1234",
  "aws_integration123" => "abc1234"
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
    status 200
   end
 end
