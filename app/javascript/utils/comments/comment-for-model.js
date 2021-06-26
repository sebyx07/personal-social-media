import {axios} from '../axios';

export default function commentForModel({parentCommentId, content, subjectType, subjectId, commentType}) {
  return axios.post('/comments', {
    comment: {
      commentType,
      content,
      parentCommentId,
      subjectId,
      subjectType,
    },
  });
}
