import {axios} from '../axios';

export default function commentForModel({parentCommentId, content, subjectType, subjectId, commentType}) {
  let urlSubjectType;
  if (subjectType === 'RemotePost') {
    urlSubjectType = 'posts';
  }

  const url = `${urlSubjectType}/${subjectId}/comments`;
  return axios.post(url, {
    comment: {
      commentType,
      content,
      parentCommentId,
      subjectId,
      subjectType,
    },
  });
}
