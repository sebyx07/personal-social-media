import createEmojiMartPlugin from 'psm-draft-js-emoji-mart-plugin';

const emojiRegex = require('emoji-regex/RGI_Emoji.js');
import replace from 'string-replace-to-array';
const regex = emojiRegex();
import 'emoji-mart/css/emoji-mart.css';
import data from 'emoji-mart/data/apple.json';

export const emojiPlugin = createEmojiMartPlugin({
  data,
  set: 'apple',
});

export function textWithEmoji(text) {
  return replace(text, regex, (emoji) => {
    return {emoji};
  });
}

