import {isObject} from 'lodash';
import PropTypes from 'prop-types';

import {Emoji, getEmojiDataFromNative} from 'emoji-mart';
import {textWithEmoji} from '../../../../utils/text-with-emoji';
import data from 'emoji-mart/data/all.json';

export default function SafeEmojiString({string, size, textStyle: defaultTextStyle = {}, className}) {
  const html = textWithEmoji(string);
  const textStyle = {
    fontSize: `${parseInt(size * 0.85)}px`,
    ...defaultTextStyle,
  };

  return (
    <div className="flex items-center">
      {
        html.map((input, i) => {
          if (isObject(input)) {
            const emojiData = getEmojiDataFromNative(input.emoji, 'apple', data);
            return (
              <span className={className} key={i} dangerouslySetInnerHTML={{
                __html: Emoji({ // eslint-disable-line new-cap
                  emoji: emojiData,
                  html: true,
                  set: 'apple',
                  size,
                  skin: emojiData.skin || 1,
                }),
              }}/>
            );
          }

          return (
            <span key={i} style={textStyle}>{input}</span>
          );
        })
      }
    </div>
  );
}

SafeEmojiString.propTypes = {
  size: PropTypes.number.isRequired,
  string: PropTypes.string.isRequired,
  textStyle: PropTypes.object,
};
