import {useClickAway} from 'react-use';
import {useEffect, useRef} from 'react';
import PropTypes from 'prop-types';

export default function Modal({isOpen, close, children}) {
  useEffect(() => {
    if (isOpen) return document.body.classList.add('overflow-y-hidden');
    document.body.classList.remove('overflow-y-hidden');
  }, [isOpen]);
  const ref = useRef(null);

  useClickAway(ref, () => {
    if (!isOpen) return;
    document.body.classList.remove('overflow-y-hidden');
    close();
  });

  if (!isOpen) return null;

  return (
    <>
      <div className="fixed bg-black inset-0 z-30 opacity-50"/>
      <div className="fixed inset-0 flex justify-center z-50 py-12">
        <div className="bg-gray-300 p-6 shadow-lg rounded sm:w-full md:min-w-1/3 md:max-w-3/4 overflow-y-auto" ref={ref}>
          {children}
        </div>
      </div>
    </>
  );
}

Modal.propTypes = {
  children: PropTypes.element.isRequired,
  close: PropTypes.func.isRequired,
  isOpen: PropTypes.bool.isRequired,
};
