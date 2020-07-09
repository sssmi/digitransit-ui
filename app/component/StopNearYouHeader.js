import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'found';
import StopCode from './StopCode';
import ZoneIcon from './ZoneIcon';
import { PREFIX_STOPS } from '../util/path';
import { isKeyboardSelectionEvent } from '../util/browser';

const StopNearYouHeader = ({ stop, color }) => {
  return (
    <div className="stop-near-you-header-container">
      <div className="stop-header-content">
        <Link
          onClick={e => {
            e.stopPropagation();
          }}
          onKeyPress={e => {
            if (isKeyboardSelectionEvent(e)) {
              e.stopPropagation();
            }
          }}
          to={`/${PREFIX_STOPS}/${stop.gtfsId}`}
        >
          <div className="stop-near-you-name">{stop.name}</div>
        </Link>
        <div className="stop-near-you-info">
          <span className="stop-near-you-desc">{stop.desc}</span>
          <StopCode code={stop.code} />
          <ZoneIcon zoneId={stop.zoneId} zoneLabelColor={color} />
        </div>
      </div>
      <div className="stop-favourite-container" />
    </div>
  );
};

StopNearYouHeader.propTypes = {
  stop: PropTypes.object.isRequired,
  color: PropTypes.string,
};

export default StopNearYouHeader;
