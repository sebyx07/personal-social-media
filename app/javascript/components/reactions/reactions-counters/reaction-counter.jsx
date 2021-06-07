export default function ReactionCounter({reactionCounter}) {
  const {character, reactionsCount} = reactionCounter;

  return (
    <div>
      <span>
        {character.get()}
      </span>
      <span>
        {reactionsCount.get()}
      </span>
    </div>
  );
}
