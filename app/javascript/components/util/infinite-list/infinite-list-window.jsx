import {
  MasonryScroller,
  useContainerPosition,
  useInfiniteLoader, usePositioner, useResizeObserver,
} from 'masonic';
import {isEmpty} from 'lodash';
import {useDimensions} from '../../hooks/use-dimensions';
import {useRef} from 'react';
import {useScroller} from 'mini-virtual-list';
import mergeStyles from '../../../lib/styles/merge-styles';
import useWindowSize from '../../hooks/use-window-size';

export default function InfiniteListWindow({storeItems, loadMore, render, positionerOptions, totalItems, className}) {
  const containerRef = useRef();
  const {height: windowHeight, width: windowWidth} = useWindowSize();
  const {scrollTop, isScrolling} = useScroller(window);
  const {offset} = useContainerPosition(containerRef, [
    windowWidth,
    windowHeight,
  ]);
  const {width} = useDimensions(containerRef, [storeItems.length]);

  const maybeLoadMore = useRef(useInfiniteLoader(loadMore, {
    isItemLoaded: (index, items) => {
      return !isEmpty(items[index]);
    },
    totalItems,
  }));

  const finalPositionerOptions = {...positionerOptions, columnWidth: width, columnsCount: 1, width: width};
  const positioner = usePositioner(finalPositionerOptions, []);
  const resizeObserver = useResizeObserver(positioner);

  return (
    <div ref={containerRef}>
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
        className={mergeStyles('outline-none', className)}
      />
    </div>
  );
}
