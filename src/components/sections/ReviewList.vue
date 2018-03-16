<template>
  <div>
    <p class="tasks">Verified reviews: {{reviews.filter(review => {return review.done === true}).length}}</p>
    <p class="tasks">Unverified reviews: {{reviews.filter(review => {return review.done === false}).length}}</p>
    <review  v-for="review in reviews" :review.sync="review"></review>
  </div>
</template>

<script type = "text/javascript" >
import review from './Review'
export default {
  props: ['reviews'],
  components: {
    review
  }
}
</script>

<style scoped>
p.tasks {
  text-align: center;
}
</style>

