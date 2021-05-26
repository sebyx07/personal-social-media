# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_cdn_files
#
#  id                  :bigint           not null, primary key
#  external_file_name  :string           not null
#  size_bytes          :bigint           default(0), not null
#  status              :string           default("pending"), not null
#  upload_percentage   :integer          default(0), not null
#  url                 :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  external_account_id :bigint           not null
#  psm_file_variant_id :bigint           not null
#
# Indexes
#
#  idx_psm_cdn_files_variant_to_external_account  (psm_file_variant_id,external_account_id) UNIQUE
#  index_psm_cdn_files_on_external_account_id     (external_account_id)
#  index_psm_cdn_files_on_psm_file_variant_id     (psm_file_variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (external_account_id => external_accounts.id)
#  fk_rails_...  (psm_file_variant_id => psm_file_variants.id)
#
require "rails_helper"

RSpec.describe PsmCdnFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
