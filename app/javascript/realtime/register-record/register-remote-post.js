import {realTimeManager} from '../realtime-manager';
import {registerPeer, unRegisterPeer} from './register-peer';

export function registerRealTimeRemotePost(post) {
  return realTimeManager.pushRecord('RemotePost', post, {
    subSubscriptions: {
      'Peer': {
        registerWith: registerPeer,
        subSubscriptionRecords: [post.peer],
        unregisterWith: unRegisterPeer,
      },
    },
  });
}

export function unRegisterRealTimeRemotePost(post, subscriptionId) {
  return realTimeManager.removeRecord('RemotePost', post, subscriptionId);
}
