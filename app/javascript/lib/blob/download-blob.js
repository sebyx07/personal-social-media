export function downloadBlob({blob, blobUrl, fileName}) {
  const url = blobUrl || URL.createObjectURL(blob);

  const a = document.createElement('a');
  a.href = url;
  a.classList.add('hidden');
  a.download = fileName;
  a.dispatchEvent(new MouseEvent('click', {bubbles: true, cancelable: true, view: window}));
  a.remove();
  if (blob) URL.revokeObjectURL(a.href);
}
