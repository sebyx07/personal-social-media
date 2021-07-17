# frozen_string_literal: true

class EncryptFileSchmooze < Schmooze::Base
  method :encrypt, <<-JS
function encryptFile(inputFilePath, outputFilePath){
  const {createReadStream, createWriteStream} = require('fs');
  const {pipeline} = require('stream');
  const algorithm = 'aes-256-cbc';
  const {
    randomBytes,
    createCipheriv
  } = require('crypto');
  return new Promise((resolve) => {
    const key = randomBytes(32);
    const iv = randomBytes(16);

    const cipher = createCipheriv(algorithm, key, iv);
    const input = createReadStream(inputFilePath);
    const output = createWriteStream(outputFilePath);
    pipeline(input, cipher, output, (err) => {
      if (err) throw err;
      resolve({key, iv});
    });
  });
}
  JS
end
