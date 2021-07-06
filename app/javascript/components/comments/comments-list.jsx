import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import {useState} from '@hookstate/core';

export default function CommentsList({latestComments}) {
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
          viewMore || !latestComments ?
          <div>

          </div> :
          <div>

          </div>
        }
      </div>

      <a href="#" onClick={toggleViewMore}>
        {
          viewMore ? 'View less' : 'View more'
        }
      </a>
    </div>
  );
}
