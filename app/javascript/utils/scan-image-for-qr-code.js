import QrScanner from 'qr-scanner';
QrScanner.WORKER_PATH = '/qr-scanner-worker.min.js';

export function scanImageForQrCode(file) {
  return QrScanner.scanImage(file);
}
