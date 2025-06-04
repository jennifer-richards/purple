<template>
  <BaseCard>
    <template #header>
      <CardHeader :title="props.title"/>
    </template>
    <p v-if="props.labels.length === 0" class="italic">(None)</p>
    <fieldset v-for="(groupOfLabels, slugGroup) in groupsOfLabels" :key="slugGroup">
      <legend v-if="slugGroup !== UNGROUPED" class="font-bold">{{slugGroup}}:</legend>
      <RpcCheckbox
        v-if="slugGroup === UNGROUPED"
        v-for="label in groupOfLabels"
        :key="label.slug"
        :label="`${label.slug === EXPEDITE_SLUG ? '⚠️ ' : ''}${label.slug}`"
        :value="label.slug"
        @change="props.handleChange"
      />
      <div v-else class="ml-2">
        <RpcRadio
          v-for="label in groupOfLabels"
          :name="slugGroup"
          :key="label.slug"
          :label="`${label.slug === EXPEDITE_SLUG ? '⚠️ ' : ''}${label.slug.substring(label.slug.indexOf(SLUG_SEPARATOR) + 1)}`"
          :value="label.slug"
          @change="props.handleChange"
        />
      </div>
    </fieldset>
  </BaseCard>
</template>

<script setup lang="ts">
import { groupBy } from 'lodash-es'
import type { Label } from '~/purple_client'

type Props = {
  title: string
  labels: Label[]
  handleChange: (e: Event) => void
}

const props = defineProps<Props>()

const SLUG_SEPARATOR = ':'
const UNGROUPED = "__UNGROUPED"
const EXPEDITE_SLUG = "expedited"

const groupsOfLabels = computed(() => groupBy(
  props.labels,
  (label) => label.slug.includes(SLUG_SEPARATOR) ?
              label.slug.substring(0, label.slug.indexOf(SLUG_SEPARATOR)) :
              UNGROUPED
))

</script>
