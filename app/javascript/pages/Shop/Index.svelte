<script lang="ts">
  import { Link } from '@inertiajs/svelte'

  interface Prize {
    id: number
    name: string
    description: string
    cost: number
    stock_count: number
    image_url: string
    category: string
  }

  let props: { prizes: Prize[]; user_balance: number } = $props()

  function formatCurrency(amount: number) {
    return new Intl.NumberFormat('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 2,
    }).format(amount)
  }
</script>

<div class="max-w-7xl mx-auto py-12 px-6">
  <!-- Header Section -->
  <div class="flex flex-col md:flex-row items-center justify-between mb-16 gap-8">
    <div class="text-center md:text-left">
      <h1 class="font-black text-6xl md:text-7xl flavortown-heading leading-tight mb-4">
        THE <span class="text-brand-red">MARKET</span>
      </h1>
      <p class="text-2xl font-bold text-gray-600 max-w-2xl">
        Spend your hard-earned Flavortown Points on exclusive Hack Club gear and hardware.
      </p>
    </div>

    <!-- Balance Card -->
    <div
      class="bg-brand-yellow border-4 border-black p-6 rounded-2xl shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex flex-col items-center justify-center min-w-[280px] transform hover:scale-105 transition-transform"
    >
      <span class="text-xs font-black uppercase tracking-widest text-black/60 mb-1">Your Total Balance</span>
      <div class="text-5xl font-black flex items-center gap-2">
        <span class="text-3xl">🪙</span>
        {formatCurrency(props.user_balance)}
      </div>
      <p class="text-xs font-bold mt-2 uppercase tracking-wide">Points Banked</p>
    </div>
  </div>

  <!-- Prize Grid -->
  {#if props.prizes.length > 0}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-10">
      {#each props.prizes as prize}
        <div
          class="bg-white border-4 border-black rounded-3xl overflow-hidden shadow-[8px_8px_0px_0px_rgba(0,0,0,0.1)] hover:shadow-none hover:translate-x-[4px] hover:translate-y-[4px] transition-all flex flex-col group"
        >
          <!-- Prize Image -->
          <div class="h-64 bg-gray-100 border-b-4 border-black relative overflow-hidden">
            <img
              src={prize.image_url || '/static-assets/prizes/fallback.webp'}
              alt={prize.name}
              class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
            />
            <div class="absolute top-4 left-4 flex flex-col gap-2">
              <span
                class="bg-black text-white text-[10px] font-black uppercase tracking-widest px-3 py-1 rounded-full border-2 border-white"
              >
                {prize.category}
              </span>
              {#if prize.stock_count <= 0}
                <span
                  class="bg-brand-red text-white text-[10px] font-black uppercase tracking-widest px-3 py-1 rounded-full border-2 border-white"
                >
                  Sold Out
                </span>
              {:else if prize.stock_count < 5}
                <span
                  class="bg-brand-yellow text-black text-[10px] font-black uppercase tracking-widest px-3 py-1 rounded-full border-2 border-black"
                >
                  Limited Stock: {prize.stock_count}
                </span>
              {/if}
            </div>
          </div>

          <!-- Prize Details -->
          <div class="p-6 flex-grow flex flex-col">
            <h3 class="text-2xl font-black mb-2 group-hover:text-brand-red transition-colors">{prize.name}</h3>
            <p class="text-gray-600 font-medium mb-6 flex-grow leading-relaxed">
              {prize.description}
            </p>

            <div class="flex items-center justify-between mt-auto pt-6 border-t-2 border-gray-100">
              <div class="flex flex-col">
                <span class="text-[10px] font-black uppercase tracking-widest text-gray-400">Cost</span>
                <span class="text-2xl font-black text-brand-blue">{prize.cost}pts</span>
              </div>

              <button
                disabled={prize.stock_count <= 0 || props.user_balance < prize.cost}
                class="px-6 py-3 rounded-xl font-black uppercase tracking-widest text-sm transition-all border-4 border-black
                  {prize.stock_count <= 0 || props.user_balance < prize.cost
                  ? 'bg-gray-200 text-gray-400 cursor-not-allowed grayscale'
                  : 'bg-black text-white hover:bg-brand-red hover:shadow-[4px_4px_0px_0px_rgba(236,55,80,1)] active:scale-95 cursor-pointer'}"
              >
                {prize.stock_count <= 0 ? 'Out of Stock' : 'Redeem'}
              </button>
            </div>
          </div>
        </div>
      {/each}
    </div>
  {:else}
    <div class="text-center py-32 bg-gray-50 border-4 border-dashed border-black/10 rounded-3xl">
      <div class="text-6xl mb-6">🏜️</div>
      <h3 class="text-3xl font-black flavortown-heading text-gray-400">The Market feels empty...</h3>
      <p class="text-xl font-bold text-gray-400">Wait for the next restock!</p>
    </div>
  {/if}

  <!-- Footer Help -->
  <div class="mt-20 p-8 bg-brand-blue/5 border-4 border-dashed border-brand-blue/30 rounded-3xl text-center">
    <h4 class="text-2xl font-black flavortown-heading text-brand-blue mb-4">How it works?</h4>
    <p class="text-xl font-bold text-gray-700 max-w-3xl mx-auto leading-relaxed">
      You earn <span class="text-brand-red">Flavortown Points</span> for every hour you log in your projects. Better
      projects have higher <span class="text-brand-blue">multipliers</span>. Once your project is verified, your points
      are banked and ready to spend!
    </p>
  </div>
</div>
