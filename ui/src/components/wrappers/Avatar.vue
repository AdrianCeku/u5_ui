<script setup lang="ts">
import { Avatar, AvatarFallback, AvatarImage } from '../ui/avatar'

const props = defineProps<{
    url: string
    fallback: string
    size: 1 | 2 | 3 | 4
}>()

// const url = "https://cfx-nui-" + props.url
const url = "https://www.pngall.com/wp-content/uploads/12/Super-Mario-PNG-Pic.png"

const avatarSizes = {
  1: 'w-8 h-8',
  2: 'w-10 h-10',
  3: 'w-12 h-12',
  4: 'w-16 h-16'
}

const fontSizes = {
  1: 'text-md',
  2: 'text-lg',
  3: 'text-xl',
  4: 'text-2xl'
}

</script>

<template>
  <Avatar :class="avatarSizes[props.size]">
    <AvatarImage class="m-1" :src="url" />
    <AvatarFallback 
    class="font-bold opacity-80"
    :class="fontSizes[props.size]"
    >
    {{ props.fallback }}
  </AvatarFallback>
  </Avatar>
</template>