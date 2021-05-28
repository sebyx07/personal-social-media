import {Controller} from 'stimulus';
import {axios} from '../../utils/axios';
import {feedBackError} from '../../utils/feedback';
import {scanImageForQrCode} from '../../utils/scan-image-for-qr-code';

export default class extends Controller {
  static targets = ['warnings', 'continue', 'step1', 'step2', 'stepCounter', 'confirmFileInputPassword'];

  connect() {
    this.step = 1;
    this.validationsChecks = ['password'];
  }

  toggleWarnings() {
    this.warningsTargets.forEach((t) => t.classList.remove('hidden'));

    setTimeout(() => {
      this.warningsTargets.forEach((t) => t.classList.add('hidden'));
    }, 1500);
  }

  enableContinue() {
    this.continueTarget.disabled = false;
  }

  continue(e) {
    e.preventDefault();
    e.stopPropagation();

    this.goToStep(2);
  }

  goToStep(number) {
    this[`step${this.step}Target`].classList.add('hidden');
    this[`step${number}Target`].classList.remove('hidden');

    this.stepCounterTarget.innerHTML = `Step ${number}`;

    this.step = number;
    window.scrollTo(0, 0);
  }

  openInput(e) {
    e.preventDefault();
    e.stopPropagation();

    const inputFile = this[`${e.target.dataset.inputValueEl}Target`];
    inputFile.click();
  }

  async validateValue(e) {
    const file = e.target.files[0];
    if (!file) return;

    try {
      const value = await scanImageForQrCode(file);
      if (value !== e.target.dataset.correctValue) return feedBackError('Incorrect value');

      const check = e.target.dataset.checkValidation;
      this.disableInputButton(check);

      this.validationsChecks = this.validationsChecks.filter((e) => e !== check);
      this.enableSubmit();
    } catch (e) {
      feedBackError('Unable to scan qr code');
    }
  }

  disableInputButton(check) {
    const button = this.element.querySelector(`button[data-check-validation='${check}']`);
    button.innerText = 'Check';
    button.disabled = true;
  }

  enableSubmit() {
    if (this.validationsChecks.length !== 0) return;

    this.element.querySelector('input[type=\'submit\']').disabled = false;
  }

  finish(e) {
    e.preventDefault();
    e.stopPropagation();
    const url = this.element.action;

    axios.post(url).then(() => {
      Turbolinks.visit('/');
    }).catch(() => {
      feedBackError('Unable to complete request');
    });
  }
}
