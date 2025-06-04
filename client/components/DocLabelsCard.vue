<template>
  <BaseCard>
    <template #header>
      <CardHeader :title="props.title"/>
    </template>
    <p v-if="props.labels.length === 0" class="italic">(None)</p>
    <fieldset v-for="(groupOfLabels, slugGroup) in groupsOfLabels" :key="slugGroup">
      <legend v-if="slugGroup !== UNGROUPED" class="font-bold text-sm pt-2">{{slugGroup}}:</legend>
      <RpcCheckbox
        v-if="slugGroup === UNGROUPED"
        v-for="label in groupOfLabels"
        :key="label.slug"
        :label="`${label.slug === EXPEDITE_SLUG ? '⚠️ ' : ''}${label.slug}`"
        :value="label.slug"
        :checked="selectedSlugs?.includes(label.slug)"
        @change="handleCheckboxChange"
      />
      <div v-else class="ml-0.5">
        <DocLabelsListbox v-model="selectedSlugs" :value="labelGroupRefs[slugGroup]" :labels="groupOfLabels" :slug-group="slugGroup.toString()" @change="handleListboxChange" />
      </div>
    </fieldset>
  </BaseCard>
</template>

<script setup lang="ts">
import { groupBy } from 'lodash-es'
import type { Label } from '~/purple_client'
import { EXPEDITE_SLUG, SLUG_SEPARATOR, UNGROUPED } from '../utilities/labels'
import { assert } from '~/utilities/typescript'

type Props = {
  title: string
  labels: Label[]
}

const props = defineProps<Props>()

const selectedSlugs = defineModel<string[] | null>()

const handleCheckboxChange = (e: Event) => {
  const { target } = e;
  if (!(target instanceof HTMLInputElement)) {
    console.error(e)
    throw Error(`Unsupported event wasn't from expected element`)
  }
  assert(selectedSlugs.value)

  const { value, checked } = target

  if(checked && !selectedSlugs.value.includes(value)) {
    selectedSlugs.value.push(value)
  } else if (!checked && selectedSlugs.value.includes(value)) {
    const indexOf = selectedSlugs.value.indexOf(value)
    if(indexOf === -1) {
      throw Error(`Unexpected state. Should be able to find indexOf ${value} in ${JSON.stringify(selectedSlugs.value)}`)
    }
    selectedSlugs.value.splice(indexOf, 1)
  }
}

const handleListboxChange = (groupName: string, value: string | undefined) => {
  console.log("handleListboxChange", groupName, value)
}

const groupsOfLabels = computed(() => groupBy(
  props.labels,
  (label) => label.slug.includes(SLUG_SEPARATOR) ?
              label.slug.substring(0, label.slug.indexOf(SLUG_SEPARATOR)) :
              UNGROUPED
))

const labelGroupRefs = computed(() =>
    Object.keys(groupsOfLabels.value)
      .reduce((acc, slugGroup) => {
        const defaultSelectedSlug = groupsOfLabels.value[slugGroup].find(label => selectedSlugs.value?.includes(label.slug))
        acc[slugGroup] = defaultSelectedSlug?.slug
        return acc
      }, {} as Record<string, string | undefined>)
)

</script>
