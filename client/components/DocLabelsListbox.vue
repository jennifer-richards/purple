<template>
  <ListboxRoot class="flex flex-col shadow-sm mx-auto" :modelValue="props.value" @update:modelValue="handleChange">
    <ListboxContent>
      <ListboxGroup class="flex flex-col gap-1">
        <ListboxItem
          v-for="label in props.labels"
          :key="label.slug"
          :value="label.slug"
          class="w-full flex items-center pl-[25px] focus:ring-purple-800 focus:ring-2 rounded relative select-none outline-none data-[disabled]:opacity-50"
        >
          <ListboxItemIndicator class="absolute left-[2px] w-[17px] text-center">&check;</ListboxItemIndicator>
          <div class="absolute left-[2px] w-[17px] h-[16px] border border-gray-500 rounded"></div>
          <span v-if="label.slug === EXPEDITE_SLUG">⚠️</span>
          <span class="text-sm pl-1 cursor-pointer">{{ label.slug.substring(label.slug.indexOf(SLUG_SEPARATOR) + 1) }}</span>
        </ListboxItem>
      </ListboxGroup>
    </ListboxContent>
  </ListboxRoot>
</template>

<script setup lang="ts">
import { ListboxContent, ListboxGroup, ListboxItem, ListboxItemIndicator, ListboxRoot, type AcceptableValue } from 'reka-ui'
import type { Label } from '~/purple_client';
import { EXPEDITE_SLUG, SLUG_SEPARATOR } from '../utilities/labels'
import { assert } from '~/utilities/typescript';

type Props = {
  slugGroup: string
  labels: Label[]
  value: string | undefined
}

const props = defineProps<Props>()

const selectedSlugs = defineModel<string[] | null>()

const handleChange = computed(() => {
  return (value: AcceptableValue): void => {
    assert(selectedSlugs.value)

    const eraseExistingGroupSelection = () =>
      props.labels.forEach(label => {
        assert(selectedSlugs.value)
        const slugToRemove = label.slug
        if (selectedSlugs.value.includes(slugToRemove)) {
          const indexOf = selectedSlugs.value.indexOf(slugToRemove)
          assert(indexOf !== -1, `Unexpected state. Should be able to find indexOf ${value} in ${JSON.stringify(selectedSlugs.value)}`)
          selectedSlugs.value?.splice(indexOf, 1)
        }
      })

    if (value && !selectedSlugs.value.includes(value.toString())) {
      eraseExistingGroupSelection()
      selectedSlugs.value.push(value.toString())
    } else if (!value) {
      eraseExistingGroupSelection()
    }
  }
})

</script>
