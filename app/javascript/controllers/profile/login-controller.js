import {Controller} from 'stimulus';
import {feedBackError} from '../../utils/feedback';
import {scanImageForQrCode} from '../../utils/scan-image-for-qr-code';

export default class extends Controller {
  static targets = ['submit', 'inputPassword', 'inputFile', 'form'];

  connect() {
    this.disableSubmitAfterRecaptchaFindElement();
  }

  disableSubmitAfterRecaptchaFindElement() {
    const input = this.element.querySelector('[name=\'h-captcha-response\']');
    if (!input) return setTimeout(this.disableSubmitAfterRecaptchaFindElement.bind(this), 300);
    input.addEventListener('change', () => {
      this.submitTarget.disabled = false;
    });
  }

  submit(e) {
    if (this.inputPasswordTarget.value.length > 0) return;
    e.preventDefault();
    e.stopPropagation();
    this.inputFileTarget.click();
  }

  async fileSelected(e) {
    const {target} = e;
    const file = target.files[0];
    if (!file) return;

    try {
      this.inputPasswordTarget.value = await scanImageForQrCode(file);
      this.formTarget.submit();
    } catch {
      feedBackError('Invalid qr code');
    }
  }
}
