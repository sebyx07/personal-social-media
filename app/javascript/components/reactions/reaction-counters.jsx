import {Fragment} from 'react';
import ReactionCounter from './reactions-counters/reaction-counter';

export default function ReactionCounters({reactionCounters}) {
  return (
    <div className="flex flex-wrap">
      {
        reactionCounters.map((reactionCounter, i) => {
          return (
            <Fragment key={reactionCounter.character.get()}>
              <div className="w-1/6">
                <ReactionCounter reactionCounter={reactionCounter}/>
              </div>
            </Fragment>
          );
        })
      }
    </div>
  );
}
