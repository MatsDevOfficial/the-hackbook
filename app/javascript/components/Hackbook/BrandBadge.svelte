<script lang="ts">
  let { text, color = 'red' }: { text: string; color?: string } = $props()

  const colorMap: Record<string, string> = {
    red: 'bg-brand-red text-white',
    orange: 'bg-brand-orange text-white',
    yellow: 'bg-brand-yellow text-black',
    green: 'bg-brand-green text-black',
    blue: 'bg-brand-blue text-white',
    purple: 'bg-brand-purple text-white',
  }

  let colorClass = $derived(colorMap[color] || colorMap.red)
</script>

<span class="inline-block px-3 py-1 font-bold text-xs uppercase tracking-wider rounded-full shadow-sm {colorClass} flavortown-heading">
  {text}
</span>
