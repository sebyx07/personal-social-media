import {Controller} from 'stimulus';

export default class extends Controller {
  static targets = ['input']

  toggle(e) {
    if (this.inputTarget.type === 'password') return this.inputTarget.type = 'text';

    this.inputTarget.type = 'password';
  }
}
