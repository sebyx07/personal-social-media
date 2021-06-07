import InfiniteListWindow from './infinite-list/infinite-list-window';

export default function InfiniteList({
  infiniteResource, render, positionerOptions = {}, isWindow = true, totalItems = 999999,
  renderInitialLoading, noResources, className,
}) {
  const {loadMore, state} = infiniteResource;

  if (!state.initialLoading.get() && state.resources.length === 0) return noResources;

  if (isWindow) {
    positionerOptions = {};

    if (state.initialLoading.get()) {
      return renderInitialLoading;
    }

    return (
      <InfiniteListWindow className={className} storeItems={state.resources} loadMore={loadMore.current} render={render} positionerOptions={positionerOptions} totalItems={totalItems}/>
    );
  }
}
