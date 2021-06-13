import PropTypes from 'prop-types';

export default function HistoryOfReactions({isOpened, modelType, modelId}){
  return(
    <div>
      History
    </div>
  )
}

HistoryOfReactions.propTypes = {
  isOpened: PropTypes.bool.isRequired,
  modelType: PropTypes.string.isRequired,
  modelId: PropTypes.number.isRequired,
}