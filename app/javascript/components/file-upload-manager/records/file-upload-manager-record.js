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
    this.handleNextUpload();
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
      fileUploadManagerState.batch(() => {
        fileUploadManagerStateManager.reset();
        this.handleNextUpload();
      });
    } finally {
      this.__startedProcessingUplaods = false;
    }

    if (isEmpty(this.uploads)) {
      return fileUploadManagerStateManager.reset();
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

  handleNextUpload() {
    fileUploadManagerState.merge({show: true, uploadStatus: 'calculating-hash'});
  }
}

export const fileUploadManager = new FileUploadManagerRecord(fileUploadManagerState);
