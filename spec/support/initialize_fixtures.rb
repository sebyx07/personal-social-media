# frozen_string_literal: true

RSpec.configure do |c|
  c.before(:suite) do
    FactoryBot.build(:profile).tap do |profile|
      profile.send(:generate_private_key)
      profile.send(:generate_signing_key)
      Current.__set_manually_profile(profile)
    end

    FactoryBot.build(:setting).tap do |setting|
      Current.__set_manually_settings(setting)
    end
  end
end

RSpec.shared_examples "logged in" do
  around do |ex|
    ENV["SPEC_LOGGED_IN"] = "true"
    ex.run
    ENV["SPEC_LOGGED_IN"] = nil
  end
end
