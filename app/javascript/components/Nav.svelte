<script lang="ts">
  import { page, router, Link } from '@inertiajs/svelte'
  import type { SharedProps } from '@/types'

  let shared = $derived($page.props as unknown as SharedProps)

  function signOut(e: Event) {
    e.preventDefault()
    router.delete(shared.sign_out_path)
  }
</script>

<nav
  class="bg-black text-white px-6 py-4 flex items-center justify-between border-b-4 border-brand-red sticky top-0 z-50"
>
  <Link href="/" class="text-2xl font-black tracking-tighter flavortown-heading hover:text-brand-red transition-colors">
    THE HACKBOOK
  </Link>

  <div class="flex items-center gap-6">
    <Link href="/docs" class="font-bold hover:text-brand-red transition-colors">Docs</Link>
    <Link href="/shop" class="font-bold hover:text-brand-red transition-colors">Market</Link>

    {#if shared.auth.user}
      <div class="flex items-center gap-4">
        <span class="text-gray-400 hidden md:inline">{shared.auth.user.display_name}</span>
        {#if !shared.auth.user.github_connected}
          <a
            href={shared.github_auth_path}
            class="bg-brand-blue text-white px-4 py-2 rounded-lg font-bold hover:bg-white hover:text-brand-blue transition-all"
          >
            Connect GitHub
          </a>
        {/if}
        <button
          onclick={signOut}
          class="bg-brand-red text-white px-4 py-2 rounded-lg font-bold hover:bg-white hover:text-brand-red transition-all cursor-pointer"
        >
          Sign Out
        </button>
      </div>
    {:else}
      <a
        href={shared.sign_in_path}
        class="bg-brand-red text-white px-4 py-2 rounded-lg font-bold hover:bg-white hover:text-brand-red transition-all"
      >
        Sign In
      </a>
    {/if}
  </div>
</nav>
