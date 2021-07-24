import {realTimeManager} from '../realtime-manager';

export function registerPeer(peer) {
  const virtualRecordId = buildVirtualRecordId(peer);
  return realTimeManager.pushRecord('Peer', peer, {virtualRecordId});
}

export function unRegisterPeer(peer, subscriptionId) {
  const virtualRecordId = buildVirtualRecordId(peer);
  return realTimeManager.removeRecord('Peer', peer, subscriptionId, virtualRecordId);
}

function buildVirtualRecordId(peer) {
  return peer.publicKey.get().join('-');
}
