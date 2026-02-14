<script lang="ts">
  import Nav from '@/components/Nav.svelte'
  import FlashMessages from '@/components/FlashMessages.svelte'
  import type { Snippet } from 'svelte'

  let { children }: { children: Snippet } = $props()
</script>

<Nav />
<FlashMessages />
<main class="blueprint-grid min-h-[calc(100vh-76px)]">
  {@render children()}
</main>
