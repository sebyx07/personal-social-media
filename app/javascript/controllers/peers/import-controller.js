import {Controller} from 'stimulus';
import {axios} from '../../utils/axios';
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
      const requestBody = JSON.parse(input);
      if (!requestBody.message || !requestBody.signature) {
        return this.handleErrorQrImage('Invalid qr code');
      }
      requestBody.authenticity_token = this.element.querySelector('input[name=\'authenticity_token\']').value;

      axios.post(this.element.action, requestBody).then(({data: {peer: {id}}}) => {
        Turbolinks.visit(`/peers/${id}`);
      }).catch(({response: {data: {error}}}) => {
        feedBackError(error);
      });
    } catch {
      this.handleErrorQrImage('Invalid image, no qr code found');
    }
  }

  handleErrorQrImage(msg) {
    this.fileInputTarget.value = '';
    feedBackError(msg);
  }
}
