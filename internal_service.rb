require 'sinatra'
require 'jwt'

doorman_secret = "secret_key"

before do
  # Verify DOORMAN Headers
  if request.env['HTTP_X_ZENDESK_DOORMAN_AUTH_RESPONSE'] != "200"
    puts request.env
    halt 401
  end

  begin
    @payload, @header = JWT.decode request.env['HTTP_X_ZENDESK_DOORMAN'], doorman_secret, true, { algorithm: 'HS256' }
  rescue JWT::VerificationError => e
    halt 403
  end
end

%i(get post put delete patch).each do |method|
   send method, '/*' do
    puts @payload

    # Request is authenicated & its safe to use the account_id & user_id from the @payload

    status 200
   end
 end
