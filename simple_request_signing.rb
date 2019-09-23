require 'base64'
require 'digest'
require 'openssl'
require 'securerandom'

module SimpleRequestSigning
  def self.sign(verb, uri, secret_key)
    algorithm = OpenSSL::Digest::SHA256.new
    signature = [
      verb.to_s.upcase,
      uri.request_uri,
    ].join("\n")
    Base64.strict_encode64(OpenSSL::HMAC.digest(algorithm, secret_key, signature))
  end
end
