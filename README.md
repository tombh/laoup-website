# Laoshu's Leveling-Up Showcase

Moses McMormick is a language learner and teacher who likes to use his 'Level Up'
method to practice speaking languages. This code parses all the subtitles from his
Youtube channel and organises all his Level Up encounters into languages so you can
quickly jump to the spot in the video where the encounter happens.

## Generating the list of encoutners

Requires `ruby`, `bundler` and [youtube-dl](https://rg3.github.io/youtube-dl/).

```
bundle install
ruby laoup.rb
```

## Frontend build setup

Requires `node` and `npm`.

``` bash
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build

# build for production and view the bundle analyzer report
npm run build --report
```

The frontend is built using the [Vue.js](https://vuejs.org/) framework. The build tools are [webpack](http://vuejs-templates.github.io/webpack/) and [vue-loader](http://vuejs.github.io/vue-loader).

## Contributing
All contributions and feedback are very welcome.
