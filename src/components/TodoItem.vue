<script>
export default {
  name: 'TodoItem',
  props: {
    index: Number,
    todo: Object
  },
  data() {
    return {
      editing: false,
      newTitle: this.todo.title
    }
  },
  emits: ['update', 'delete', 'showModal'],
  methods: {
    toggle() {
      const updateTodo = {
        ...this.todo,
        completed: !this.todo.completed,
      };
      const updateStatistics = {
        id: this.todo.id,
        change: {
          date: Date.now(),
          field: 'completed',
          previousValue: this.todo.completed,
          updatedValue: !this.todo.completed
        },
      };

      this.$emit('update', {
        updateTodo,
        updateStatistics,
      });
    },
    remove() {
      this.$emit('delete');
    },
    showInfo() {
      this.$emit('showModal')
    },
    edit() {
      this.newTitle = this.todo.title;
      this.editing = true;

      this.$nextTick(() => {
        this.$refs['edit-field'].focus()
      })
    },
    rename() {
      if (this.newTitle === this.todo.title) {
        this.editing = false
        return
      }

      if (!this.newTitle) {
        this.editing = false
        return
      }

      const updateTodo = {
        ...this.todo,
        title: this.newTitle,
      };
      const updateStatistics = {
        id: this.todo.id,
        change: {
          date: Date.now(),
          field: 'title',
          previousValue: this.todo.title,
          updatedValue: this.newTitle,
        },
      };

      this.$emit('update', {
        updateTodo,
        updateStatistics,
      })

      this.editing = false
    }
  }
}
</script>

<template>
  <li
    class="todoList__item"
    :class="{
      'todoList__item--editing': editing
    }"
  >
    <div class="todoList__view">
      <input
        type="checkbox"
        class="input input--toggle"
        :checked="todo.completed"
        @change="toggle"
      />
      <p
        class="todoList__toggleLabel"
        :class="{
          'todoList__toggleLabel--completed': todo.completed
        }"
        @dblclick="edit"
      >
        {{ todo.title }}
      </p>

      <button type="button" class="button button--destroy todoList__buttons" @click="remove" />
    </div>

    <input
      type="text"
      id="toggle-view"
      class="input input--edit todoList__edit"
      ref="edit-field"
      v-model.trim="newTitle"
      @keyup.esc="editing = false"
      @blur="editing = false"
      @keyup.enter="rename"
    />
  </li>
</template>
