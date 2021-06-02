# frozen_string_literal: true

RSpec.shared_examples "two people" do
  include RequestsApiSpecHelper

  def _test_session_instance
    TestService::SessionTest.instance
  end

  before do
    _test_session_instance.text_ctx = self
    my_peer.reload
  end

  after do
    _test_session_instance.reset!
  end

  def reset_full!
    _test_session_instance.reset_full!
  end

  def my_profile
    _test_session_instance.my_profile
  end

  def other_profile
    _test_session_instance.other_profile
  end

  def my_peer
    my_profile.peer
  end

  def reverse_my_peer
    other_peer
  end

  def reverse_other_peer
    my_peer
  end

  def other_peer
    other_profile.peer
  end

  def setup_my_peer(statuses:)
    my_peer.update!(status: statuses)
  end

  def setup_other_peer(statuses:)
    other_peer.update!(status: statuses)
  end

  def take_over_wrap!
    _test_session_instance.take_over_wrap! do
      yield
    end
  end
end
