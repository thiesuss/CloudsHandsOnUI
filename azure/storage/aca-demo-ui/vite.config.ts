import path from "path"
import react from "@vitejs/plugin-react"
import cssInjectedByJsPlugin from 'vite-plugin-css-injected-by-js'
import { defineConfig } from "vite"
import dotenv from 'dotenv';
dotenv.config({ path: __dirname + '/.env.local' });


export default defineConfig({
  plugins: [react(), cssInjectedByJsPlugin()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
