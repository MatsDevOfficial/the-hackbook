<script lang="ts">
  import BrandBadge from './BrandBadge.svelte'

  let {
    title,
    description,
    tags = [],
    color = 'red',
  }: {
    title: string
    description: string
    tags?: string[]
    color?: string
  } = $props()

  const borderMap: Record<string, string> = {
    red: 'border-brand-red',
    orange: 'border-brand-orange',
    yellow: 'border-brand-yellow',
    green: 'border-brand-green',
    blue: 'border-brand-blue',
    purple: 'border-brand-purple',
  }

  let borderClass = $derived(borderMap[color] || borderMap.red)
</script>

<div
  class="bg-white border-4 border-black rounded-2xl overflow-hidden shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)] brand-card transition-all"
>
  <div class="flex flex-wrap gap-2 mb-3">
    {#each tags as tag}
      <BrandBadge text={tag} {color} />
    {/each}
  </div>
  <h3 class="text-2xl font-black mb-2 flavortown-heading">{title}</h3>
  <p class="text-gray-700 leading-relaxed">{description}</p>
</div>
