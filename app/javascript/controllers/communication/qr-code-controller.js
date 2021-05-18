import {Controller} from 'stimulus';
import QRCode from 'qrcode';

export default class CommunicationQrCode extends Controller {
  connect() {
    this.renderQrCode();
  }

  renderQrCode() {
    const qrCodeEl = this.element;
    QRCode.toCanvas(qrCodeEl, qrCodeEl.dataset.qrPayload, {
      color: {
        dark: '#000000',
        light: '#0000',
      },
      width: qrCodeEl.dataset.width || 480,
    });
  }
}
