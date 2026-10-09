import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      // Proxy API calls to the app service (VITE_API_BASE_URL la inyecta el AppHost de Aspire)
      '/api': {
        target: process.env.VITE_API_BASE_URL || 'http://localhost:5277',
        changeOrigin: true
      }
    }
  }
});
