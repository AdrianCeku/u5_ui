<script setup lang="ts">

import type { Section } from '../App.vue'

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
      >
        <header 
          class="grid"
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