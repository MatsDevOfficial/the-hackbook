<script lang="ts">
  import { router, Link } from '@inertiajs/svelte'
  import type { ProjectDetail } from '@/types'

  let { project, can }: { project: ProjectDetail; can: { update: boolean; destroy: boolean } } = $props()

  function deleteProject() {
    if (confirm('Are you sure?')) {
      router.delete(`/projects/${project.id}`)
    }
  }

  function isSafeUrl(url: string | null): boolean {
    if (!url) return false
    try {
      const parsed = new URL(url)
      return parsed.protocol === 'http:' || parsed.protocol === 'https:'
    } catch {
      return false
    }
  }

  let inviteEmail = $state('')
  let inviteRole = $state('member')

  function inviteMember(e: Event) {
    e.preventDefault()
    router.post(`/projects/${project.id}/invite`, {
      email: inviteEmail,
      role: inviteRole,
    })
    inviteEmail = ''
  }
</script>

<div class="max-w-4xl mx-auto py-12 px-6">
  <div class="bg-white border-4 border-black p-8 rounded-2xl shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)] mb-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between mb-8 gap-4">
      <div>
        <h1 class="font-black text-5xl md:text-6xl flavortown-heading leading-none">{project.name}</h1>
        <div class="flex items-center gap-4 mt-4">
          <span
            class="px-3 py-1 rounded-full text-xs font-black uppercase tracking-widest border-2 border-black {project.project_type ===
            'club'
              ? 'bg-brand-purple text-white'
              : 'bg-brand-blue text-white'}"
          >
            {project.project_type} project
          </span>
          <p class="text-sm text-gray-500 font-bold uppercase tracking-wider">
            Created by <span class="text-brand-red">{project.user_display_name}</span> on {project.created_at}
          </p>
        </div>
      </div>
      <div class="flex gap-3">
        {#if can.update}
          <Link
            href="/projects/{project.id}/edit"
            class="bg-black text-white px-6 py-2 rounded-xl font-bold hover:bg-brand-blue transition-all">Edit</Link
          >
        {/if}
        {#if can.destroy}
          <button
            onclick={deleteProject}
            class="bg-brand-red text-white px-6 py-2 rounded-xl font-bold hover:bg-black transition-all cursor-pointer"
            >Delete</button
          >
        {/if}
      </div>
    </div>

    {#if project.is_unlisted}
      <div class="mb-6">
        <span
          class="bg-brand-yellow px-3 py-1 rounded-full text-xs font-black uppercase tracking-widest border-2 border-black"
          >Unlisted</span
        >
      </div>
    {/if}

    {#if project.description}
      <div class="prose prose-xl max-w-none text-gray-800 leading-relaxed mb-8">
        {project.description}
      </div>
    {/if}

    <div class="grid grid-cols-2 md:grid-cols-4 gap-6 mb-8 py-6 border-y-4 border-black/5">
      <div class="bg-brand-blue/10 p-4 rounded-xl border-2 border-brand-blue/20">
        <div class="text-xs font-black uppercase tracking-widest text-brand-blue mb-1">Hours Logged</div>
        <div class="text-3xl font-black">{project.hours_logged}h</div>
      </div>
      <div class="bg-brand-red/10 p-4 rounded-xl border-2 border-brand-red/20">
        <div class="text-xs font-black uppercase tracking-widest text-brand-red mb-1">Multiplier</div>
        <div class="text-3xl font-black">x{project.point_multiplier}</div>
      </div>
      <div class="bg-brand-yellow/10 p-4 rounded-xl border-2 border-brand-yellow/20">
        <div class="text-xs font-black uppercase tracking-widest text-brand-yellow mb-1">Total Points</div>
        <div class="text-3xl font-black">{Math.round(project.hours_logged * project.point_multiplier * 100) / 100}</div>
      </div>
    </div>

    {#if project.project_type === 'club' && project.club_prizes}
      <div class="mb-8 p-6 bg-brand-yellow/10 border-4 border-dashed border-brand-yellow rounded-2xl">
        <h3 class="text-xl font-black flavortown-heading text-brand-yellow-dark mb-2">🎁 Club Prizes</h3>
        <p class="text-lg text-gray-800">{project.club_prizes}</p>
      </div>
    {/if}

    <div class="mb-12">
      <div class="flex items-center justify-between mb-6">
        <h3 class="font-black text-2xl flavortown-heading">Segments</h3>
        <Link
          href="/segments/new?project_id={project.id}"
          class="bg-black text-white px-6 py-2 rounded-xl font-bold hover:bg-brand-red transition-all shadow-[4px_4px_0px_0px_rgba(236,55,80,0.3)] hover:shadow-none hover:translate-x-[2px] hover:translate-y-[2px]"
        >
          + Add Segment
        </Link>
      </div>

      {#if project.segments && project.segments.length > 0}
        <div class="grid grid-cols-1 gap-4">
          {#each project.segments as segment}
            <Link
              href="/segments/{segment.id}"
              class="group bg-white border-4 border-black p-4 rounded-xl flex items-center justify-between hover:bg-gray-50 transition-all shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-[2px] hover:translate-y-[2px]"
            >
              <div>
                <span class="text-xl font-bold block group-hover:text-brand-red transition-colors"
                  >📄 {segment.title}</span
                >
                <span class="text-xs text-gray-400 font-bold uppercase">{segment.created_at}</span>
              </div>
              <span class="text-gray-300 group-hover:text-black transition-colors">→</span>
            </Link>
          {/each}
        </div>
      {:else}
        <div class="text-center py-12 border-4 border-dashed border-gray-200 rounded-2xl">
          <p class="text-gray-400 font-bold italic">No segments yet. Start documenting your progress!</p>
        </div>
      {/if}
    </div>

    {#if project.project_type === 'club'}
      <div class="mb-12">
        <h3 class="font-black text-2xl flavortown-heading mb-6">Crew Members</h3>
        <div class="flex flex-wrap gap-4 mb-8">
          {#each project.members as member}
            <div class="flex flex-col items-center gap-2 group">
              <img
                src={member.avatar || '/static-assets/pfp_fallback.webp'}
                alt={member.display_name}
                class="w-16 h-16 rounded-full border-4 border-black group-hover:scale-110 transition-transform"
              />
              <span class="text-xs font-bold uppercase">{member.display_name}</span>
            </div>
          {/each}
        </div>

        {#if can.update}
          <div class="bg-gray-50 p-6 rounded-2xl border-4 border-black border-dashed">
            <h4 class="font-black text-lg mb-4 uppercase">Invite more Crew</h4>
            <form onsubmit={inviteMember} class="flex flex-col sm:flex-row gap-3">
              <input
                type="email"
                bind:value={inviteEmail}
                placeholder="email@example.com"
                required
                class="flex-1 border-4 border-black rounded-xl px-4 py-2 font-bold focus:outline-none focus:ring-4 focus:ring-brand-blue/20"
              />
              <select
                bind:value={inviteRole}
                class="border-4 border-black rounded-xl px-4 py-2 font-bold focus:outline-none"
              >
                <option value="member">Member</option>
                <option value="leader">Leader</option>
              </select>
              <button
                type="submit"
                class="bg-brand-blue text-white px-6 py-2 rounded-xl font-black hover:bg-black transition-all cursor-pointer"
              >
                Send Invite
              </button>
            </form>
          </div>
        {/if}
      </div>
    {/if}

    {#if project.tags.length > 0}
      <div class="flex flex-wrap gap-2 mb-8">
        {#each project.tags as tag}
          <span
            class="bg-gray-100 text-gray-700 text-sm font-bold px-4 py-2 rounded-full border-2 border-transparent hover:border-black transition-all cursor-default uppercase"
            >{tag}</span
          >
        {/each}
      </div>
    {/if}

    <div class="flex flex-wrap gap-6 pt-8 border-t-4 border-black/5">
      {#if isSafeUrl(project.demo_link)}
        <a
          href={project.demo_link}
          target="_blank"
          rel="noopener"
          class="flex items-center gap-2 bg-brand-green/20 text-brand-green px-6 py-3 rounded-xl font-black text-lg hover:bg-brand-green hover:text-white transition-all"
        >
          <span class="text-2xl">🚀</span> Live Demo
        </a>
      {/if}
      {#if isSafeUrl(project.repo_link)}
        <a
          href={project.repo_link}
          target="_blank"
          rel="noopener"
          class="flex items-center gap-2 bg-brand-blue/20 text-brand-blue px-6 py-3 rounded-xl font-black text-lg hover:bg-brand-blue hover:text-white transition-all"
        >
          <span class="text-2xl">💻</span> Source Code
        </a>
      {/if}
    </div>
  </div>

  <div class="mt-8">
    <Link href="/projects" class="font-bold text-gray-500 hover:text-black transition-colors flex items-center gap-2">
      ← Back to the Pantry
    </Link>
  </div>
</div>
