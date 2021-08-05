import {axios} from '../../../utils/axios';
import {getSha256ForFile} from '../../../lib/file/get-sha-256-for-file';

export class InstantUploadFileRecord {
  constructor(file, uploadRecord) {
    this.file = file;
    this.uploadRecord = uploadRecord;
    this.shaPercentage = 0;
  }

  async createUploadFileRecord() {
    const sha256 = await getSha256ForFile(this.file, this.handleShaProgress.bind(this));
    console.log(sha256);
    const body = {
      uploadFile: {
        fileName: this.file.name,
        sha256,
        uploadId: this.uploadRecord.record.id,
      },
    };
    const {data: {uploadFile}} = await axios.post('/instant_upload_files', body);
    this.uploadFileRecord = uploadFile;
    console.log(uploadFile);
  }

  handleShaProgress(percentage) {
    console.log(this.file.name, percentage);
  }
}