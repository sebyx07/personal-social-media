import {FileUploadFileRecord} from './upload-file-record';
import {axios} from '../../../utils/axios';
import {fileUploadManagerStateManager} from '../file-upload-manager-state';
import {generateRandomId} from '../../../lib/string/generate-random-id';
import {getSha256ForFile} from '../../../lib/file/get-sha-256-for-file';

export class InstantUploadFileRecord {
  constructor(file, uploadRecord, listIndex) {
    this.file = file;
    file.instantUpload = this;
    this.uploadRecord = uploadRecord;
    this.shaPercentage = 0;
    this.listIndex = listIndex;
    this.status = 'pending';
  }

  async run() {
    fileUploadManagerStateManager.addUploadFile({
      clientId: generateRandomId(),
      currentSpeed: null,
      etaSeconds: null,
      fileName: this.file.name,
      message: 'computing sha256',
      progress: 0,
      size: this.file.size,
      status: 'pending',
      uploadedAlreadyBytes: null,
    });
    this.uploadFileState = fileUploadManagerStateManager.getUploadFileByIndex(this.listIndex);
    await this.createUploadFileRecord();
  }

  startUploading() {
    if (this.status === 'ready') return;

    this.uploader = new FileUploadFileRecord(this);
    return this.uploader.startUpload();
  }

  async createUploadFileRecord() {
    this.sha256 = await getSha256ForFile(this.file, this.handleShaProgress.bind(this));
    this.uploadFileState.merge({message: 'sha256 ready', sha256: this.sha256});

    const body = {
      uploadFile: {
        fileName: this.file.name,
        sha256: this.sha256,
        uploadId: this.uploadRecord.record.id,
      },
    };
    const {data: {uploadFile}} = await axios.post('/instant_upload_files', body);
    this.uploadFileRecord = uploadFile;
    const change = {status: uploadFile.status};
    if (uploadFile.status === 'ready') {
      change.progress = 100;
    }
    this.uploadFileState.merge(change);
    this.status = uploadFile.status;
  }

  handleShaProgress(percentage) {
    this.uploadFileState.merge({
      progress: percentage,
    });
  }

  cancelUpload() {
    delete this.uploadFileState;
    fileUploadManagerStateManager.removeUploadFile(this.listIndex);
  }

  finish() {
    this.status = 'ready';
    this.uploadFileState.merge({progress: 100, status: 'ready'});
  }
}