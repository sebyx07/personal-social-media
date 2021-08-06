import {InstantUploadFileRecord} from './instant-upload-file-record';
import {axios, csrfToken} from '../../../utils/axios';
import {fileUploadManagerStateManager as stateManager} from '../file-upload-manager-state';
import Flow from '@flowjs/flow.js';
import pLimit from 'p-limit';

export class FileUploadRecord {
  constructor(subjectType, subjectId, files, manager) {
    this.subjectId = subjectId;
    this.subjectType = subjectType;
    this.manager = manager;
    this.instantUploads = Array.from(files).map((f, i) => new InstantUploadFileRecord(f, this, i));
    this.status = 'pending';
  }

  async run() {
    stateManager.setSubject(this.subjectId, this.subjectType);
    stateManager.setMessage('Creating upload');
    await this.createDBRecord();
    const limit = pLimit(3);
    stateManager.setMessage('Creating upload files');
    const runPromises = this.instantUploads.map((instantUpload) => {
      return limit(() => {
        return instantUpload.run();
      });
    });

    await Promise.all(runPromises);

    const uploadPromises = this.instantUploads.map((instantUpload) => {
      return limit(() => {
        return instantUpload.startUploading();
      });
    });

    await Promise.all(uploadPromises);
  }

  removeFileRecord(fileRecord) {
    this.files = this.files.filter((f) => f !== fileRecord);
    this.manager.startUpload();
  }

  getPendingFile() {
    return this.files.find((f) => f.status === 'pending');
  }

  async createDBRecord() {
    const {data: {upload: record}} = await axios.post('/uploads', {upload: {
      subjectId: this.subjectId,
      subjectType: this.subjectType,
    }});

    return this.record = record;
  }

  finishFile() {
    this.manager.startUpload();
  }

  createFlow() {
    if (!this.record) throw 'no this.record'; // eslint-disable-line no-throw-literal

    return new Flow({
      headers: {
        'PSM-UPLOAD-ID': this.record.id,
        'X-CSRF-Token': csrfToken,
      },
      prioritizeFirstAndLastChunk: true,
      progressCallbacksInterval: 2000,
      speedSmoothingFactor: 0.02,
      target: '/upload_chunks',
    });
  }

  cancelUpload(sha256) {
    const uploadFile = this.instantUploads.find((instantUpload) => {
      return instantUpload.sha256 === sha256;
    });

    uploadFile.cancelUpload();
    this.instantUploads = this.instantUploads.filter((instantUpload) => instantUpload !== uploadFile);
  }
}
