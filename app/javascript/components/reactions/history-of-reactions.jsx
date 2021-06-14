import InfiniteList from '../util/infinite-list';
import Modal from '../util/modal';
import PropTypes from 'prop-types';
import ReactionFromHistory from './history-reactions/reaction-from-history';
import pluralize from 'pluralize';
import useInfiniteResource from '../util/infinite-list/use-infinite-resource';

export default function HistoryOfReactions({isOpened, ...options}) {
  if (!isOpened) return null;

  return <HistoryOfReactionsWrapper isOpened={isOpened} {...options} />;
}

function HistoryOfReactionsWrapper({isOpened, modelType, modelId, close}) {
  const query = {};
  const baseUrl = `/${pluralize(modelType.toLowerCase())}/${modelId}/reactions`;

  const infiniteResource = useInfiniteResource(query, {
    baseUrl,
    query,
    resourcesRoot: 'reactions',
  });

  return (
    <div>
      <Modal close={close} isOpen={isOpened}>
        <div>
          <InfiniteList
            render={ReactionFromHistory}
            infiniteResource={infiniteResource}
            renderInitialLoading={<div>Loading reactions...</div>}
            loading={<div>Loading more reactions...</div>}
            noResources={<div>No reactions found</div>}
          />
        </div>
      </Modal>
    </div>
  );
}

HistoryOfReactions.propTypes = {
  close: PropTypes.func.isRequired,
  isOpened: PropTypes.bool.isRequired,
  modelId: PropTypes.number.isRequired,
  modelType: PropTypes.string.isRequired,
};
