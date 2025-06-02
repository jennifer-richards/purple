<template>
  <BaseCard>
    <template #header>
      <CardHeader title="Other"/>
    </template>

    <fieldset>
      <legend>Exceptions</legend>
      <p v-if="exceptionLabels.length === 0 && otherCapabilities.length === 0" classList="italic text-sm mt-1">(none)</p>
      <RpcCheckbox
        v-for="otherCapability in otherCapabilities"
        :key="otherCapability.id"
        :label="`⚠️ ${otherCapability.slug}`"
        :desc="otherCapability.desc"
      />
      <RpcCheckbox
        v-for="exception in exceptionLabels"
        :key="exception.id"
        :label="exception.slug"
        :desc="exception.desc"
      />
    </fieldset>

    <fieldset className="mt-2">
      <legend>Complexities</legend>
      <p v-if="complexityLabels.length === 0" classList="italic text-sm mt-1">(none)</p>
      <RpcCheckbox
        v-for="complexity in complexityLabels"
        :key="complexity.id"
        :label="complexity.slug"
        :desc="complexity.desc"
      />
    </fieldset>
  </BaseCard>
</template>

<script setup lang="ts">
import type { Label, Capability } from '~/purple_client'

type Props = {
  exceptionLabels: Label[],
  complexityLabels: Label[]
  otherCapabilities: Capability[]
}

const props = defineProps<Props>()

</script>
