export function standardReactionsCbForModelInc(model, cacheReaction) {
  const {character} = cacheReaction;

  const existingCounter = getReactionCounterForModel(model, character);
  if (existingCounter) {
    return existingCounter.merge((c) => {
      return {
        hasReacted: true,
        reactionsCount: c.reactionsCount + 1,
      };
    });
  }

  return model.reactionCounters.merge([
    {character, hasReacted: true, reactionsCount: 1},
  ]);
}

export function standardReactionsCbForModelDec(model, emoji) {
  const existingCounter = getReactionCounterForModel(model, emoji);
  if (existingCounter) {
    return existingCounter.merge((c) => {
      return {
        hasReacted: false,
        reactionsCount: c.reactionsCount - 1,
      };
    });
  }
}

export function getReactionCounterForModel(model, emoji) {
  return model.reactionCounters.find((counter) => {
    return counter.character.get() === emoji;
  });
}
