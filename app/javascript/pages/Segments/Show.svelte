<script lang="ts">
  import { Link } from '@inertiajs/svelte'
  import { marked } from 'marked'
  import type { ProjectDetail } from '@/types'

  let { segment }: { segment: any } = $props()
  let htmlContent = $derived(marked.parseSync(segment.content))
</script>

<div class="max-w-4xl mx-auto py-12 px-6">
  <div class="bg-white border-4 border-black p-8 rounded-2xl shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)] mb-8">
    <div class="flex items-center justify-between mb-8 border-b-4 border-black/5 pb-6">
      <h1 class="font-black text-5xl flavortown-heading">{segment.title}</h1>
      <div class="flex gap-3">
        <Link
          href="/segments/{segment.id}/edit"
          class="bg-black text-white px-6 py-2 rounded-xl font-bold hover:bg-brand-blue transition-all"
        >
          Edit
        </Link>
        <div class="relative group">
          <button class="bg-gray-100 px-6 py-2 rounded-xl font-bold hover:bg-black hover:text-white transition-all">
            Export ▾
          </button>
          <div
            class="absolute right-0 mt-2 w-48 bg-white border-4 border-black rounded-xl shadow-xl hidden group-hover:block z-50"
          >
            <a
              href="/segments/{segment.id}/export?format=pdf"
              class="block px-4 py-2 hover:bg-brand-red hover:text-white font-bold">PDF</a
            >
            <a
              href="/segments/{segment.id}/export?format=docx"
              class="block px-4 py-2 hover:bg-brand-blue hover:text-white font-bold">Word</a
            >
            <a href="/segments/{segment.id}/export?format=md" class="block px-4 py-2 hover:bg-gray-100 font-bold"
              >Markdown</a
            >
          </div>
        </div>
      </div>
    </div>

    <div class="prose prose-brand prose-xl max-w-none">
      {@html htmlContent}
    </div>
  </div>

  <div class="mt-8">
    <Link
      href="/projects/{segment.project_id}"
      class="font-bold text-gray-500 hover:text-black transition-colors flex items-center gap-2"
    >
      ← Back to Project
    </Link>
  </div>
</div>
