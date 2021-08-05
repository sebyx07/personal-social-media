export function ui8arrayToHex(ui8array) {
  const buffer = ui8array.buffer;

  return [...new Uint8Array(buffer)]
      .map((x) => x.toString(16).padStart(2, '0'))
      .join('');
}