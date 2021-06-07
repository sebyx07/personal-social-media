import {axios} from '../../../utils/axios';
import {isEmpty} from 'lodash';
import {none, useState} from '@hookstate/core';
import {useEffect, useRef} from 'react';
import qs from 'qs';
import transformObjectKeys from 'transform-object-keys';

export default function useInfiniteResource(initialState = {}, api = {}) {
  const state = useState({
    afterLoading: [],
    endOfList: false,
    errorLoading: false,
    initialLoading: true,
    loadedFromIndexesList: [],
    resources: [],
    ...initialState,
  });

  useEffect(() => {
    state.merge({endOfList: false});
    loadInitialResources(state, api);
  }, [JSON.stringify(initialState), JSON.stringify(api)]); // eslint-disable-line react-hooks/exhaustive-deps

  const loadMore = useRef((startIndex) => {
    const lastResource = state.resources[startIndex - 1];

    loadMoreResources(state, lastResource, api, startIndex);
  });

  return {loadMore, state};
}

async function loadInitialResources(state, api) {
  try {
    const {data} = await loadResources(state, buildUrl(api.baseUrl, api.query));
    const resources = data[api.resourcesRoot];
    state.merge({
      initialLoading: false,
      resources,
    });
  } catch {
    state.merge({errorLoading: true});
  }
}

async function loadMoreResources(state, lastResource, api, startIndex) {
  state.merge({afterLoading: true});

  const {loadedFromIndexesList} = state;
  if (Object.values(loadedFromIndexesList.value).indexOf(startIndex) !== -1) return;
  loadedFromIndexesList.merge([startIndex]);

  try {
    const query = {...api.query, pagination: {from: lastResource.id.get()}};
    const {data} = await loadResources(state, buildUrl(api.baseUrl, query));

    const resources = data[api.resourcesRoot];
    state.batch((s) => {
      s.resources.merge(resources);
      s.merge({afterLoading: false});
      if (resources.length === 0) {
        s.merge({endOfList: true});
      }
    });
  } catch (e) {
    const errorIndex = Object.values(loadedFromIndexesList.value).indexOf(startIndex);
    loadedFromIndexesList.merge({
      afterLoading: false,
      [errorIndex]: none,
    });
    console.error(e);
  }
}

function buildUrl(url, queryParams) {
  const queryString = qs.stringify(transformObjectKeys(queryParams, {deep: true, snakeCase: true}));
  if (isEmpty(queryString)) return url;

  return `${url}?${queryString}`;
}

function loadResources(state, url) {
  return axios.get(url);
}
