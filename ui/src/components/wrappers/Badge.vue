<script setup lang="ts">
import { Badge } from '../ui/badge'

const props = defineProps<{
  content: string
  size: 1 | 2 | 3 | 4
  variant?: "secondary" | "outline" | "destructive"
}>()

const sizes = {
  1: 'text-xs',
  2: 'text-sm px-3',
  3: 'text-md px-4',
  4: 'text-lg px-5'
}

</script>

<template>
  <Badge
    :class="sizes[props.size]"
    :variant="props.variant"
  >
    {{ content }}
    <slot />
  </Badge>
</template>