# frozen_string_literal: true

RSpec.shared_examples "logged in" do
  around do |ex|
    ENV["SPEC_LOGGED_IN"] = "true"
    ex.run
    ENV["SPEC_LOGGED_IN"] = nil
  end
end

RSpec.configure do |c|
  c.before(:suite) do
    TestService::SessionTest.instance
  end
end
