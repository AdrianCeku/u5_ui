<script setup lang="ts">
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '../ui/alert-dialog'

const props = defineProps<{
    trigger: string
    headline: string
    content: string
    action?: string
    cancel?: string
}>()
</script>

<template>
  <AlertDialog>
    <AlertDialogTrigger>{{ props.trigger }}</AlertDialogTrigger>
    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>{{ props.headline }}</AlertDialogTitle>
        <AlertDialogDescription>
            {{ props.content }}
            <slot />
        </AlertDialogDescription>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <AlertDialogCancel @click="$emit('event-click', {accept: false})">{{ props.cancel ?? "cancel" }}</AlertDialogCancel>
        <AlertDialogAction @click="$emit('event-click', {accept: true})">{{ props.action ?? "continue" }}</AlertDialogAction>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>