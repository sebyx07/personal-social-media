# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_attachments
#
#  id           :bigint           not null, primary key
#  subject_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  psm_file_id  :bigint           not null
#  subject_id   :bigint           not null
#
# Indexes
#
#  index_psm_attachments_on_psm_file_id  (psm_file_id)
#  index_psm_attachments_on_subject      (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (psm_file_id => psm_files.id)
#
require "rails_helper"

RSpec.describe PsmAttachment, type: :model do
  describe "callbacks" do
    describe "after destroy" do
      let(:psm_file) { create(:psm_file) }

      let(:attachments) do
        create_list(:psm_attachment, 2, psm_file: psm_file)
      end

      before { attachments }

      describe "#destroy_psm_file_if_no_attachments" do
        it "destroys psm_file if no other attachments" do
          expect do
            attachments.pop.destroy
          end.not_to change { PsmFile.count }

          expect do
            attachments.pop.destroy
          end.to change { PsmFile.count }.by(-1)
        end
      end
    end
  end
end
