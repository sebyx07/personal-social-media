import {axios} from '../../utils/axios';

export default function ToggleReaction({url}) {
  function reactToSubject(e) {
    e.preventDefault();
    axios.post(url, {reaction: {character: '😀'}}).then((data) => {
      debugger;
    }).catch((e) => {
      debugger;
    });
  }

  return (
    <div>
      <button onClick={reactToSubject}>
        React
      </button>
    </div>
  );
}
