import {generateRandomId} from '../lib/string/generate-random-id';
import {isEmpty} from 'lodash';
import {transformKeys} from '../lib/object/transformKeys';
import consumer from '../channels/consumer';

class RealtimeManager {
  constructor() {
    this.cache = {};
  };

  pushRecord(type, record, options = {}) {
    this.boostrapConnection();

    if (!this.cache[type]) this.cache[type] = {};
    const recordId = options.virtualRecordId || record.id.get();

    const subscriptionId = generateRandomId();
    if (!this.cache[type][recordId]) {
      this.cache[type][recordId] = {
        subscriptions: {
          [subscriptionId]: {
            record,
            subSubscriptions: buildSubSubscriptions(options.subSubscriptions),
          },
        },
      };
    } else {
      this.cache[type][recordId].subscriptions[subscriptionId] = {
        record,
        subSubscriptions: buildSubSubscriptions(options.subSubscriptions),
      };
    }

    return subscriptionId;
  }

  removeRecord(type, record, subscriptionId, virtualRecordId) {
    const recordId = virtualRecordId || record.id.get();
    if (!this.cache[type][recordId]) return;

    const subscriptions = this.cache[type][recordId].subscriptions;
    removeSubSubscriptions(this.cache[type][recordId].subscriptions[subscriptionId].subSubscriptions);
    delete subscriptions[subscriptionId];
    if (isEmpty(subscriptions)) {
      delete this.cache[type][recordId];
    }
  }

  updateRecord(type, recordJson, virtualId) {
    const recordId = virtualId || recordJson.id;
    const batchedOperations = [];

    if (!(this.cache[type] && this.cache[type][recordId])) return;

    for (const subscriptionId in this.cache[type][recordId].subscriptions) {
      const subscription = this.cache[type][recordId].subscriptions[subscriptionId];

      batchedOperations.push({record: subscription.record, recordJson});
    }

    const firstRecord = batchedOperations[0]?.record;
    if (!firstRecord) return;
    firstRecord.batch(() => {
      batchedOperations.forEach((operation) => {
        operation.record.merge(operation.recordJson);
      });
    });
  }

  boostrapConnection() {
    if (this.alreadyBootstrapedConnection) return;
    this.alreadyBootstrapedConnection = true;
    const self = this;

    consumer.subscriptions.create('RealTimeRecordsChannel', {
      received(data) {
        const transformedData = transformKeys(data, {deep: true});
        const {action, type, record, virtualId} = transformedData;

        if (action === 'update') {
          self.updateRecord(type, record, virtualId);
        }
      },
    });
  }
}

function buildSubSubscriptions(subSubscriptions) {
  if (isEmpty(subSubscriptions)) return {};

  const result = {};
  for (const type in subSubscriptions) {
    const root = subSubscriptions[type];

    result[type] = root.subSubscriptionRecords.map((subRecord) => {
      const subSubscriptionId = root.registerWith(subRecord);

      return {
        subRecord,
        subSubscriptionId,
        unregisterWith: root.unregisterWith,
      };
    });
  }

  return result;
}

function removeSubSubscriptions(subSubscriptions) {
  if (isEmpty(subSubscriptions)) return;

  for (const type in subSubscriptions) {
    subSubscriptions[type].forEach((subSubscription) => {
      const {unregisterWith, subRecord, subSubscriptionId} = subSubscription;
      unregisterWith(subRecord, subSubscriptionId);
    });
  }
}

export const realTimeManager = new RealtimeManager();

if (process.env.RAILS_ENV !== 'production') {
  window.realTimeManager = realTimeManager;
}
