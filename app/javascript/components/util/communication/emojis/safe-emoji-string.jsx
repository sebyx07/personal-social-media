import {isObject} from 'lodash';
import PropTypes from 'prop-types';

import {Emoji, getEmojiDataFromNative} from 'emoji-mart';
import {textWithEmoji} from '../../../../utils/text-with-emoji';
import data from 'emoji-mart/data/all.json';

export default function SafeEmojiString({string, size, textStyle: defaultTextStyle = {}}) {
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
            return (
              <span key={i} dangerouslySetInnerHTML={{
                __html: Emoji({ // eslint-disable-line new-cap
                  emoji: getEmojiDataFromNative(input.emoji, 'apple', data),
                  html: true,
                  set: 'apple',
                  size,
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

SafeEmojiString.proptypes = {
  size: PropTypes.number.isRequired,
  string: PropTypes.string.isRequired,
  textStyle: PropTypes.object,
};
