<script setup lang="ts">
  import { NConfigProvider, NMessageProvider, darkTheme } from 'naive-ui';
  import NFTSelect from './components/NFTList.vue';
</script>

<template>
  <n-config-provider :theme="darkTheme">
    <n-message-provider>
      <NFTSelect />
    </n-message-provider>
  </n-config-provider>
</template>

<style>
body {
  background-color: black;
  color: white;
}
#app {
  box-sizing: border-box;
  height: 100vh;
  padding: 60px 40px 0;
}
</style>
