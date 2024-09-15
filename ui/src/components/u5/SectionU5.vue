<script setup lang="ts">

interface Section {
  isDeleted: boolean
  isOpen: boolean
  options: {
    title?: string
    image?: string
    showCloseButton?: boolean
    xAlign?: "left" | "center" | "right"
    yAlign?: "top" | "center" | "bottom"
    width?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    height?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    display?: "flex" | "grid" | "block"
    xOverflow?: "visible" | "hidden" | "scroll" | "auto"
    yOverflow?: "visible" | "hidden" | "scroll" | "auto"
  }
  style?: string
  innerHTML?: string
  onOpenId?: number
  onCloseId?: number
  components: {    
    isDeleted: boolean
    componentType: string
    props?: {
      [key: string]: any
    }
    innerHTML?: string
    onClickId?: number
    onInputId?: number
    style?: string[]
  }[]
}

const props = defineProps<{
    section: Section
}>()
</script>

<template>
    <section 
      class="m-10 px-5 pb-5 pt-2 bg-background rounded-md rounded-t-2xl shadow-lg"
      v-if="!section.isDeleted"
    >
    <header class="grid">
      <svg
        v-if="!section.options.showCloseButton === false"
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
        :v-if="section.options.image || section.options.title"
        class="flex items-center gap-5 justify-between"
      >
        <img 
          :v-if="section.options.image"
          :src="section.options.image"
          class="h-7"
        >
        <h1 
          :v-if="section.options.title"
          class="text-xl font-bold text-center"
        >
          {{ section.options.title }}
        </h1>
      </div>
    </header>
    <slot />

    </section>
</template>