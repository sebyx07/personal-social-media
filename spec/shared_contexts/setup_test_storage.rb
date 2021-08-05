# frozen_string_literal: true

RSpec.shared_examples "setup test storage" do
  before do
    create(:cdn_storage_provider, :test)
    create(:permanent_storage_provider, :test)
  end
end
