import path from 'node:path'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
  ],
  base: "/ui/dist",
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
