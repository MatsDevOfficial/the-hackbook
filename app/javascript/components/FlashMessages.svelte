<script lang="ts">
  import { page } from '@inertiajs/svelte'
  import type { SharedProps } from '@/types'
  import { onMount } from 'svelte'
  import { fade, fly } from 'svelte/transition'

  let shared = $derived($page.props as unknown as SharedProps)
  let visible = $state(true)
  let timeout: number

  $effect(() => {
    if (shared.flash.notice || shared.flash.alert) {
      visible = true
      if (timeout) clearTimeout(timeout)
      timeout = window.setTimeout(() => {
        visible = false
      }, 5000)
    }
  })

  function close() {
    visible = false
  }
</script>

{#if visible && (shared.flash.notice || shared.flash.alert)}
  <div
    class="fixed top-8 right-8 z-[9999] flex flex-col gap-4 max-w-sm pointer-events-none"
    in:fly={{ x: 100, duration: 500 }}
    out:fade={{ duration: 300 }}
  >
    {#if shared.flash.notice}
      <div
        class="bg-brand-blue text-white p-6 rounded-2xl border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)] pointer-events-auto relative group"
      >
        <button
          onclick={close}
          class="absolute -top-2 -right-2 bg-black text-white w-8 h-8 rounded-full border-2 border-white flex items-center justify-center font-black opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer"
          >×</button
        >
        <div class="flex items-center gap-4">
          <span class="text-3xl text-brand-yellow">✨</span>
          <div>
            <div class="font-black uppercase text-xs tracking-widest opacity-80 mb-1">Notice</div>
            <p class="font-black text-lg leading-tight">{shared.flash.notice}</p>
          </div>
        </div>
      </div>
    {/if}

    {#if shared.flash.alert}
      <div
        class="bg-brand-red text-white p-6 rounded-2xl border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)] pointer-events-auto relative group"
      >
        <button
          onclick={close}
          class="absolute -top-2 -right-2 bg-black text-white w-8 h-8 rounded-full border-2 border-white flex items-center justify-center font-black opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer"
          >×</button
        >
        <div class="flex items-center gap-4">
          <span class="text-3xl">🚫</span>
          <div>
            <div class="font-black uppercase text-xs tracking-widest opacity-80 mb-1">Alert</div>
            <p class="font-black text-lg leading-tight">{shared.flash.alert}</p>
          </div>
        </div>
      </div>
    {/if}
  </div>
{/if}

<style>
  /* Optional: Add a slight shake animation for alerts */
  .bg-brand-red {
    animation: shake 0.5s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
    transform: translate3d(0, 0, 0);
  }

  @keyframes shake {
    10%,
    90% {
      transform: translate3d(-1px, 0, 0);
    }
    20%,
    80% {
      transform: translate3d(2px, 0, 0);
    }
    30%,
    50%,
    70% {
      transform: translate3d(-4px, 0, 0);
    }
    40%,
    60% {
      transform: translate3d(4px, 0, 0);
    }
  }
</style>
