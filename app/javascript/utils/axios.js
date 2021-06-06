import applyCaseMiddleware from 'axios-case-converter';
import defaultAxios from 'axios';

export const axios = applyCaseMiddleware(defaultAxios.create({
  baseURL: '',
  headers: {
    'X-CSRF-Token': document.querySelector('meta[name=\'csrf-token\']').content,
    'accept': 'application/json',
    'content-type': 'application/json',
  },
}));
