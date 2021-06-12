import SafeEmojiString from '../../util/communication/emojis/safe-emoji-string';

export default function ReactionCounter({reactionCounter}) {
  const {character, reactionsCount} = reactionCounter;

  return (
    <div>
      <SafeEmojiString string={`${character.get()} ${reactionsCount.get()}`} size={27} textStyle={{marginLeft: '-1px'}}/>
    </div>
  );
}
