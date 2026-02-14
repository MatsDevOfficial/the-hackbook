<script lang="ts">
  import { Link } from '@inertiajs/svelte'
  let { user }: { user: { display_name: string; email: string } } = $props()
</script>

<div class="max-w-4xl mx-auto py-12 px-6">
  <div class="bg-white border-4 border-black p-8 rounded-2xl shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)]">
    <h1 class="font-black text-5xl mb-6 flavortown-heading">Welcome, Chef!</h1>
    <p class="text-xl text-gray-700 mb-8 leading-relaxed">
      You're logged in as <span class="font-bold text-brand-red">{user.display_name}</span> ({user.email}). Ready to
      cook up something legendary?
    </p>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <Link
        href="/projects"
        class="bg-brand-red text-white p-6 rounded-xl font-bold text-xl hover:bg-black transition-all shadow-[6px_6px_0px_0px_rgba(0,0,0,0.1)] block text-center"
      >
        My Projects
      </Link>
      <Link
        href="/docs"
        class="bg-brand-blue text-white p-6 rounded-xl font-bold text-xl hover:bg-black transition-all shadow-[6px_6px_0px_0px_rgba(0,0,0,0.1)] block text-center"
      >
        Read Docs
      </Link>
    </div>
  </div>
</div>
