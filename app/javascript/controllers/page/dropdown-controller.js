import {Controller} from 'stimulus';

export default class extends Controller {
  static targets = ['dropdown'];

  toggleOpen(e) {
    e.preventDefault();

    this.dropdownTarget.classList.toggle('hidden');
    this.isOpened = !this.dropdownTarget.classList.contains('hidden');
    if (this.isOpened) return this.handleOpened();
    this.handleClosed();
  }

  handleOpened() {
    document.addEventListener('click', this.checkIfClickOutside.bind(this));
  }

  handleClosed() {
    document.removeEventListener('click', this.checkIfClickOutside.bind(this));
  }

  checkIfClickOutside(e) {
    if (this.element.contains(e.target)) return;

    this.dropdownTarget.classList.add('hidden');
    this.isOpened = false;
    this.handleClosed();
  }
}
