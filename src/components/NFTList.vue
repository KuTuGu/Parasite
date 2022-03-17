<template>
  <n-divider><h1>Your NFT List</h1></n-divider>
    <n-grid :cols="`${width}:1 ${width * 2}:2 ${width * 3}:3 ${width * 4}:4 ${width * 5}:5 ${width * 6}:6 ${width * 7}:7 ${width * 8}:8`">
      <n-grid-item v-for="i in list" :key="i.value" >
        <n-image
          :width="width"
          height="200"
          object-fit="contain"
          :src="i.image"
          :alt="i.label"
          :fallback-src="i.image"
          preview-src="https://peer-ap1.decentraland.org/content/contents/QmX69fi2P18dD585yJhp7FzHzJtgwKUgJLQkMVMKj49kY5"
        />
      </n-grid-item>
    </n-grid>
</template>

<style scoped>
.light-green {
  height: 108px;
  background-color: rgba(0, 128, 0, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>

<script setup lang="ts">
  import { ref, onMounted, h, watchEffect } from 'vue';
  import { NGrid, NGridItem, NDivider, NImage, NSpace, useMessage } from 'naive-ui';
  import * as MoralisUtils from "../utils/moralis";

  window.$message = useMessage();

  const list = ref([]);
  const nft = ref(null);
  const loading = ref(false);
  const width = ref(150);

  const getNFTList = async (addr: string) => {
    loading.value = true;
    list.value = await MoralisUtils.getAllNFTs(addr);
    loading.value = false;
  };

  const renderNFTList = (o: { node: VNode, option }) => {
    const { node, option } = o;

    return h(
      NSpace,
      {
        height: 100,
      },
      () => [
        h(
          NImage,
          {
            height: 100,
            src: option?.image
          },
        ),
        option.label as string
      ]
    )
  }

  onMounted(async () => {
    MoralisUtils.init();
    // await getNFTList(await MoralisUtils.login());
    await getNFTList("0xCb3798bEbDa7B939754794dF7d5966ED756892EA");

    MoralisUtils.listenAccountChange(async (addr: string) => getNFTList(addr));
  });

  watchEffect(() => console.log(nft.value))
</script>
