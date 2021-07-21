module.exports = {
  darkMode: false,
  mode: 'jit',
  plugins: [],
  purge: {
    content: [
      './app/javascript/**/*.jsx',
      './app/javascript/**/*.js',
      './app/helpers/**/*.rb',
      './app/components/**/*.rb',
      './app/management/**/*.rb',
      './app/components/**/*.html.erb',
      './app/**/*.html.erb',
    ],
  },
  // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
};
