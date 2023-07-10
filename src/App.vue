<script>
import FooterTodo from './components/FooterTodos.vue'
import TodoItem from './components/TodoItem.vue'
import HeaderTodo from './components/Header.vue'
import Notification from './components/NotificationError.vue'
import ModalTodo from './components/ModalTodo.vue'

export default {
  components: {
    FooterTodo,
    TodoItem,
    HeaderTodo,
    Notification,
    ModalTodo
  },
  data() {
    let todos = []

    try {
      todos = JSON.parse(localStorage.getItem('todos') || '[]')
    } catch (e) {
      /* empty */
    }

    return {
      todos,
      status: 'all',
      notificationMessage: '',
      isModal: false,
      statisticsTodo: null
    }
  },
  computed: {
    activeTodos() {
      return this.todos.filter((todo) => !todo.completed)
    },
    isCompletedTodo() {
      return this.todos.some((todo) => todo.completed === false)
    },
    visibleTodos() {
      let todosCopy = [...this.todos];

      if (this.status === 'all') {
        return todosCopy;
      }

      return todosCopy.filter(({ completed }) => {
          return this.status === 'active' ? completed : !completed
        });
    }
  },
  methods: {
    addTodo(todo) {
      this.todos = [...this.todos, todo]
    },
    removeCompletedTodos() {
      this.todos = this.todos.filter((todo) => !todo.completed)
    },
    toggleAll() {
      this.todos = this.todos.map((todo) => {
        todo.completed = true

        return todo
      })
    },
    updatedTodo(id, props) {
      this.todos = this.todos.map((todo) => {
        if (todo.id === id) {
          todo = { ...todo, ...props }
        }

        return todo
      })
    },
    deleteTodo(id) {
      this.todos = this.todos.filter((todo) => todo.id !== id)
    },
    showModal(id) {
      this.statisticsTodo = this.todos.find((todo) => id === todo.id)
      this.isModal = true
      console.log(this.statisticsTodo.changes)
    }
  },
  watch: {
    todos: {
      deep: true,
      handler() {
        localStorage.setItem('todos', JSON.stringify(this.todos))
      }
    }
  }
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
      <TransitionGroup name="list" tag="ul" class="todoList">
        <TodoItem
          v-for="(todo, index) of visibleTodos"
          :key="todo.id"
          :index="index"
          :todo="todo"
          @update="updatedTodo(todo.id, $event)"
          @delete="deleteTodo(todo.id)"
          @showModal="showModal(todo.id)"
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

    <Notification v-if="notificationMessage" :message="notificationMessage" />
  </div>

  <ModalTodo
    :isModal="isModal"
    :statisticsTodo="statisticsTodo"
    @closeModal="isModal = false"
    v-if="isModal"
  />
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
