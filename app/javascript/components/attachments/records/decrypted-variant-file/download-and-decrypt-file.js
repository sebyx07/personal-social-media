import {axios} from '../../../../utils/axios';
import {createSimpleAsyncCache} from '../../../../lib/cache/simple-async-cache';
import {decryptBlob} from '../../../../lib/encryption/decrypt-blob';
const {fetchFromCache} = createSimpleAsyncCache();

export async function downloadAndDecryptFileCached(urls, key, iv) {
  return fetchFromCache(urls, () => {
    return downloadAndDecryptFile(urls, key, iv);
  });
}

async function downloadAndDecryptFile(urls, key, iv) {
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
