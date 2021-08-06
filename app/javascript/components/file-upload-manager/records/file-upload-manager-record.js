import {FileUploadRecord} from './upload-record';
import {
  fileUploadManagerState,
  fileUploadManagerStateManager,
} from '../file-upload-manager-state';
import {isEmpty} from 'lodash';

class FileUploadManagerRecord {
  constructor(state) {
    this.state = state;
    this.uploads = [];
  }

  async createUpload(subjectType, subjectId, files) {
    fileUploadManagerState.merge({show: true, uploadStatus: 'calculating-hash'});
    const uploadRecord = new FileUploadRecord(subjectType, subjectId, files, this);
    this.uploads.push(uploadRecord);
    await this.startProcessingUploads();
  }

  cancelUpload(sha256) {
    this.currentUpload.cancelUpload(sha256);
  }

  async startProcessingUploads() {
    if (this.__startedProcessingUplaods) return;
    this.__startedProcessingUplaods = true;
    try {
      this.currentUpload = this.uploads.shift();
      await this.currentUpload.run();
    } finally {
      this.__startedProcessingUplaods = false;
    }

    if (isEmpty(this.uploads)) {
      fileUploadManagerState.merge({message: null, uploadStatus: 'ready'});
      return setTimeout(() => {
        fileUploadManagerStateManager.reset();
      }, 20000);
    }

    return this.startProcessingUploads();
  }

  stopFileUploadFile(uploadId, filename) {

  }

  startUpload() {
    let nextFile;
    this.uploads.find((upload) => {
      return nextFile = upload.getPendingFile();
    });

    if (!nextFile) return;

    fileUploadManagerState.merge({
      uploadFile: nextFile,
    });
    nextFile.startUpload();
  }
}

export const fileUploadManager = new FileUploadManagerRecord(fileUploadManagerState);
