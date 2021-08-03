import {axios} from '../../../../utils/axios';
import {decryptBlob} from '../../../../lib/encryption/decrypt-blob';

export default async function downloadAndDecryptFile(urls, key, iv) {
  let responses = urls.map((url) => {
    return axios.get(url, {responseType: 'blob'});
  });

  responses = await Promise.all(responses);
  let finalBlob;
  if (responses.length > 1) {
    finalBlob = responses.reduce((resp1, resp2) => {
      return new Blob([resp1.data, resp2.data]);
    });
  } else {
    finalBlob = responses[0].data;
  }

  return decryptBlob(finalBlob, key, iv);
}
