# frozen_string_literal: true

class PeerPresenter
  def initialize(peer)
    @peer = peer
  end

  def render_low_data
    {
      id: @peer.id,
      name: @peer.name,
      is_me: @peer.is_me,
      nickname: @peer.nickname,
      status: @peer.status,
      avatar: PeersService::Gravatar.new(email_hexdigest: @peer.email_hexdigest).url(size: 120)
    }
  end
end
