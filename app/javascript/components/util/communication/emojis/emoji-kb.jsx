import 'emoji-mart/css/emoji-mart.css';
import {Picker} from 'emoji-mart';
import PropTypes from 'prop-types';
import mergeStyles from '../../../../lib/styles/merge-styles';

export default function EmojiKb({isOpened, append, className}) {
  function selectEmoji({native}) {
    append(native);
  }

  if (!isOpened) return null;

  return (
    <div className={mergeStyles('emoji-picker', className)}>
      <Picker set="apple" onSelect={selectEmoji}/>
    </div>
  );
}

EmojiKb.propTypes = {
  append: PropTypes.func.isRequired,
  isOpened: PropTypes.bool.isRequired,
};
