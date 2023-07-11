<script>
import FooterTodo from './components/FooterTodos.vue';
import TodoItem from './components/TodoItem.vue';
import HeaderTodo from './components/Header.vue';
import Notification from './components/NotificationError.vue';
import Statistics from './components/StatisticsTodo.vue';
import getDataFromLocaleStorage from './helpers/getFromLocaleStorage';

export default {
  components: {
    FooterTodo,
    TodoItem,
    HeaderTodo,
    Notification,
    Statistics
  },
  data() {
    const todos = getDataFromLocaleStorage('todos') || [];
    const statistics = getDataFromLocaleStorage('statistics') || [];

    return {
      todos,
      statistics,
      status: 'all',
      notificationMessage: '',
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
    addTodo(todo, isRestore = false) {
      this.todos = [...this.todos, todo];

      if (isRestore) {
        this.statistics = this.statistics.map(statistic => {
          if (statistic.id === todo.id) {
            statistic.deleted = null;
          }

          return statistic;
        });

        return;
      }
      
      this.statistics = [...this.statistics, {
        id: todo.id,
        created: new Date(todo.id),
        changes: [],
        deleted: null,
      }];
    },
    removeCompletedTodos() {
      const removedTodoIds = {};
      this.todos = this.todos.filter((todo) => {
        if (todo.completed) {
          removedTodoIds[todo.id] = {
            title: todo.title,
            completed: todo.completed,
          };
        }

        return !todo.completed;
      });
      this.statistics = this.statistics.map(statistic => {
        if (removedTodoIds[statistic.id]) {
          statistic.deleted = {
            date: new Date(),
            ...removedTodoIds[statistic.id],
          };
        }

        return statistic;
      })
    },
    toggleAll() {
      const changedTodoIds = [];
      this.todos = this.todos.map((todo) => {
        if (!todo.completed) {
          changedTodoIds.push(todo.id);
          todo.completed = true;
        }

        return todo;
      });

      this.statistics = this.statistics.map(todo => {
        if (changedTodoIds.includes(todo.id)) {
          todo.changes.push({
            date: new Date(),
            field: 'completed',
            previousValue: false,
            updatedTodo: true,
          })
        }

        return todo;
      });
    },
    updatedTodo(id, { updateTodo, updateStatistics }) {
      this.todos = this.todos.map((todo) => {
        if (todo.id === id) {
          todo = { ...todo, ...updateTodo }
        }

        return todo
      });

      this.statistics = this.statistics.map(item => {
        if (item.id === updateStatistics.id) {
          item.changes.push(updateStatistics.change);
        }

        return item;
      });
    },
    deleteTodo(id) {
      const copyTodos = [...this.todos];
      const index = copyTodos.findIndex(todo => todo.id === id);

      if (index === -1) {
        return;
      }

      this.statistics = this.statistics.map(item => {
        if (item.id === id) {
          item.deleted = {
            date: new Date(),
            title: copyTodos[index].title,
            completed: copyTodos[index].completed,
          };
        }

        return item;
      });

      copyTodos.splice(index, 1);
      this.todos = [...copyTodos];
    },
    deleteImediately(id) {
      this.statistics = this.statistics.filter(statistic => id !== statistic.id);
    }
  },
  watch: {
    todos: {
      deep: true,
      handler() {
        localStorage.setItem('todos', JSON.stringify(this.todos))
      }
    },
    statistics: {
      deep: true,
      handler() {
        localStorage.setItem('statistics', JSON.stringify(this.statistics))
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

    <Notification
      v-if="notificationMessage"
      :message="notificationMessage"
    />
  </div>

  <ModalTodo
    :isModal="isModal"
    :todos="todos"
    :statisticsTodo="statisticsTodo"
    @closeModal="closeModal"
    v-if="isModal"
  />

  <Statistics
    :statistics="statistics"
    @restoreTodo="addTodo($event, true)"
    @deleteImediately="deleteImediately($event)"
    :todos="todos"
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
