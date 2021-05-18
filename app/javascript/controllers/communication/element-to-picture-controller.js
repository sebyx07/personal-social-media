import {Controller} from 'stimulus';
import {downloadImageFromSrc} from '../../utils/download-image-from-src';
import {toPng} from 'html-to-image';

export default class CommunicationElementToPicture extends Controller {
  static targets = ['imageContent'];
  download() {
    toPng(this.imageContentTarget).then((dataUrl) => {
      downloadImageFromSrc(dataUrl, this.element.dataset.fileName);
    });
  }
}
