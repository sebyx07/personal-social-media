import {Controller} from 'stimulus';
import {feedBackError} from '../../utils/feedback';
import {scanImageForQrCode} from '../../utils/scan-image-for-qr-code';
const defaultButtonText = 'Login with QR code';
const passwordTypeButtonText = 'Login with password';

export default class extends Controller {
  static targets = ['submit', 'inputPassword', 'inputFile', 'form'];

  connect() {
    this.watchForRecaptcha();
  }

  watchForRecaptcha() {
    document.addEventListener('hcaptcha-response', () => {
      this.submitTarget.disabled = false;
    });
  }

  typePassword() {
    this.handleTypedPassword();
  }

  handleTypedPassword() {
    if (this.hasSelectedFile) return;
    if (this.inputPasswordTarget.value.length > 0) {
      this.submitTarget.value = passwordTypeButtonText;
    } else {
      this.submitTarget.value = defaultButtonText;
    }
  }

  submit(e) {
    if (this.inputPasswordTarget.value.length > 0) return;
    e.preventDefault();
    e.stopPropagation();
    this.inputFileTarget.click();
  }

  async fileSelected(e) {
    this.hasSelectedFile = true;
    const {target} = e;
    const file = target.files[0];
    if (!file) return;

    try {
      this.inputPasswordTarget.value = await scanImageForQrCode(file);
      // this.formTarget.submit();
    } catch {
      feedBackError('Invalid qr code');
    }
  }
}
