# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :jsonb            not null
#  name       :string           not null
#  post_type  :string           default("standard"), not null
#  status     :string           default("pending"), not null
#  views      :bigint           default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_name  (name) USING gin
#
FactoryBot.define do
  factory :post do
    content do
      {
        message: FFaker::Lorem.phrase
      }
    end
    status { :ready }

    trait :with_reactions do
      after(:create) do |post|
        create(:reaction_counter, subject: post).tap do |reaction_counter|
          create_list(:reaction, 2, reaction_counter: reaction_counter)
        end
      end
    end

    trait :with_comments do
      after(:create) do |post|
        create(:comment_counter, subject: post).tap do |comment_counter|
          create_list(:comment, 2, :standard, comment_counter: comment_counter)
        end
      end
    end

    trait :with_test_attachments do
      after(:create) do |post|
        test_cdn_adapter = CdnStorageProvider.find_by!(adapter: "FileSystemAdapters::TestAdapter")
        image = SafeFile.open(Rails.root.join("spec/support/resources/picture.jpg"))
        image.close

        psm_file = create(:psm_file, :test_image).tap do |psm_file|
          create_list(:psm_file_variant, 3, :test_image_variant, psm_file: psm_file).each do |psm_file_variant|
            create(:psm_cdn_file, cdn_storage_provider: test_cdn_adapter, psm_file_variant: psm_file_variant)

            uploaded_file = FileSystemAdapters::UploadFile.new(psm_file_variant.external_file_name, image)
            test_cdn_adapter.upload(uploaded_file)
          end
        end

        create(:psm_attachment, subject: post, psm_file: psm_file)
      end
    end
  end
end
