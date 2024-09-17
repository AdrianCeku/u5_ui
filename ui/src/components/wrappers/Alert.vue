<script setup lang="ts">
import { Alert, AlertDescription, AlertTitle } from "../ui/alert"

const props = defineProps({
    headline: String,
    content: String
})
</script>

<template>
  <Alert>
    <AlertTitle>{{ props.headline }}</AlertTitle>
    <AlertDescription>
      {{ props.content }}
        <slot />
    </AlertDescription>
  </Alert>
</template>