<script setup>
    const props = defineProps(
        {
            text: String,
        }
    )
</script>

<template>
    <button @click="console.log('hi shad')" class="p-4 border-accent">
        {{ text }}
    </button>
</template>