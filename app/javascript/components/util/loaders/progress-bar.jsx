import PropTypes from 'prop-types';
import mergeStyles from '../../../lib/styles/merge-styles';
import style from './progress-bar.module.scss';

export default function ProgressBar({children, progress}) {
  const displayedProgress = progress || 0;

  const progressStyle = {
    width: `${displayedProgress}%`,
  };

  return (
    <div className="">
      <div className={mergeStyles('bg-gray-400 p-1 rounded relative overflow-hidden', style.progressBar)}>
        <div className="absolute inset-0 bg-green-500" style={progressStyle}>

        </div>

        <div className="absolute inset-0">
          <div className="flex justify-center h-full items-center">
            {children}
          </div>
        </div>
      </div>

      {/* <div className="overflow-hidden h-2 text-xs flex rounded bg-pink-200 relative">*/}
      {/*  <div>*/}
      {/*    {children}*/}
      {/*  </div>*/}
      {/*  <div style={{ width: "30%" }} className="absolute left-0 top-0 shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-pink-500">*/}
      {/*  */}
      {/*  </div>*/}
      {/* </div>*/}
    </div>
  );
}

ProgressBar.propTypes = {
  children: PropTypes.element,
  progress: PropTypes.number,
};