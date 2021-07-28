# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAccount do
  describe "mega_upload" do
    around do |ex|
      VCR.use_cassette("ExternalAccount/mega_upload/bootstrap") do
        ex.run
      end
    end

    before do
      expect_any_instance_of(ExternalAccount).to receive(:start_bootstrap).and_return(true)
    end

    subject do
      create(:external_account, :mega_upload)
    end

    it "bootstraps the account", vcr: { record: :once, match_requests_on: [] }, skip: ENV["MEGA_UPLOAD_EMAIL"].blank? do
      subject.start_bootstrap
    end
  end
end
