import {createState} from '@hookstate/core';

export const fileUploadManagerState = createState({
  show: true,
  status: 'pending',
  uploadFile: null,
  uploadPercentage: 0,
});