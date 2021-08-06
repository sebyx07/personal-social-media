import FileUploadListItem from './file-upload-list-item';

export default function FileUploadList({state}) {
  return (
    <div>
      {
        state.uploadFiles.map((uploadFile) => {
          return (
            <FileUploadListItem uploadFile={uploadFile} key={uploadFile.clientId.get()}/>
          );
        })
      }
    </div>
  );
}