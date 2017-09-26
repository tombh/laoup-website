<template>
  <div class="main">
    <header>
      <div class="title">
        <img src="../assets/logo.png" alt="Logo" width="100" class="logo" />
        <h1>Laoshu's Level Ups</h1>
      </div>
      <div class="iframe_wrapper">
        <iframe
          :src="currentYoutubeEmbed"
          frameborder="0"
          allowfullscreen>
        </iframe>
      </div>
    </header>
    <div v-if="currentLanguage" class="current_language">
      <header class="language_list">
        <select @change="changeLanguage">
          <option
            v-for="(language, name) in languages"
            :value="name"
            :selected="name === currentLanguage"
          >
            {{ name | capitalize }} ({{ language.encounters.length }})
          </option>
        </select>
      </header>
      <ul>
        <li v-for="encounter in languages[currentLanguage].encounters">
          <router-link :to=encounterURI(encounter) class="encounter_synopsis">
            <ul>
              <li>
                <strong>{{ encounter.title | truncate(45) }}</strong>
              </li>
              <li>
                <span class="encounter_label">
                  Opener:
                </span>
                {{ encounter.opener | truncate(45) }}
              </li>
              <li>
                <span class="encounter_label">
                  Date:
                </span>
                {{ encounter.date }}
              </li>
              <li>
                <span class="encounter_label">
                  Duration:
                </span>
                {{ encounter.duration }}s
              </li>
            </ul>
          </router-link>
        </li>
      </ul>
    </div>
    <footer>
      &middot;
      <a href="https://flrmethod.com/">
        Lao Shu's teaching website
      </a>
      &middot;
      <a href="http://tombh.co.uk">
        Made by tombh.co.uk
      </a>
      &middot;
      <a href="https://github.com/tombh/laoup-website">
        Github repo
      </a>
      &middot;
    </footer>
  </div>
</template>

<script>
import languageEncounters from '../../static/encounters.json';

export default {
  name: 'encounters',
  data: () => ({
    languages: languageEncounters,
    currentEncounter: {},
    currentYoutubeEmbed: '',
    currentLanguage: 'mandarin',
  }),
  created() {
    this.onRouteChange();
  },
  watch: {
    $route() {
      this.onRouteChange();
    },
  },
  methods: {
    changeLanguage(event) {
      this.currentLanguage = event.target.value;
    },
    onRouteChange() {
      if (typeof this.$route.params.video === 'undefined') {
        this.onNoVideo();
      } else {
        this.loadVideo(this.$route.params);
      }
    },
    onNoVideo() {
      const first = this.languages.mandarin.encounters[0];
      const firstURI = this.encounterURI(first);
      this.$router.push(firstURI);
    },
    loadVideo(params) {
      this.currentLanguage = params.language;
      const candidates = this.languages[this.currentLanguage].encounters;
      this.currentEncounter = candidates.find(
        (encounter) => {
          const isVideoMatch = encounter.video_id === params.video;
          const isTimestampMatch = encounter.start.toString() === params.start;
          return isVideoMatch && isTimestampMatch;
        },
      );
      this.setYoutubeEmbed();
    },
    setYoutubeEmbed() {
      const encounter = this.currentEncounter;
      const subs = 'cc_load_policy=1&cc_lang_pref=en';
      const videoWithStart = `${encounter.video_id}?start=${encounter.start}`;
      this.currentYoutubeEmbed = `https://youtube.com/embed/${videoWithStart}&${subs}`;
    },
    encounterURI(encounter) {
      return `/${this.currentLanguage}/${encounter.video_id}/${encounter.start}`;
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #B57D40;
  cursor: pointer;
  text-decoration: none;
}

footer a:hover {
  color: #B57D4075;
}

.logo {
  float: left;
}

h1 {
  float: left;
}

h2 {
  float: left;
}

.main {
  max-width: 800px;
  margin: auto;
}

footer {
  text-align: center;
}

header select {
  float: right;
}

.title {
  overflow: hidden;
  text-align: center;
  margin-bottom: 1em;
}

.iframe_wrapper {
  position: relative;
  width: 100%;
  height: 0;
  padding-bottom: 56.25%;
}
iframe {
  border-top: 2px solid #B57D40;
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}

.current_language h2 {
  text-transform: capitalize;
}

.current_language > ul {
  text-align: center;
}

.encounter_label {
  color: #636472;
}

.encounter_synopsis {
  display: inline-block;
  width: 245px;
  height: 130px;
  float: left;
  text-align: left;
  cursor: pointer;
  border-top: 2px solid white;
  padding-top: 5px;
  margin-top: 5px;
}

.encounter_synopsis li {
  display: block;
}

.encounter_synopsis:hover,
.encounter_synopsis.router-link-active {
  border-top: 2px solid #B57D40;
}
.encounter_synopsis:hover {
  background-color: #F1E1C750;
}
.encounter_synopsis.router-link-active {
  background-color: #F1E1C7;
}
.encounter_synopsis:visited {
  color: grey;
}

.language_list {
  overflow: hidden;
}

.language_list select {
  margin-top: 10px;
  margin-left: 10px;
}

</style>
