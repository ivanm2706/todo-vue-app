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
      this.$emit('update', {
        ...this.todo,
        completed: !this.todo.completed,
        changes: [
          ...this.todo.changes,
          {
            date: Date.now(),
            field: 'completed',
            previousValue: this.todo.completed,
            updatedValue: !this.todo.completed
          }
        ]
      })
    },
    remove() {
      this.$emit('delete')
    },
    showInfo() {
      this.$emit('showModal')
    },
    edit() {
      this.newTitle = this.todo.title
      this.editing = true

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

      this.$emit('update', {
        ...this.todo,
        title: this.newTitle,
        changes: [
          ...this.todo.changes,
          {
            date: Date.now(),
            field: 'title',
            previousValue: this.todo.title,
            updatedValue: this.newTitle
          }
        ]
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

      <button type="button" class="button button--info todoList__buttons" @click="showInfo" />

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
