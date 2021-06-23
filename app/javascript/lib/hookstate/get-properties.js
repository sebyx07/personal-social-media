export function getHookstateProperties(object, ...properties) {
  const result = {};
  properties.forEach((prop) => {
    result[prop] = object[prop].get();
  });

  return result;
}
