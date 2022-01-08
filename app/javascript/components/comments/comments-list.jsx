import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import {isEmpty, takeRight} from 'lodash';
import {useState} from '@hookstate/core';
import Comment from './comment';
import PropTypes from 'prop-types';

export default function CommentsList({latestComments, hostOfCommentPeer}) {
  const renderedLatestComments = takeRight(latestComments, 3);
  const showViewMore = !isEmpty(renderedLatestComments);

  const state = useState({
    viewMore: false,
  });

  function toggleViewMore(e) {
    e.preventDefault();
    state.merge((s) => {
      return {
        viewMore: !s.viewMore,
      };
    });
  }
  const {viewMore} = getHookstateProperties(state, 'viewMore');

  return (
    <div>
      <div>

        {
          viewMore || !renderedLatestComments ?
          <div>

          </div> :
          <div>
            {
              renderedLatestComments.map((comment) => {
                return (
                  <div key={comment.id.get()}>
                    <Comment data={comment} hostOfCommentPeer={hostOfCommentPeer}/>
                  </div>
                );
              })
            }
          </div>
        }
      </div>

      {
        showViewMore && <a href="#" onClick={toggleViewMore}>
          {
            viewMore ? 'View less' : 'View more'
          }
        </a>
      }
    </div>
  );
}

CommentsList.propTypes = {
  hostOfCommentPeer: PropTypes.object.isRequired,
  latestComments: PropTypes.array,
};
