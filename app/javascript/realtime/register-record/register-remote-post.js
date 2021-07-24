import {realTimeManager} from '../realtime-manager';

export function registerRealTimeRemotePost(post) {
  return realTimeManager.pushRecord('RemotePost', post);
}

export function unRegisterRealTimeRemotePost(post, subscriptionId) {
  return realTimeManager.removeRecord('RemotePost', post, subscriptionId);
}

