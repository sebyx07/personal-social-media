export class FileUploadFileRecord {
  constructor(instantUpload) {
    this.instantUpload = instantUpload;
  }

  handleProgress(flowFile) {
    const progress = parseFloat((flowFile.progress() * 100).toFixed(2));
    const instantUpload = flowFile.file.instantUpload;
    instantUpload.uploadFileState.merge({
      currentSpeed: parseInt(flowFile.averageSpeed),
      etaSeconds: flowFile.timeRemaining(),
      message: `${progress}%`,
      progress,
      uploadedAlreadyBytes: flowFile.sizeUploaded(),
    });
  }

  startUpload() {
    return new Promise((resolve) => {
      const flow = this.instantUpload.uploadRecord.createFlow();

      flow.on('fileSuccess', () => {
        this.instantUpload.finish();
        resolve();
      });

      flow.on('fileProgress', this.handleProgress.bind(this));

      flow.addFile(this.instantUpload.file);
      flow.upload();
    });
  }
}
