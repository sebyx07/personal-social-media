import {FileUploadRecord} from './upload-record';
import {createState} from '@hookstate/core';

class FileUploadManagerRecord {
  constructor(state) {
    this.state = state;
    this.uploads = [];
  }

  async createUpload(subjectType, subjectId, files) {
    const uploadRecord = new FileUploadRecord(subjectType, subjectId, files, this);
    this.uploads.push(uploadRecord);
    await uploadRecord.createDBRecord();
    this.startUpload();
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

export const fileUploadManagerState = createState({
  status: 'pending',
  uploadFile: null,
  uploadPercentage: 0,
});

export const fileUploadManager = new FileUploadManagerRecord(fileUploadManagerState);
