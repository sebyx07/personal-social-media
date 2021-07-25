import {useState} from '@hookstate/core';
import PreviewPictureAttachment from '../../../attachments/preview/preview-picture';

export default function AttachmentPicture({file}) {
  const objectUrj = URL.createObjectURL(file);
  const state = useState({
    preview: false,
  });

  function closePreview() {
    state.merge({preview: false});
  }

  function openPreview(e) {
    e.preventDefault();
    state.merge({preview: true});
  }

  return (
    <div>
      <img src={objectUrj} alt="attachments picture" className="cursor-zoom-in" onClick={openPreview}/>

      <PreviewPictureAttachment close={closePreview} isOpen={state.preview.get()} file={file}/>
    </div>
  );
}
