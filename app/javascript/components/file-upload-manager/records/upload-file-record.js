export class FileUploadFileRecord {
  constructor(file, fileUpload) {
    this.file = file;
    file.record = this;
    this.fileUpload = fileUpload;
    this.status = 'pending';
    this.state = fileUpload.manager.state;
  }

  finish(status) {
    this.status = status;
    this.fileUpload.finishFile(this);
  }

  startUpload() {
    const flow = this.fileUpload.createFlow();

    flow.on('fileSuccess', () => {
      this.finish('success');
    });

    flow.on('progress', () => {
      console.log(...arguments); // eslint-disable-line prefer-rest-params
    });

    flow.addFile(this.file);
    flow.upload();
  }
}
