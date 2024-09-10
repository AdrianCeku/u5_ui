<script setup>
    const props = defineProps(
        {
            text: String,
        }
    )
</script>

<template>
    <button @click="console.log('hi test')" class="p-4 border-primary">
        {{ text }}
    </button>
</template>