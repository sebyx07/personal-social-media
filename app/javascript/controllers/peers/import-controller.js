
import {Controller} from 'stimulus';
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

    const input = await scanImageForQrCode(file);
    console.log(input);
  }
}
