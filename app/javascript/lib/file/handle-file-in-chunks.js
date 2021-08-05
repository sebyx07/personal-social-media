import {percentageOf} from '../numbers/percentages';

const slice = 20_485_760; // 10mb

export function handleFileInChunks(file, cb, cbProgress) {
  return new Promise((resolve) => {
    const fileReader = new FileReader();

    _handleFileInChunks(file, cb, 0, file.size, fileReader, cbProgress, () => {
      resolve();
    });
  });
}

function _handleFileInChunks(file, cb, position, totalSize, fileReader, cbProgress, finishCb) {
  if (position >= totalSize) return finishCb();
  const nextPosition = position + slice;

  const chunk = file.slice(position, nextPosition);

  fileReader.onload = async () => {
    await cb(new Uint8Array(fileReader.result));
    if (cbProgress) {
      cbProgress(percentageOf(position, totalSize));
    }
    _handleFileInChunks(file, cb, nextPosition, totalSize, fileReader, cbProgress, finishCb);
  };

  fileReader.readAsArrayBuffer(chunk);
}