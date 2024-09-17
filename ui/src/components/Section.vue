<script setup lang="ts">
import { useTemplateRef } from 'vue'
import type { Section } from "../App.vue"

const sectionElement = useTemplateRef<HTMLDivElement>("section")

const props = defineProps<{
    section: Section
    sectionId: number
}>()

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

const roundedClasses = [
  "rounded-md",
  "rounded-t-2xl"
]

const defaultStyleCLasses = [
  "px-5",
  "pb-5",,
  "bg-background",
  ...roundedClasses
]

const positioningStyleClasses = [
  "absolute", 
  "top-0", 
  "left-0", 
  "bottom-0", 
  "right-0",
]

const positioningClassesMap = {
  "xAlign": {
    "left": "mr-auto",
    "center": "mx-auto",
    "right": "ml-auto"
  },
  "yAlign": {
    "top": "mb-auto",
    "center": "my-auto",
    "bottom": "mt-auto"
  },
  "width": {
    "full": "w-full",
    "twoThirds": "w-2/3",
    "half": "w-1/2",
    "third": "w-1/3",
    "quarter": "w-1/4",
    "fit" : "w-fit"
  },
  "height": {
    "full": "h-full",
    "twoThirds": "h-2/3",
    "half": "h-1/2",
    "third": "h-1/3",
    "quarter": "h-1/4",
    "fit" : "h-fit"
  },
}

// HELPERS

function getPositioningClasses() {
  const options = props.section.options
  
  const classes = []

  if(!options.noWrapperPositioningStyle) {
    classes.push(positioningClassesMap.width[options.width ?? "fit"] ?? positioningClassesMap.width["fit"])
    classes.push(positioningClassesMap.height[options.height ?? "fit"] ?? positioningClassesMap.height["fit"])
    classes.push(positioningClassesMap.xAlign[options.xAlign ?? "center"] ?? positioningClassesMap.xAlign["center"])
    classes.push(positioningClassesMap.yAlign[options.yAlign ?? "center"] ?? positioningClassesMap.yAlign["center"])
    classes.push(...positioningStyleClasses)
  }

  return classes
}

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

function getCloseAnimation() {
  const section = props.section
  if(section.options.xAlign === "left") {
    return "slideLeft"
  }
  else if(section.options.xAlign === "right") {
    return "slideRight"
  }
  else if(section.options.yAlign === "top") {
    return "slideTop"
  }
  else if(section.options.yAlign === "bottom") {
    return "slideBottom"
  }

  return "slideTop"
}

function getOpenAnimation() {
  const section = props.section
  if(section.options.xAlign === "left") {
    return "slideLeftReverse"
  }
  else if(section.options.xAlign === "right") {
    return "slideRightReverse"
  }
  else if(section.options.yAlign === "top") {
    return "slideTopReverse"
  }
  else if(section.options.yAlign === "bottom") {
    return "slideBottomReverse"
  }

  return "slideTopReverse"
}

// TRIGGERS

function visibilityChanged(onVisibilityChangeFunctionId: number, isVisible: boolean) {
  fetch(`https://u5_ui/visibilityChanged`, {
    method: "POST",
    headers: {
        "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({
        sectionId: props.sectionId,
        isVisible: isVisible,
        onVisibilityChangeFunctionId: onVisibilityChangeFunctionId
    })
  });
}

// MAIN

function openSection() {
  const onVisChangeId = props.section.onVisibilityChangeFunctionId

  if(props.section.isOpen) return
  if(!sectionElement.value) return

  sectionElement.value.classList.remove(getCloseAnimation())
  sectionElement.value.classList.add(getOpenAnimation())

  if(onVisChangeId) {
    visibilityChanged(onVisChangeId, true)
  }

  props.section.isOpen = true
}

function closeSection() {
  const onVisChangeId = props.section.onVisibilityChangeFunctionId 

  if(!props.section.isOpen) return
  if(!sectionElement.value) return

  sectionElement.value.classList.remove(getOpenAnimation())
  sectionElement.value.classList.add(getCloseAnimation())
  
  if(onVisChangeId) {
    visibilityChanged(onVisChangeId, false)
  }

  props.section.isOpen = false
}

// LISTENERS

window.addEventListener("message", (event) => {
  if (event.data.type === "closeSection") {
    const data = event.data
    closeSection()
  }

  else if (event.data.type === "openSection") {
    const data = event.data
    openSection()
  }
})

</script>

<template>
    <section 
      v-if="!props.section.isDeleted"
      ref="section"
      :class="getPositioningClasses()"
      class="m-10"
      :id="props.sectionId.toString()"
      :style="props.section.wrapperStyle"
    >
      <div 
      class="overflow-y-hidden overflow-x-hidden h-full w-full"
      :class="roundedClasses"
      >
        <div
          :style="props.section.style"
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
              @click="closeSection()"
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
      </div>
    <div :v-if="props.section.innerHTML" v-html="props.section.innerHTML"></div>
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

  .slideTop {
    animation: slideTop 2.5s forwards;
  }

  .slideBottom {
    animation: slideBottom 2.5s forwards;
  }

  .slideLeft {
    animation: slideLeft 2.5s forwards;
  }

  .slideRight {
    animation: slideRight 2.5s forwards;
  }

  .slideTopReverse {
    animation: slideTopReverse 0.5s forwards;
  }

  .slideBottomReverse {
    animation: slideBottomReverse 0.5s forwards;
  }

  .slideLeftReverse {
    animation: slideLeftReverse 0.5s forwards;
  }

  .slideRightReverse {
    animation: slideRightReverse 0.5s forwards;
  }

  @keyframes slideTop {
    0% {
      transform: translateY(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateY(-100vh);
      visibility: hidden;
    }
  }

  @keyframes slideBottom {
    0% {
      transform: translateY(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateY(100vh);
      visibility: hidden;
    }
  }

  @keyframes slideLeft {
    0% {
      transform: translateX(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateX(-100vw);
      visibility: hidden;
    }
  }

  @keyframes slideRight {
    0% {
      transform: translateX(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateX(100vw);
      visibility: hidden;
    }
  }

  @keyframes slideTopReverse {
    0% {
      transform: translateY(-100vh);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateY(0);
      visibility: visible;
    }
  }

  @keyframes slideBottomReverse {
    0% {
      transform: translateY(100vh);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateY(0);
      visibility: visible;
    }
  }

  @keyframes slideLeftReverse {
    0% {
      transform: translateX(-100vw);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateX(0);
      visibility: visible;
    }
  }

  @keyframes slideRightReverse {
    0% {
      transform: translateX(100vw);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateX(0);
      visibility: visible;
    }
  }
</style>