import {FileUploadFileRecord} from './upload-file-record';
import {axios} from '../../../utils/axios';
import Flow from '@flowjs/flow.js';

export class FileUploadRecord {
  constructor(subjectType, subjectId, files, manager) {
    this.subjectId = subjectId;
    this.subjectType = subjectType;
    this.manager = manager;
    this.files = Array.from(files).map((f) => new FileUploadFileRecord(f, this));
    this.status = 'pending';
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

    console.log(record);
    this.record = record;
  }

  finishFile() {
    this.manager.startUpload();
  }

  createFlow() {
    if (!this.record) throw 'no this.record'; // eslint-disable-line no-throw-literal

    return new Flow({
      headers: {
        'PSM-UPLOAD-ID': this.record.id,
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      target: '/upload_chunks',
      prioritizeFirstAndLastChunk: true
    });
  }
}
