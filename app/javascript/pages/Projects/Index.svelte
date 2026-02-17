<script lang="ts">
  import { router, Link } from '@inertiajs/svelte'
  import Pagination from '@/components/Pagination.svelte'
  import type { ProjectCard, PagyProps } from '@/types'

  let props: { projects: ProjectCard[]; pagy: PagyProps; query: string } = $props()
  let searchQuery = $state(props.query)

  function search(e: Event) {
    e.preventDefault()
    router.get('/projects', { query: searchQuery }, { preserveState: true })
  }
</script>

<div class="max-w-6xl mx-auto py-12 px-6">
  <div class="flex flex-col md:flex-row items-center justify-between mb-12 gap-6">
    <div>
      <h1
        class="text-5xl font-black brand-heading bg-black text-white px-8 py-4 inline-block transform -rotate-2 -translate-x-4"
      >
        SCRIPTORIUM
      </h1>
      <p class="text-xl text-gray-600 mt-6 font-medium">Your collection of ongoing manuscripts and technical drafts.</p>
    </div>
    <Link
      href="/projects/new"
      class="bg-brand-red text-white px-8 py-4 rounded-xl font-bold text-xl hover:bg-black transition-all shadow-[6px_6px_0px_0px_rgba(236,55,80,0.3)] hover:shadow-none hover:translate-x-[4px] hover:translate-y-[4px]"
    >
      New Project
    </Link>
  </div>

  <form onsubmit={search} class="mb-12">
    <div class="flex gap-4">
      <input
        type="search"
        bind:value={searchQuery}
        placeholder="Search projects..."
        class="border-4 border-black rounded-xl px-6 py-3 flex-1 text-lg font-medium focus:ring-4 focus:ring-brand-red/20 outline-none transition-all"
      />
      <button
        type="submit"
        class="bg-black text-white px-8 py-3 rounded-xl font-bold text-lg hover:bg-brand-red transition-all cursor-pointer"
      >
        Search
      </button>
    </div>
  </form>

  {#if props.projects.length > 0}
    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      {#each props.projects as project}
        <div
          class="bg-white border-4 border-black p-6 rounded-2xl shadow-[8px_8px_0px_0px_rgba(0,0,0,0.05)] brand-card flex flex-col"
        >
          <div class="flex items-start justify-between mb-4">
            <h2 class="text-2xl font-black brand-heading">
              <Link href="/projects/{project.id}" class="hover:text-brand-red transition-colors">{project.name}</Link>
            </h2>
            {#if project.is_unlisted}
              <span class="bg-brand-yellow px-2 py-1 rounded-md text-xs font-black uppercase">Unlisted</span>
            {/if}
          </div>

          {#if project.description}
            <p class="text-gray-700 mt-2 line-clamp-2 flex-grow">{project.description}</p>
          {/if}

          {#if project.tags.length > 0}
            <div class="flex flex-wrap gap-2 mt-4">
              {#each project.tags as tag}
                <span
                  class="bg-gray-100 text-gray-700 text-xs font-bold px-2 py-1 rounded-full uppercase tracking-wider"
                  >{tag}</span
                >
              {/each}
            </div>
          {/if}

          <div class="flex items-center justify-between mt-6 pt-4 border-t-2 border-gray-100 text-sm">
            <div class="flex items-center gap-2">
              <span class="font-bold">by {project.user_display_name}</span>
            </div>
            <span class="bg-brand-blue/10 text-brand-blue px-2 py-1 rounded font-bold">{project.ships_count} ships</span
            >
          </div>
        </div>
      {/each}
    </div>

    <div class="mt-12 flex justify-center">
      <Pagination pagy={props.pagy} />
    </div>
  {:else}
    <div class="text-center py-24 bg-white/50 border-4 border-dashed border-gray-300 rounded-3xl">
      <p class="text-2xl text-gray-400 font-bold">No manuscripts yet. Be the first to draft your masterpiece!</p>
    </div>
  {/if}
</div>
