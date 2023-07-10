<script>
export default {
  props: {
    statisticsTodo: Object
  },
  emits: ['closeModal'],
  methods: {
    formatDate(dateProps) {
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
    }
  }
}
</script>

<template>
  <div class="modal">
    <div class="modal__content">
      <div class="modal__header">Statistics by todo "{{ statisticsTodo.title }}"</div>
      <div class="modal__body">
        <p class="modal__created">Created - {{ formatDate(statisticsTodo.created) }}</p>

        <table class="table" v-if="statisticsTodo.changes.length > 0">
          <thead>
            <tr>
              <th>Updated data</th>
              <th>Previous value</th>
              <th>Updated value</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="change of statisticsTodo.changes" :key="change.data">
              <td>{{ formatDate(change.date) }}</td>
              <td>{{ `${change.field}: ${change.previousValue}` }}</td>
              <td>{{ `${change.field}: ${change.updatedValue}` }}</td>
            </tr>
          </tbody>
        </table>

        <div v-else class="modal__noStatistic">no changes yet</div>
      </div>

      <button
        type="button"
        class="button button--destroy button--modal"
        @click="$emit('closeModal')"
      />
    </div>
  </div>
</template>
