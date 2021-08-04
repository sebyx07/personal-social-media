import applyCaseMiddleware from 'axios-case-converter';
import defaultAxios from 'axios';

export const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

export const axios = applyCaseMiddleware(defaultAxios.create({
  baseURL: '',
  headers: {
    'X-CSRF-Token': csrfToken,
    'accept': 'application/json',
    'content-type': 'application/json',
  },
}));
