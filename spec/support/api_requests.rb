# frozen_string_literal: true

module RequestsApiSpecHelper
  def json
    return @json if defined? @json

    encrypted_result = EncryptionService::EncryptedResult.from_json(raw_json)
    @json = JSON.parse(__decrypt.decrypt(encrypted_result)).with_indifferent_access
  end

  def raw_json
    return @raw_json if defined? @raw_json

    @raw_json = JSON.parse(response.body).with_indifferent_access
  end

  def encrypt_params(params)
    encrypted = __encrypt.encrypt(params.to_json)
    encrypted.as_json.merge!(
      domain_name: __encrypt.encrypt(peer.domain_name).as_json,
      public_key: EncryptionService::EncryptedContentTransform.to_json(peer.public_key)
    ).to_json
  end

  def __decrypt
    @__decrypt ||= EncryptionService::Decrypt.new(peer.public_key)
  end

  def __encrypt
    @__encrypt ||= EncryptionService::Encrypt.new(peer.public_key)
  end

  def headers
    {
      "accept": "application/json",
      "content-type": "application/json",
    }
  end
end

RSpec.shared_examples "api request" do
  include RequestsApiSpecHelper
  let(:peer) { create(:peer) }
end
