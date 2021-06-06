import {
  MasonryScroller,
  useContainerPosition,
  useInfiniteLoader, usePositioner, useResizeObserver,
} from 'masonic';
import {isEmpty} from 'lodash';
import {useRef} from 'react';
import {useScroller} from 'mini-virtual-list';
import useWindowSize from '../../hooks/use-window-size';

export default function InfiniteListWindow({storeItems, loadMore, render, positionerOptions, totalItems}) {
  const containerRef = useRef();
  const {height: windowHeight, width: windowWidth} = useWindowSize();
  const {scrollTop, isScrolling} = useScroller(window);
  const {offset, width} = useContainerPosition(containerRef, [
    windowWidth,
    windowHeight,
  ]);

  const maybeLoadMore = useRef(useInfiniteLoader(loadMore, {
    isItemLoaded: (index, items) => {
      return !isEmpty(items[index]);
    },
    totalItems,
  }));

  const finalPositionerOptions = {...positionerOptions, width};
  const positioner = usePositioner(finalPositionerOptions, [storeItems.length]);
  const resizeObserver = useResizeObserver(positioner);

  return (
    <MasonryScroller
      positioner={positioner}
      resizeObserver={resizeObserver}
      containerRef={containerRef}
      items={storeItems}
      height={windowHeight}
      offset={offset}
      render={render}
      overscanBy={5}
      onRender={maybeLoadMore.current}
      isScrolling={isScrolling}
      scrollTop={scrollTop}
      className="outline-none"
    />
  );
}
