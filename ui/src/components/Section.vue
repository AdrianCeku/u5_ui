<script setup lang="ts">

import type { Section } from '../App.vue'


const classesMap = {
  "display": {
    "flex": "flex",
    "grid": "grid",
    "block": "block"
  },
  "xOverflow": {
    "visible": "overflow-x-visible",
    "hidden": "overflow-x-hidden",
    "scroll": "overflow-x-scroll",
    "auto": "overflow-x-auto"
  },
  "yOverflow": {
    "visible": "overflow-y-visible",
    "hidden": "overflow-y-hidden",
    "scroll": "overflow-y-scroll",
    "auto": "overflow-y-auto"
  }
}

const defaultStyleCLasses = [
  "px-5",
  "pb-5",,
  "bg-background",
  "rounded-md",
  "rounded-t-2xl"
]

function getClasses() {
  const options = props.section.options

  const classes = []

  if(!options.noPresetStyle) {
    classes.push(classesMap.display[options.display ?? "block"] ?? classesMap.display["block"])
    classes.push(classesMap.xOverflow[options.xOverflow ?? "auto"] ?? classesMap.xOverflow["auto"])
    classes.push(classesMap.yOverflow[options.yOverflow ?? "auto"] ?? classesMap.yOverflow["auto"])
  }

  if(!options.noDefaultStyle) {
    classes.push(...defaultStyleCLasses)
  }

  return classes
}

const props = defineProps<{
    section: Section
}>()
</script>

<template>
    <section 
      v-if="!props.section.isDeleted"
    >
      <div
        :style='props.section.style'
        :class="getClasses()"
        class="max-h-full max-w-full scroll-bar-styles"
      >
        <header 
          class="grid sticky top-0 bg-background pt-2"
          v-if="props.section.options.showCloseButton || props.section.options.image || props.section.options.title"
        >
          <svg
            v-if="props.section.options.showCloseButton"
            class="h-6 ml-auto cursor-pointer hover:scale-105 transition-transform translate-x-3"  
            xmlns="http://www.w3.org/2000/svg" 
            viewBox="0 0 512 512"
            @click="$emit('event-close')"
          >
            <path 
              fill="currentColor"
              d="M256 48a208 208 0 1 1 0 416 208 208 0 1 1 0-416zm0 464A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c-9.4 9.4-9.4 24.6 0 33.9l47 47-47 47c-9.4 9.4-9.4 24.6 0 33.9s24.6 9.4 33.9 0l47-47 47 47c9.4 9.4 24.6 9.4 33.9 0s9.4-24.6 0-33.9l-47-47 47-47c9.4-9.4 9.4-24.6 0-33.9s-24.6-9.4-33.9 0l-47 47-47-47c-9.4-9.4-24.6-9.4-33.9 0z"
              />
          </svg>
          <div 
            :v-if="props.section.options.image || props.section.options.title"
            class="flex items-center gap-5 justify-between mb-3"
          >
            <img 
              :v-if="props.section.options.image"
              :src="props.section.options.image"
              class="h-7"
            >
            <h1 
              :v-if="props.section.options.title"
              class="text-xl font-bold text-center"
            >
              {{ props.section.options.title }}
            </h1>
          </div>
        </header>
        <slot />
      </div>
    </section>
</template>

<style scoped>
.scroll-bar-styles::-webkit-scrollbar {
  width: 0.3rem;
}

.scroll-bar-styles::-webkit-scrollbar-thumb {
  background: hsl(var(--accent-foreground));
  border-radius: 1rem;
}

.scroll-bar-styles::-webkit-scrollbar-track {
  background: transparent;
}
</style>