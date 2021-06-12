const emojiRegex = require('emoji-regex/RGI_Emoji.js');
import replace from 'string-replace-to-array';
const regex = emojiRegex();

export function textWithEmoji(text) {
  return replace(text, regex, (emoji) => {
    return {emoji};
  });
}
