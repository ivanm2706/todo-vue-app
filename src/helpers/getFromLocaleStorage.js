export default (name) => {
  try {
    return JSON.parse(localStorage.getItem(name) || '[]');
  } catch (e) {
    throw new Error('cant\'t load from locale Storage')
  }
};
