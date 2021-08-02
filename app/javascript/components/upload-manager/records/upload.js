import {axios} from '../../../utils/axios';
import localforage from 'localforage';

export class Upload {
  constructor(subjectType, subjectId, files) {
    this.subjectType = subjectType;
    this.subjectId = subjectId;
    this.files = files;
  }

  serialize() {
    if (!this.record) return null;

    return {
      id: this.record.id,
      subjectId: this.subjectId,
      subjectType: this.subjectType,
    };
  }

  static loadFromJson(json) {
    new Upload(json.subjectType, json.subjectId, []);
  }

  async createRecord() {
    const {data: {upload: record}} = await axios.post('/uploads', {upload: {
      subjectId: this.subjectId,
      subjectType: this.subjectType,
    }});

    console.log(record);
    this.record = record;
  }
}

export async function getNotFinishedUploads() {
  const uploadNotFinished = await localforage.getItem('upload-manager/uploads-not-finished');
  if (!uploadNotFinished) return [];
  return uploadNotFinished.map((upload) => {
    return Upload.loadFromJson(upload);
  });
}


export function clearNotFinishedUploads() {
  return localforage.removeItem('upload-manager/uploads-not-finished');
}

export function saveUnfinishedAsyncUploads(uploads) {
  const unfinished = uploads.filter((upload) => {
    return upload.status !== 'ready';
  });

  const serializedUploads = unfinished.map((upload) => {
    return upload.serialize();
  });
  console.log('dawaa');
  console.log('dawaa');
  console.log('dawaa');

  return localforage.setItem('upload-manager/uploads-not-finished', serializedUploads);
}
