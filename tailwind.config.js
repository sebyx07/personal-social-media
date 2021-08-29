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
      './app/decorators/**/*.rb',
      './app/components/**/*.html.erb',
      './app/**/*.html.erb',
    ],
  },
  // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        'cyber-1': '#031b20',
        'cyber-1-transparent': 'rgba(3,27,32,0.90)',
        'cyber-2': '#00f8f8',
        'cyber-2-light': 'rgb(126, 252, 246)',
      },
      cursor: {
        'zoom-in': 'zoom-in',
      },
      maxWidth: {
        '3/4': '75%',
      },
      minWidth: {
        '1/3': '33%',
      },
    },
  },
  variants: {
    extend: {},
  },
};
