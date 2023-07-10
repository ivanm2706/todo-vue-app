<script>
export default {
  props: {
    activeTodoLength: Number,
    modelValue: String,
    todosLength: Number
  },
  data() {
    return {
      filterButtons: ['all', 'active', 'completed']
    }
  },
  emits: ['update:modelValue', 'removeCompletedTodos'],
}
</script>

<template>
  <footer class="footer">
    <p class="footer__todoCount">
      <strong>{{ activeTodoLength }}</strong>
      items left
    </p>

    <ul class="filters">
      <li
        class="filters__list"
        v-for="button of filterButtons"
        :key="button"
      >
        <button
          type="button"
          class="filters__button"
          :class="{
            'filters__button--selected': button === modelValue,
          }"
          @click="$emit('update:modelValue', button)"
        >
          {{ button }}
        </button>
      </li>
    </ul>

    <button
      type="button"
      class="button button--clearCompleted"
      v-if="todosLength !== activeTodoLength"
      @click="$emit('removeCompletedTodos')"
    >
      Clear completed
    </button>
  </footer>
</template>