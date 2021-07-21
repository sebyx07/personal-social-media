import '../stylesheets/active_admin.scss';
import 'channels';
import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

Rails.start();
Turbolinks.start();

const componentRequireContext = require.context('components', true);
const ReactRailsUJS = require('react_ujs');
ReactRailsUJS.useContext(componentRequireContext); // eslint-disable-line react-hooks/rules-of-hooks
