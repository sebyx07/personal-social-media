import InfiniteListWindow from './infinite-list/infinite-list-window';

export default function InfiniteList({storeItems, loadMore, render, positionerOptions = {}, isWindow = true, totalItems = 999999}) {
  if (isWindow) {
    positionerOptions = {columnCount: 1, columnGutter: 0, estimateHeight: 140, ...positionerOptions};

    return (
      <InfiniteListWindow storeItems={storeItems} loadMore={loadMore} render={render} positionerOptions={positionerOptions} totalItems={totalItems}/>
    );
  }
}
