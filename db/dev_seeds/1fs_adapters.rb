# frozen_string_literal: true

if CdnStorageProvider.count < 1
  CdnStorageProvider.create!(adapter: "FileSystemAdapters::LocalFileSystemAdapter")
end

if PermanentStorageProvider.count < 1
  PermanentStorageProvider.create!(adapter: "FileSystemAdapters::LocalFileSystemAdapter")
end
