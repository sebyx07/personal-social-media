import ReactionCounter from './reactions-counters/reaction-counter';

export default function ReactionCounters({reactionCounters}) {
  return (
    <div>
      {
        reactionCounters.map((reactionCounter) => {
          return <ReactionCounter reactionCounter={reactionCounter} key={reactionCounter.character.get()}/>;
        })
      }
    </div>
  );
}
