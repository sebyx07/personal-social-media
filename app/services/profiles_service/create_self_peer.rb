# frozen_string_literal: true

module ProfilesService
  class CreateSelfPeer
    attr_reader :profile
    def initialize(profile)
      @profile = profile
    end

    def call!
      Peer.create!(
        is_me: true,
        domain_name: profile.domain_name,
        nickname: profile.nickname,
        name: profile.name,
        public_key: profile.public_key.to_s,
        verify_key: profile.verify_key.to_s,
        email_hexdigest: profile.email_hexdigest
      )
    end
  end
end
