<script>
import FooterTodo from './components/FooterTodos.vue';
import TodoItem from './components/TodoItem.vue';
import HeaderTodo from './components/Header.vue';
import Notification from './components/NotificationError.vue';

export default {
  components: {
    FooterTodo,
    TodoItem,
    HeaderTodo,
    Notification,
},
  data() {
    let todos = [];

    try {
      todos = JSON.parse(localStorage.getItem('todos') || '[]');
    } catch (e) { /* empty */ }

    
    return {
      todos,
      status: 'all',
      notificationMessage: '',
    }
  },
  computed: {
    activeTodos() {
      return this.todos.filter(todo => !todo.completed);
    },
    isCompletedTodo() {
      return this.todos.some(todo => todo.completed === false);
    },
    visibleTodos() {
      if (this.status === 'all') {
        return this.todos;
      }

      return this.todos.filter(({ completed }) => {
        return this.status === 'active'
          ? completed
          : !completed
      });
    },
  },
  methods: {
    addTodo(todo) {
      this.todos.push(todo);
    },
    removeCompletedTodos() {
      this.todos = this.todos.filter(todo => !todo.completed);
    },
    toggleAll() {
      this.todos = this.todos.map(todo => {
        todo.completed = true;

        return todo;
      })
    },
  },
  watch: {
    todos: {
      deep: true,
      handler() {
        localStorage.setItem('todos', JSON.stringify(this.todos));
      }
    }
  },
}

</script>

<template>
  <div class="todoapp">
    <HeaderTodo
      :isCompletedTodo="isCompletedTodo"
      @addTodo="addTodo($event)"
      @toggleAll="toggleAll"
      :model-value="notificationMessage"
      @update:modelValue="notificationMessage = $event"
    />

    <section class="section">
      <TransitionGroup
        name="list"
        tag="ul"
        class="todoList"
      >
        <TodoItem
          v-for="todo, index of visibleTodos"
          :key="todo.id"
          :index="index"
          :todo="todo"
          @update="Object.assign(todo, $event)"
          @delete="todos.splice(todos.indexOf(todo), 1)"
        />
      </TransitionGroup>
    </section>

    <FooterTodo
      :todosLength="todos.length"
      :activeTodoLength="activeTodos.length"
      :model-value="status"
      @update:modelValue="status = $event"
      @removeCompletedTodos="removeCompletedTodos"
    />

    <Notification
      v-if="notificationMessage"
      :message="notificationMessage"
    />
  </div>
</template>

<style>
.list-enter-active,
.list-leave-active {
  max-height: 60px;
  transition: all 0.5s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  max-height: 0;
  transform: scaleY(0);
}
</style>