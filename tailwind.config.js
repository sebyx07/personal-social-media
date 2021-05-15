module.exports = {
  mode: 'jit',
  purge: {
    content: [
      './app/javascript/**/*.jsx',
      './app/javascript/**/*.js',
      './app/helpers/**/*.rb',
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
