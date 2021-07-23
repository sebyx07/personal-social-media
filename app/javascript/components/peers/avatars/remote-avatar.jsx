import PropTypes from 'prop-types';
import mergeStyles from '../../../lib/styles/merge-styles';

export default function RemotePeerAvatar({children, imageClassName, nameClassName, peer: {avatar, name}}) {
  return (
    <div className="flex items-center">
      <a>
        <img loading="lazy" src={avatar.get()} alt={name.get()} className={mergeStyles(imageClassName, 'rounded-full')}/>
      </a>
      <div className="ml-2 flex-1">
        <a className={mergeStyles('hover:underline', nameClassName)}>
          {name.get()}
        </a>

        {
          children && <div>
            {children}
          </div>
        }
      </div>
    </div>
  );
}

RemotePeerAvatar.propTypes = {
  children: PropTypes.element,
  imageClassName: PropTypes.string.isRequired,
  nameClassName: PropTypes.string,
  peer: PropTypes.object.isRequired,
};
