# frozen_string_literal: true

class DecryptFileSchmooze < Schmooze::Base
  method :decrypt, <<-JS
function decryptFile(inputFilePath, outputFilePath, key, iv){
  const {createReadStream, createWriteStream} = require('fs');
  const {pipeline} = require('stream');
  const algorithm = 'aes-256-cbc';
  const {
    createDecipheriv
  } = require('crypto');
  return new Promise((resolve) => {
    key = Buffer.from(key);
    iv = Buffer.from(iv);
    const decipher = createDecipheriv(algorithm, key, iv);
    const input = createReadStream(inputFilePath);
    const output = createWriteStream(outputFilePath);
    pipeline(input, decipher, output, (err) => {
      if (err) throw err;
      resolve({key, iv});
    });
  });
}
  JS
end
