import {clone} from 'lodash';
import {createState, none} from '@hookstate/core';

const initialState = {
  message: null,
  show: false,
  uploadFile: null,
  uploadFiles: [],
  uploadPercentage: 0,
  uploadStatus: null,
  uploadSubject: {},
};

export const fileUploadManagerState = createState(clone(initialState));
export const fileUploadManagerStateManager = {
  addUploadFile(uploadFile) {
    fileUploadManagerState.uploadFiles.merge([uploadFile]);
  },
  getUploadFileByIndex(index) {
    return fileUploadManagerState.uploadFiles[index];
  },

  removeUploadFile(index) {
    fileUploadManagerState.uploadFiles.merge({[index]: none});
  },

  reset() {
    fileUploadManagerState.merge(clone(initialState));
  },

  setMessage(message) {
    fileUploadManagerState.message.set(message);
  },

  setSubject(subjectId, subjectType) {
    fileUploadManagerState.uploadSubject.merge({subjectId, subjectType});
  },
};