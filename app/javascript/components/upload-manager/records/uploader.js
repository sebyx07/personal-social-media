import {Upload, clearNotFinishedUploads, getNotFinishedUploads, saveUnfinishedAsyncUploads} from './upload';
import {createState} from '@hookstate/core';
import {fileManagerEventBus} from '../../../lib/event-bus/file-manager-event-bus';
import {isEmpty} from 'lodash';

class Uploader {
  initialStatus() {
    this.uploads().then((uploads) => {
      if (isEmpty(uploads)) return;

      uploadManagerState.merge({
        status: 'retry-uploads-after-restart',
      });
    });
    return 'pending';
  }

  async handleNewUpload({subjectId, subjectType, files}) {
    files = Array.from(files);

    const newUpload = new Upload(subjectType, subjectId, files);
    const uploads = await this.uploads();
    uploads.push(newUpload);
    uploadManagerState.merge({
      status: 'uploading',
    });
    await newUpload.createRecord();
  }

  async uploads() {
    if (!this._uploads) {
      this._uploads = await getNotFinishedUploads();
    }

    return this._uploads;
  }

  async clearNotFinishedUploads() {
    this._uploads = [];
    uploadManagerState.merge({status: 'pending'});
    return clearNotFinishedUploads();
  }

  async saveAllUnfinishedUploads() {
    return saveUnfinishedAsyncUploads();
  }
}

const uploader = new Uploader();
export const uploadManagerState = createState({
  status: uploader.initialStatus(),
});

fileManagerEventBus.on('new-upload', (arg) => {
  uploader.handleNewUpload(arg);
});

fileManagerEventBus.on('clear-unfinished-uploads', () => {
  uploader.clearNotFinishedUploads();
});

// $( window ).on('unload', function( event ) {
//   alert("a")
//   uploader.saveAllUnfinishedUploads();
//   return confirm("Do you really want to refresh?");
// });

