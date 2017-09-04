<template>
  <div class="wrapper">
    <div class="main">
      <img src="../assets/logo.png" alt="Logo" width="100" class="logo" />
      <h1>Laoshu's Level Ups</h1>
      <iframe
        width="560"
        height="315"
        :src="current_youtube_embed"
        frameborder="0"
        allowfullscreen>
      </iframe>
      <div v-if="current_language" class="current_language">
        <h2>{{ current_language }}</h2>
        <ul>
          <li v-for="encounter in languages[current_language].encounters">
            <ul v-on:click="changeEncounter(encounter)"
              :class="{ 'currently_viewing': encounterID(encounter) == current_encounter_id, 'encounter_synopsis': true }"
            >
              <li>
                <strong>{{ encounter.title | truncate(70) }}</strong>
              </li>
              <li>
                <span class="encounter_label">Opener:</span> {{ encounter.opener | truncate(70) }}
              </li>
              <li>
                <span class="encounter_label">Date:</span> {{ encounter.date }}
              </li>
              <li>
                <span class="encounter_label">Duration:</span> {{ encounter.duration }}s
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
    <div class="language_list">
      <ul>
        <li v-for="(language, name) in languages">
          <a
            v-on:click="changeLanguage(name)"
            :class="{ 'active_language': name == current_language }"
          >
            {{ name }} ({{ language.encounters.length }})
          </a>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import languageEncounters from '../../static/encounters.json';

export default {
  name: 'encounters',
  data: () => ({
    loading: 'Loading...',
    languages: languageEncounters,
    current_youtube_embed: '',
    current_encounter_id: '',
    current_language: 'mandarin',
  }),
  created() {
    this.changeEncounter(this.languages.mandarin.encounters[0]);
  },
  methods: {
    changeLanguage(language) {
      this.current_language = language;
    },
    encounterID(encounter) {
      return `${encounter.video_id}?start=${encounter.start}`;
    },
    changeEncounter(encounter) {
      const subs = 'cc_load_policy=1&cc_lang_pref=en';
      this.current_encounter_id = this.encounterID(encounter);
      this.current_youtube_embed = `https://youtube.com/embed/${this.current_encounter_id}&${subs}`;
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
}

.wrapper {
  width: 1000px;
  margin: auto;
}

.logo {
  float: left;
}

h1 {
  float: left;
}

.main {
  width: 800px;
  float: left;
}

.current_language h2 {
  text-transform: capitalize;
}

.encounter_label {
  color: #636472;
}

.encounter_synopsis {
  display: inline-block;
  width: 200px;
  height: 145px;
  float: left;
  text-align: left;
  cursor: pointer;
}

.language_list {
  width: 200px;
  float: right;
}

.language_list li {
  display: block;
  text-align: left;
  text-transform: capitalize;
}

.language_list li a {
  display: block;
  padding: 5px 0 5px 5px;
}

.language_list li a:hover,
.language_list li a.active_language,
.encounter_synopsis:hover,
.encounter_synopsis.currently_viewing {
  background-color: #F1E1C7;
}

</style>
