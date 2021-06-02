import StandardPost from './posts/standard-post';
import StandardPostPagination from './posts/standard-post-pagination';

export default function StandardPostList({posts, paginationItemsRequired}) {
  return (
    <div className="w-full md:w-1/3 mx-auto">
      <div>
        {
          posts.map((p) => {
            return <StandardPost post={p} key={p.id}/>;
          })
        }
      </div>

      <div>
        <StandardPostPagination paginationItemsRequired={paginationItemsRequired} posts={posts}/>
      </div>
    </div>
  );
}
