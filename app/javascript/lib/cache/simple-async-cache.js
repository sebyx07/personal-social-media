class SimpleAsyncCache {
  constructor() {
    this.cache = {};
  }

  clearCache() {
    this.cache = {};
  }

  async fetch(key, cb) {
    let cacheEl = this.cache[key];
    if (cacheEl?.value) return cacheEl.value;

    if (!cacheEl?.running) {
      cacheEl = this.cache[key] = {};

      cacheEl.running = true;
      cacheEl.value = await cb();
      cacheEl.running = false;
      cacheEl.promises?.forEach((resolve) => {
        resolve(cacheEl.value);
      });
      delete cacheEl.promises;
      return cacheEl.value;
    }

    return new Promise((resolve) => {
      cacheEl.promises = cacheEl.promises || [];
      cacheEl.promises.push(resolve);
    });
  }
}

export function createSimpleAsyncCache() {
  const cacheObj = new SimpleAsyncCache();

  return {
    clearCache() {
      cacheObj.clearCache();
    },
    async fetchFromCache(key, cb) {
      return cacheObj.fetch(key, cb);
    },
  };
}
