<template>
  <div id="home">
    <HeaderTemplate
      @log-user-in="logUserIn"
      @log-user-out="logUserOut"
    />
    <div class='ui three column centered grid'>
        <div class='column'>
            <review-list v-bind:reviews="reviews"></review-list>
        </div>
    </div>
    <BodyTemplate
      :current-view="currentView"
    />
    <FooterTemplate />
  </div>
</template>

<script>
  export default {
    name: 'home',
    props: ['currentView'],
    methods: {
      logUserIn (evt) {
        this.$emit('log-user-in', evt)
      },
      logUserOut (evt) {
        this.$emit('log-user-out', evt)
      }
    },
    components: {
      HeaderTemplate,
      BodyTemplate,
      FooterTemplate,
      ReviewList
    },
    data () { 
      return {
        reviews: [{
          title: 'Review A',
          comment: 'I love eating at A!',
          verified: false
        }, {
          title: 'Review B',
          comment: 'B sucks!',
          verified: false
        }, {
          title: 'Review C',
          comment: 'SPAM',
          verified: false
        }, {
          title: 'Review D',
          comment: 'Irrelevant comment',
          verified: false
        }]
      }
    }
  }

  import HeaderTemplate from './layout/HeaderTemplate'
  import ReviewList from './sections/ReviewList'
  import BodyTemplate from './layout/BodyTemplate'
  import FooterTemplate from './layout/FooterTemplate'
</script>

<style scoped>
  #home {
    width: 100%;
  }
</style>
