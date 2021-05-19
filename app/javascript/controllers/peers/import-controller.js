
import {Controller} from 'stimulus';
import {feedBackError} from '../../utils/feedback';
import {scanImageForQrCode} from '../../utils/scan-image-for-qr-code';

export default class extends Controller {
  static targets = ['fileInput'];

  submit(e) {
    e.preventDefault();
    e.stopPropagation();
    this.fileInputTarget.click();
  }

  async fileSelected(e) {
    const {target} = e;
    const file = target.files[0];
    if (!file) return;

    try {
      const input = await scanImageForQrCode(file);
      console.log(input);
      const requestBody = JSON.parse(input);
      if (!requestBody.message || !requestBody.signature) {
        return this.handleErrorQrImage('Invalid qr code');
      }
      requestBody.authenticity_token = this.element.querySelector('input[name=\'authenticity_token\']').value;
    } catch {
      this.handleErrorQrImage('Invalid image, no qr code found');
    }
  }

  handleErrorQrImage(msg) {
    this.fileInputTarget.value = '';
    feedBackError(msg);
  }
}
