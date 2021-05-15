module.exports = {
  mode: 'jit',
  purge: {
    content: [
      './frontend/javascript/**/*.jsx',
      './frontend/javascript/**/*.js',
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
