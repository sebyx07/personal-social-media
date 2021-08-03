import downloadAndDecryptFile from './decrypted-variant-file/download-and-decrypt-file';

export class DecryptedVariantFile {
  constructor(variant, contentType) {
    this.key = variant.key;
    this.iv = variant.iv;
    this.sources = variant.sources;
    this.contentType = contentType;
  }

  simpleSerialFileDecrypt() {
    const urls = [];
    let url;
    while (url = this.getNextSourceUrl()) {
      urls.push(url);
    }

    return downloadAndDecryptFile(urls, this.key, this.iv);
  }

  getNextSourceUrl() {
    if (!this.currentSource) this.changeSource();
    if (this.currentUrlIndex !== undefined) {
      const urls = this.sources[this.currentSource];

      if (this.currentUrlIndex + 1 >= urls.length) return null;
      this.currentUrlIndex += 1;
    } else {
      this.currentUrlIndex = 0;
    }

    return this.sources[this.currentSource][this.currentUrlIndex];
  }

  changeSource() {
    const sourcesNames = Object.keys(this.sources);

    if (this.sourceIndex !== undefined) {
      this.sourceIndex = (this.sourceIndex + 1) % (sourcesNames.length - 1);
    } else {
      this.sourceIndex = 0;
    }

    this.currentSource = sourcesNames[this.sourceIndex];
  }
}
