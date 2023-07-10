<script>
export default {
  props: {
    message: String
  }
}
</script>

<template>
  <div class="notification">
    {{ message }}
  </div>
</template>
