<script lang="ts">
  import { useForm, router } from '@inertiajs/svelte'
  import { onMount } from 'svelte'
  import { marked } from 'marked'

  // Assuming SegmentForm is defined elsewhere or using 'any' for simplicity as per original
  // If SegmentForm is not defined, it would be a type error.
  // For this task, I'll assume it's either defined or 'any' is acceptable for the instruction.
  // Based on the instruction, the `EditorProps` interface is replaced by the inline type for `props`.
  // The instruction implies `SegmentForm` is a type for `segment`.
  // Let's define a minimal SegmentForm type to make it syntactically correct.
  interface SegmentForm {
    id?: number
    title: string
    content: string
    demo_link: string
    repo_link: string
    is_unlisted: boolean
    tags: string[]
    hours_logged: number
    point_multiplier: number
    project_id?: number // Added project_id
  }

  let props: {
    segment: SegmentForm
    is_new: boolean
    project?: {
      id: number
      name: string
      project_type: 'personal' | 'club'
      selected_prizes: string[]
      available_prizes: Array<{ id: string; name: string; cost: number }>
    }
    projects?: Array<{ id: number; name: string }>
  } = $props()

  const urlParams = new URLSearchParams(window.location.search)
  const initialProjectId = props.segment.project_id || parseInt(urlParams.get('project_id') || '0')

  const form = useForm({
    title: props.segment.title,
    content: props.segment.content,
    repo_link: props.segment.repo_link,
    is_unlisted: props.segment.is_unlisted,
    tags: props.segment.tags,
    hours_logged: props.segment.hours_logged || 0,
    point_multiplier: props.segment.point_multiplier || (props.project?.project_type === 'club' ? 0.75 : 1.0),
    project_id: initialProjectId,
    publish: false,
    selected_prizes: props.project?.selected_prizes || [],
  })

  let previewContent = $state('')
  let showSettings = $state(false)

  $effect(() => {
    ;(async () => {
      const result = await marked.parse($form.content)
      previewContent = String(result)
    })()
  })

  function submit(e: Event) {
    e.preventDefault()
    if (props.is_new) {
      $form.post('/segments')
    } else {
      $form.patch(`/segments/${props.segment.id}`)
    }
  }

  function deleteSegment() {
    if (confirm('Are you sure you want to delete this segment?')) {
      router.delete(`/segments/${props.segment.id}`)
    }
  }
</script>

