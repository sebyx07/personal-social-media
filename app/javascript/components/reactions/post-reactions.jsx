import ReactionCounters from './reaction-counters';

export default function PostReactions({post}) {
  const {reactionCounters} = post;

  return (
    <div>
      <ReactionCounters reactionCounters={reactionCounters}/>
    </div>
  );
}
