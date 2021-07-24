import {generateRandomId} from '../lib/string/generate-random-id';
import {isEmpty} from 'lodash';

class RealtimeManager {
  constructor() {
    this.cache = {};
  };

  pushRecord(type, record) {
    if (!this.cache[type]) this.cache[type] = {};
    const recordId = record.id.get();

    const subscriptionId = generateRandomId();
    if (!this.cache[type][recordId]) {
      this.cache[type][recordId] = {
        record,
        subscriptions: [generateRandomId],
      };
    } else {
      this.cache[type][recordId].subscriptions.push(subscriptionId);
    }

    return subscriptionId;
  }

  removeRecord(type, record, subscriptionId) {
    const recordId = record.id.get();
    if (!this.cache[type][recordId]) return;

    const subscriptions = this.cache[type][recordId].subscriptions;
    const filteredSubscriptions = subscriptions.filter((s) => s !== subscriptionId);
    if (isEmpty(filteredSubscriptions)) {
      delete this.cache[type][recordId];
    } else {
      this.cache[type][recordId].subscriptions = filteredSubscriptions;
    }
  }
}

export const realTimeManager = new RealtimeManager();
