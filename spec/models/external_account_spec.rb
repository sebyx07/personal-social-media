# frozen_string_literal: true

# == Schema Information
#
# Table name: external_accounts
#
#  id                    :bigint           not null, primary key
#  email_ciphertext      :text
#  name                  :string           not null
#  password_ciphertext   :text
#  public_key_ciphertext :text
#  secret_ciphertext     :text
#  secret_key_ciphertext :text
#  service               :string           not null
#  status                :string           default("initializing"), not null
#  usage                 :string           not null
#  username_ciphertext   :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require "rails_helper"

RSpec.describe ExternalAccount, type: :model do
end
