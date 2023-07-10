<script>
export default {
  name: 'HeaderTodo',
  props: {
    modelValue: String,
    isCompletedTodo: Boolean,
  },
  emits: ['addTodo', 'toggleAll', 'update:modelValue'],
  data() {
    return {
      title: '',
    }
  },
  mounted() {
    this.$refs['title'].focus();
  },
  methods: {
    hendlerSubmit() {
      if (!this.title) {
        this.$emit('update:modelValue', 'cant be empty');

        setTimeout(this.$emit, 2000, 'update:modelValue', '');

        return;
      }

      this.$emit('addTodo', {
        id: Date.now(),
        title: this.title,
        completed: false,
      });

      this.title = '';
    }
  }
}
</script>

<template>
  <header>
    <h1 class="todoapp__title">todos</h1>

    <form @submit.prevent="hendlerSubmit" class="form">
      <input
        type="checkbox"
        id="toggle-all"
        class="input input--toggleAll form__toggleAll"
        :checked="isCompletedTodo"
        :disabled="!isCompletedTodo"
        @click="$emit('toggleAll')"
      />
      
      <label
        class="form__label"
        htmlFor="toggle-all"
      />

      <input
        type="text"
        class="input input--newTodo"
        placeholder="What needs to be done?"
        v-model.trim="title"
        ref="title"
      />
    </form>
  </header>
</template>