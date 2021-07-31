# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAccount do
  describe "wasabi" do
    around do |ex|
      VCR.use_cassette("ExternalAccount/wasabi/bootstrap") do
        ex.run
      end
    end

    subject do
      create(:external_account, :wasabi)
    end

    it "bootstraps the account", vcr: { record: :once, match_requests_on: [] }, skip: ENV["WASABI_SECRET_KEY"].blank? do
      subject.start_bootstrap
    end
  end
end
