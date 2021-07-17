# frozen_string_literal: true

class EncryptFileSchmooze < Schmooze::Base
  method :encrypt, <<-JS
function encryptFile(inputFilePath, outputFilePath, key, iv){
  const {createReadStream, createWriteStream} = require('fs');
  const {pipeline} = require('stream');
  const algorithm = 'aes-256-cbc';
  const {
    createCipheriv
  } = require('crypto');
  return new Promise((resolve) => {
    key = Buffer.from(key);
    iv = Buffer.from(iv);

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
