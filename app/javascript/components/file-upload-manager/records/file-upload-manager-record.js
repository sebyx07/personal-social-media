import {FileUploadRecord} from './upload-record';
import {fileUploadManagerState} from '../file-upload-manager-state';
import pLimit from 'p-limit';

class FileUploadManagerRecord {
  constructor(state) {
    this.state = state;
    this.uploads = [];
  }

  async testCreateUpload(subjectType, subjectId, files) {
    fileUploadManagerState.merge({show: true});
  }

  async createUpload(subjectType, subjectId, files) {
    const uploadRecord = new FileUploadRecord(subjectType, subjectId, files, this);
    this.uploads.push(uploadRecord);
    await uploadRecord.createDBRecord();

    const throttlePromise = pLimit(2);

    const instantUploadsPromises = uploadRecord.instantUploads.map((instantUpload) => {
      console.log(instantUpload);
      return throttlePromise(() => {
        return instantUpload.createUploadFileRecord();
      });
    });

    await Promise.all(instantUploadsPromises);

    // this.startUpload();
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
