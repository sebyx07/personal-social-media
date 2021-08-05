import FileUploadListItem from './file-upload-list-item';

export default function FileUploadList() {
  const uploadFiles = [
    {cancelUpload: () => {}, fileName: 'MyFile', id: 1, progress: 50},
    {cancelUpload: () => {}, fileName: 'OtherFile', id: 2, progress: 50},
    {cancelUpload: () => {}, fileName: 'OtherFile', id: 3, progress: 50},
    {cancelUpload: () => {}, fileName: 'OtherFile', id: 4, progress: 50},
    {cancelUpload: () => {}, fileName: 'OtherFile', id: 5, progress: 50},
    {cancelUpload: () => {}, fileName: 'OtherFile', id: 6, progress: 50},
  ];

  return (
    <>
      {
        uploadFiles.map((uploadFile) => {
          return (
            <FileUploadListItem uploadFile={uploadFile} key={uploadFile.id}/>
          );
        })
      }
    </>
  );
}