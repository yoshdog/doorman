require 'base64'
require 'digest'
require 'openssl'
require 'securerandom'
require 'rack/request'

module RequestSigning
  class RequestVerificationError < StandardError
  end

  def self.generateAuthHeader(verb, uri, secret_id, secret_key)
    timestamp = Time.now.utc.to_i
    nonce = SecureRandom.hex

    mac = sign(timestamp, nonce, verb, uri, secret_key)

    "MAC id=\"#{secret_id}\", ts=\"#{timestamp}\", nonce=\"#{nonce}\", mac=\"#{mac}\""
  end

  def self.sign(timestamp, nonce, verb, uri, secret_key)
    algorithm = OpenSSL::Digest::SHA256.new

    signature = [
      timestamp,
      nonce,
      verb.to_s.upcase,
      uri.request_uri,
      uri.host,
      uri.port,
      '', nil
    ].join("\n")

    Base64.strict_encode64(OpenSSL::HMAC.digest(algorithm, secret_key, signature))
  end

  REGEX = /id="(\S+)", ts="(\S+)", nonce="(\S+)", mac="(\S+)"/
  def self.verify!(request, secret_store)
    auth_header = request.env['HTTP_AUTHORIZATION']
    secret_id, timestamp, nonce, signature = REGEX.match(auth_header).to_a.slice(1..-1)
    secret_key = secret_store.fetch(secret_id)
    uri = URI(request.url)
    request_signature = sign(timestamp, nonce, request.request_method, uri, secret_key)

    if signature != request_signature
      raise RequestVerificationError
    end
  end
end
