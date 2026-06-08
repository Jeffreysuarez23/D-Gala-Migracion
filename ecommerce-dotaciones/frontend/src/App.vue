<template>
  <div id="app">
    <Navbar v-if="!$route.meta.hideNavbar" :cart-count="1" />
    <main>
      <router-view />
    </main>
    <Footer v-if="!$route.meta.hideFooter" />
  </div>
</template>
<script setup>
import Navbar from './components/Navbar.vue';
import Footer from './components/Footer.vue';
</script>

<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html, body {
  width: 100%;
  overflow-x: hidden;
}

#app {
  width: 100%;
  min-height: 100vh;
}

main {
  width: 100%;
}
</style>