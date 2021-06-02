export default function DefaultPeerAvatar({children, peer: {id, avatar, name}}) {
  const peerUrl = `/peers/${id}`;

  return (
    <div className="flex items-center">
      <a href={peerUrl}>
        <img loading="lazy" src={avatar} alt={name} className="rounded-full h-12 w-12"/>
      </a>
      <div className="ml-2">
        <a href={peerUrl} className="hover:underline">
          {name}
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
