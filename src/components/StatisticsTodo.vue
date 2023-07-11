<script>
export default {
  props: {
    statistics: Object,
    todos: Object,
  },
  emits: ['restoreTodo', 'deleteImediately'],
  data() {
    return {
      isStatistics: false,
    }
  },
  methods: {
    toggleStatisticks() {
      this.isStatistics = !this.isStatistics;
    },
    getFormatDate(dateProps) {
      console.log(typeof dateProps, dateProps)
      const date = new Date(dateProps)

      const options = {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      }

      return date.toLocaleString('en-US', options)
    },
    restoreTodo(id, options) {
      const restoredTodo = {
        id,
        title: options.title,
        completed: options.completed,
      };

      this.$emit('restoreTodo', restoredTodo);
    },
    deleteImediately(id) {
      this.$emit('deleteImediately', id);
    },
    getTitleTodo(id) {
      return this.todos.find(todo => todo.id === id)?.title || '';
    }
  }
}
</script>

<template>
  <button
    type="button"
    class="button button--show-all-statistics"
    @click="toggleStatisticks"
  >
    show all statistics
  </button>

  <div
    class="statistics"
    :class="{
      'statistics--active': isStatistics,
    }"
  >
    <div class="statistics__container">
      <button
        type="button"
        class="button button--destroy button--close-modal"
        @click="toggleStatisticks"
      />
      <ul class="statistics__list">
        <li v-for="statistic of statistics" :key="statistic.id">
          <p class="statistics__title">
            Title todo:
            {{ statistic.deleted
              ? statistic.deleted.title
              : getTitleTodo(statistic.id)
            }}
          </p>          

          <p class="statistics__text statistics__text--created">
            <span>created</span>
             - 
            {{ getFormatDate(statistic.created) }}
          </p>

          <p
            class="statistics__text statistics__text--deleted"
            v-if="statistic.deleted"
          >
            <span>deleted</span>
            -
            {{ getFormatDate(statistic.deleted.date) }}
          </p>

          <table class="table" v-if="statistic.changes.length">
            <thead>
              <tr>
                <th>Date</th>

                <th>Previous value</th>

                <th>Updated value</th>
              </tr>
            </thead>

            <tbody>
              <tr
                v-for="change of statistic.changes"
                :key="change.date"
              >
                <td>{{ getFormatDate(change.date) }}</td>

                <td>{{ change.previousValue }}</td>

                <td>{{  change.updatedValue }}</td>
              </tr>
            </tbody>
          </table>

          <div class="statistics__buttons" v-if="statistic.deleted">
            <button
              class="button button--module button--restore"
              @click="restoreTodo(statistic.id, statistic.deleted)"
            >
              restore
            </button>
            <button
              class="button button--module button--del-permanently"
              @click="deleteImediately(statistic.id)"
            >
              delete permanently
            </button>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>
