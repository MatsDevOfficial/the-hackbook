<script lang="ts">
  import { router, Link } from '@inertiajs/svelte'
  import Pagination from '@/components/Pagination.svelte'
  import type { AdminUserRow, PagyProps } from '@/types'

  let props: { users: AdminUserRow[]; pagy: PagyProps; query: string } = $props()
  let searchQuery = $state(props.query)

  function search(e: Event) {
    e.preventDefault()
    router.get('/admin/users', { query: searchQuery }, { preserveState: true })
  }
</script>

<div class="max-w-6xl mx-auto py-12 px-6">
  <div class="mb-12">
    <h1 class="font-black text-5xl md:text-6xl brand-heading">Admin: Users</h1>
    <p class="text-xl text-gray-600 mt-2">Manage all members in the Hackbook network.</p>
  </div>

  <form onsubmit={search} class="mb-12">
    <div class="flex gap-4">
      <input
        type="search"
        bind:value={searchQuery}
        placeholder="Search users by name or email..."
        class="border-4 border-black rounded-xl px-6 py-4 flex-1 text-lg font-medium focus:ring-4 focus:ring-brand-red/20 outline-none transition-all"
      />
      <button
        type="submit"
        class="bg-black text-white px-8 py-4 rounded-xl font-black text-lg hover:bg-brand-red transition-all cursor-pointer"
      >
        Search
      </button>
    </div>
  </form>

  <div
    class="bg-white border-4 border-black rounded-2xl overflow-hidden shadow-[12px_12px_0px_0px_rgba(0,0,0,0.05)] mb-12"
  >
    <table class="w-full border-collapse">
      <thead>
        <tr class="bg-gray-50 border-b-4 border-black text-left">
          <th class="py-4 px-6 font-black uppercase text-sm tracking-wider">Name</th>
          <th class="py-4 px-6 font-black uppercase text-sm tracking-wider">Email</th>
          <th class="py-4 px-6 font-black uppercase text-sm tracking-wider">Roles</th>
          <th class="py-4 px-6 font-black uppercase text-sm tracking-wider">Projects</th>
          <th class="py-4 px-6 font-black uppercase text-sm tracking-wider">Joined</th>
        </tr>
      </thead>
      <tbody>
        {#each props.users as user}
          <tr
            class="border-b-2 border-gray-100 hover:bg-gray-50 transition-colors"
            class:opacity-50={user.is_discarded}
          >
            <td class="py-4 px-6">
              <div class="flex items-center gap-3">
                <Link href="/admin/users/{user.id}" class="font-black text-lg hover:text-brand-red transition-colors"
                  >{user.display_name}</Link
                >
                {#if user.is_discarded}
                  <span class="bg-brand-red text-white text-[10px] font-black px-2 py-0.5 rounded uppercase"
                    >Deleted</span
                  >
                {/if}
              </div>
            </td>
            <td class="py-4 px-6 font-medium text-gray-600">{user.email}</td>
            <td class="py-4 px-6">
              <div class="flex flex-wrap gap-1">
                {#each user.roles as role}
                  <span
                    class="bg-gray-200 text-gray-800 text-[10px] font-black px-2 py-0.5 rounded uppercase tracking-tighter"
                    >{role}</span
                  >
                {/each}
              </div>
            </td>
            <td class="py-4 px-6 font-black text-brand-blue">{user.projects_count}</td>
            <td class="py-4 px-6 text-gray-500 font-medium">{user.created_at}</td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>

  <div class="flex justify-center">
    <Pagination pagy={props.pagy} />
  </div>
</div>
