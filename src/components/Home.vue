<template>
  <div id="home">
    <div class='ui three column centered grid'>
        <div class='column'>
            <review-list v-bind:reviews="reviews"></review-list>
        </div>
    </div>
    <BodyTemplate
      :current-view="currentView"
      :user="user"
    />
  </div>
</template>

<script>
  export default {
    name: 'home',
    props: ['currentView', 'user'],
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
          title: 'Native Twins Coffee',
          comment: 'Starbucks is much better. I recommend going to STARBUCKS. Do not go here.',
          verified: false
        }, {
          title: 'The Board',
          comment: 'Best brunch in town. Highly reccommend!',
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
