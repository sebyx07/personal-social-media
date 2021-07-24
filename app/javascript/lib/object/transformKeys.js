import transformObjectKeys from 'transform-object-keys';

export function transformKeys(object, options = {}) {
  const runOptions = {
    deep: true,
    ...options,
  };
  return transformObjectKeys(object, runOptions);
}