<div class="max-w-6xl mx-auto py-12 px-6">
  <div class="flex items-center justify-between mb-8">
    <div class="flex items-center gap-4">
      <h1 class="font-black text-5xl flavortown-heading">{props.is_new ? 'New Segment' : 'Edit Segment'}</h1>
      <button
        type="button"
        onclick={() => (showSettings = !showSettings)}
        class="bg-brand-blue/10 text-brand-blue px-4 py-2 rounded-xl font-bold border-2 border-brand-blue/20 hover:bg-brand-blue hover:text-white transition-all cursor-pointer"
      >
        {showSettings ? 'Hide' : 'Show'} Project Settings
      </button>
    </div>
    <div class="flex gap-4">
      {#if !props.is_new}
        <button
          onclick={deleteSegment}
          class="bg-brand-red text-white px-6 py-2 rounded-xl font-bold hover:bg-black transition-all cursor-pointer"
          >Delete</button
        >
      {/if}
      <a
        href="/projects/{$form.project_id}"
        class="bg-gray-200 px-6 py-2 rounded-xl font-bold hover:bg-black hover:text-white transition-all">Cancel</a
      >
    </div>
  </div>

  {#if props.project && props.project.project_type === 'club'}
    <div class="mb-8 bg-brand-yellow/10 border-4 border-brand-yellow/50 p-6 rounded-2xl flex items-center gap-4">
      <span class="text-4xl">⚠️</span>
      <div>
        <h4 class="font-black uppercase tracking-widest text-brand-yellow-dark">Club Project Notice</h4>
        <p class="font-bold">Club projects receive lower point multipliers than personal projects.</p>
      </div>
    </div>
  {/if}

  <form onsubmit={submit} class="space-y-8">
    <div class="bg-white border-4 border-black p-8 rounded-2xl shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)]">
      {#if showSettings}
        <div
          class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12 p-8 bg-brand-blue/5 border-4 border-dashed border-brand-blue/20 rounded-2xl transition-all"
        >
          <div class="space-y-6">
            <h3 class="font-black text-xl uppercase tracking-widest text-brand-blue mb-4">Project Settings</h3>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label for="hours_logged" class="block font-black uppercase text-xs tracking-widest mb-2"
                  >Hours Logged</label
                >
                <input
                  id="hours_logged"
                  bind:value={$form.hours_logged}
                  type="number"
                  min="0"
                  class="w-full border-4 border-black rounded-xl px-4 py-3 font-bold outline-none focus:ring-4 focus:ring-brand-blue/20 transition-all"
                />
              </div>
              <div>
                <label for="point_multiplier" class="block font-black uppercase text-xs tracking-widest mb-2"
                  >Multiplier</label
                >
                <input
                  id="point_multiplier"
                  bind:value={$form.point_multiplier}
                  type="number"
                  step="0.1"
                  min="0.1"
                  class="w-full border-4 border-black rounded-xl px-4 py-3 font-bold outline-none focus:ring-4 focus:ring-brand-blue/20 transition-all"
                />
              </div>
            </div>

            <div>
              <label for="repo_link" class="block font-black uppercase text-xs tracking-widest mb-2">Repo Link</label>
              <input
                id="repo_link"
                bind:value={$form.repo_link}
                type="url"
                placeholder="https://github.com/..."
                class="w-full border-4 border-black rounded-xl px-4 py-3 font-bold outline-none focus:ring-4 focus:ring-brand-blue/20 transition-all"
              />
            </div>

            <div class="flex items-center gap-3">
              <input
                id="is_unlisted"
                type="checkbox"
                bind:checked={$form.is_unlisted}
                class="w-6 h-6 border-4 border-black rounded-lg text-brand-blue focus:ring-brand-blue/20"
              />
              <label for="is_unlisted" class="font-black uppercase text-xs tracking-widest">Unlisted (Draft)</label>
            </div>

            {#if props.project && props.project.project_type === 'club'}
              <div>
                <label
                  for="prizes-select"
                  class="block font-black uppercase text-xs tracking-widest mb-2 text-brand-blue">Selected Prizes</label
                >
                <div class="flex flex-wrap gap-2 mb-2">
                  {#each $form.selected_prizes as prizeId}
                    <span
                      class="bg-brand-blue/10 text-brand-blue px-3 py-1 rounded-full text-xs font-black uppercase tracking-widest border-2 border-brand-blue/20 flex items-center gap-2"
                    >
                      {props.project.available_prizes.find((p) => p.id === prizeId)?.name || prizeId}
                      <button
                        type="button"
                        onclick={() => ($form.selected_prizes = $form.selected_prizes.filter((id) => id !== prizeId))}
                        class="hover:text-brand-red">×</button
                      >
                    </span>
                  {/each}
                </div>
                <select
                  id="prizes-select"
                  class="w-full border-4 border-black rounded-xl px-4 py-3 font-bold outline-none focus:ring-4 focus:ring-brand-blue/20 transition-all"
                  onchange={(e) => {
                    const val = (e.target as HTMLSelectElement).value
                    if (val && !$form.selected_prizes.includes(val)) {
                      $form.selected_prizes = [...$form.selected_prizes, val]
                    }
                  }}
                >
                  <option value="">Select a prize...</option>
                  {#each props.project.available_prizes as prize}
                    <option value={prize.id}>{prize.name} ({prize.cost}pts)</option>
                  {/each}
                </select>
              </div>
            {/if}
          </div>

          <div class="flex flex-col justify-center items-center border-l-4 border-black/5 pl-8">
            <div class="text-center">
              <div class="text-xs font-black uppercase tracking-widest text-brand-yellow mb-2">Project Score</div>
              <div class="text-6xl font-black">
                {Math.round($form.hours_logged * $form.point_multiplier * 100) / 100}
              </div>
              <div class="text-sm font-bold text-gray-400 mt-2 italic">Points calculated instantly!</div>
            </div>
          </div>
        </div>
      {/if}

      <div class="mb-8">
        <label for="title" class="block font-black uppercase text-sm tracking-widest mb-2">Document Title</label>
        <input
          id="title"
          bind:value={$form.title}
          type="text"
          placeholder="New Document"
          class="w-full border-4 border-black rounded-xl px-6 py-4 text-2xl font-black outline-none focus:ring-4 focus:ring-brand-red/20 transition-all"
        />
        {#if $form.errors.title}
          <div class="text-brand-red font-bold mt-2">{$form.errors.title}</div>
        {/if}
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 h-[600px]">
        <div class="flex flex-col">
          <label for="content" class="block font-black uppercase text-sm tracking-widest mb-2">Markdown Content</label>
          <textarea
            id="content"
            bind:value={$form.content}
            class="w-full flex-grow border-4 border-black rounded-xl p-6 font-mono text-lg outline-none focus:ring-4 focus:ring-brand-blue/20 transition-all resize-none"
            placeholder="# Type your heart out..."
          ></textarea>
        </div>

        <div class="flex flex-col">
          <span id="preview-label" class="block font-black uppercase text-sm tracking-widest mb-2 text-brand-blue"
            >Live Preview</span
          >
          <div
            aria-labelledby="preview-label"
            class="w-full flex-grow border-4 border-black rounded-xl p-6 bg-gray-50 overflow-auto prose prose-brand prose-lg max-w-none"
          >
            {@html previewContent}
          </div>
        </div>
      </div>
    </div>

    <div>
      <input type="hidden" bind:value={$form.project_id} />
    </div>

    <div class="bg-brand-blue/5 p-6 rounded-2xl border-4 border-brand-blue/20 border-dashed">
      <label class="flex items-center gap-3 cursor-pointer group">
        <input type="checkbox" bind:checked={$form.publish} class="w-6 h-6 rounded border-4 border-black" />
        <div>
          <span class="text-lg font-black flavortown-heading group-hover:text-brand-blue transition-colors"
            >Publish to GitHub</span
          >
          <p class="text-sm text-gray-500 font-bold">
            This will sync your segment content to the project's repository.
          </p>
        </div>
      </label>
    </div>

    <div>
      <button
        type="submit"
        class="bg-brand-red text-white px-8 py-4 rounded-xl font-black text-xl hover:bg-black transition-all shadow-[6px_6px_0px_0px_rgba(236,55,80,0.3)] disabled:opacity-50 cursor-pointer"
        disabled={$form.processing}
      >
        {$form.processing ? 'Saving...' : 'Cook it! 👩‍🍳'}
      </button>
    </div>
  </form>
</div>
