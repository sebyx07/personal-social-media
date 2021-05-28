# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id                         :bigint           not null, primary key
#  backup_password_ciphertext :string           not null
#  email                      :string           not null
#  name                       :string           not null
#  nickname                   :string           not null
#  password_digest            :string           not null
#  password_plain             :string
#  pk_ciphertext              :text             not null
#  sk_ciphertext              :text             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "private #generate_private_key" do
    let(:profile) { build(:profile) }
    subject do
      profile.send(:generate_private_key)
      profile.save!
    end

    it "sets the private_key" do
      subject
      expect(profile.private_key).to be_present
    end
  end
end
