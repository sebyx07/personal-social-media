# frozen_string_literal: true

class PeerPresenter
  def initialize(peer)
    @peer = peer
  end

  def render_low_data
    {
      id: @peer.id,
      name: @peer.name,
      nickname: @peer.nickname,
      status: @peer.status,
      avatar: avatar,
      public_key: public_key,
      verify_key: verify_key,
      domain_name: @peer.domain_name
    }
  end

  def render_in_signature
    {
      public_key: public_key,
      verify_key: verify_key,
    }
  end

  def render_with_is_me
    render_low_data.merge({
      is_me: @peer.is_me,
    })
  end

  private
    def avatar
      return @peer.avatar if @peer.respond_to?(:avatar)
      PeersService::Gravatar.new(email_hexdigest: @peer.email_hexdigest).url(size: 120)
    end

    def public_key
      EncryptionService::EncryptedContentTransform.to_json(@peer.public_key.to_s)
    end

    def verify_key
      EncryptionService::EncryptedContentTransform.to_json(@peer.verify_key.to_s)
    end
end
