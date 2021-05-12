module.exports = {
  mode: 'jit',
  purge: {
    content: [
      './frontend/javascript/**/*.jsx',
      './app/**/*.html.erb',
    ],
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
