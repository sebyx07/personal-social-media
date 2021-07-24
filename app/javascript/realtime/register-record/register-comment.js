import {realTimeManager} from '../realtime-manager';
import {registerPeer, unRegisterPeer} from './register-peer';

export function registerRealTimeComment(hostOfCommentPeer, comment) {
  const virtualRecordId = buildVirtualRecordId(hostOfCommentPeer, comment);
  return realTimeManager.pushRecord('Comment', comment, {
    subSubscriptions: {
      'Peer': {
        registerWith: registerPeer,
        subSubscriptionRecords: [comment.peer],
        unregisterWith: unRegisterPeer,
      },
    },
    virtualRecordId,
  });
}

export function unRegisterRealTimeComment(hostOfCommentPeer, comment, subscriptionId) {
  const virtualRecordId = buildVirtualRecordId(hostOfCommentPeer, comment);
  return realTimeManager.removeRecord('Comment', comment, subscriptionId, virtualRecordId);
}

function buildVirtualRecordId(hostOfCommentPeer, comment) {
  return `${hostOfCommentPeer.id.get()}-${comment.id.get()}`;
}

