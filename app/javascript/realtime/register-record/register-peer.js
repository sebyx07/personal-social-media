import {realTimeManager} from '../realtime-manager';

export function registerPeer(peer) {
  return realTimeManager.pushRecord('Peer', peer);
}

export function unRegisterPeer(peer, subscriptionId) {
  return realTimeManager.removeRecord('Peer', peer, subscriptionId);
}

