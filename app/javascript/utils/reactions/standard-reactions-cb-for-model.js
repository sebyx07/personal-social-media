import {isPresent} from '../../components/util/is-present';
import {none} from '@hookstate/core';

export function standardReactionsCbForModelInc(model, cacheReaction) {
  const {character} = cacheReaction;

  const existingCounter = model.reactionCounters.find((counter) => {
    return counter.character.get() === character;
  });
  if (existingCounter) {
    return existingCounter.merge((c) => {
      return {
        reactionsCount: c.reactionsCount + 1,
      };
    });
  }

  return model.batch((m) => {
    m.reactionCounters.merge([
      {character, reactionsCount: 1},
    ]);

    m.cacheReactions.merge([cacheReaction]);
  });
}

export function standardReactionsCbForModelDec(model, emoji) {
  const existingCounter = model.reactionCounters.find((counter) => {
    return counter.character.get() === emoji;
  });
  if (existingCounter) {
    return existingCounter.merge((c) => {
      return {
        reactionsCount: c.reactionsCount - 1,
      };
    });
  }

  const cacheReaction = model.cacheReactions.find((reaction) => {
    return reaction.character.get() === emoji;
  });

  if (!cacheReaction) return;

  const idx = model.cacheReactions.indexOf(cacheReaction);
  model.cacheReactions[idx].set(none);
}

export function standardReactionsCbForModelCheckIfReacted(model, emoji) {
  const counter = model.cacheReactions.find((counter) => {
    return counter.character.get() === emoji;
  });

  return isPresent(counter);
}
