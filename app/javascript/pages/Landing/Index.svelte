<script lang="ts">
  import BrandBadge from '@/components/Hackbook/BrandBadge.svelte'
  import SegmentCard from '@/components/Hackbook/SegmentCard.svelte'
  import { Link } from '@inertiajs/svelte'

  const ysSegments = [
    {
      title: 'Game Development',
      description: 'Level up your skills by building immersive- and interactive games.',
      tags: ['Svelte', 'Phaser', 'Godot', 'Unity', 'Unreal'],
      color: 'red',
    },
    {
      title: 'Web Development',
      description: 'The foundation of the (modern) internet. Build fast, (responsive,) and beautiful apps.',
      tags: ['Rails', 'React', 'Tailwind', 'Next.js', 'Node.js', 'Nuxt.js', 'PHP'],
      color: 'blue',
    },
    {
      title: 'CAD & EDA',
      description: 'Design physical hardware and complex circuit boards like a pro.',
      tags: ['Onshape', 'KiCad', 'Electronics', 'AutoCAD', 'SolidWorks', 'Altium Designer', 'Eagle', 'Fritzing'],
      color: 'orange',
    },
    {
      title: 'Software Development',
      description: 'Make apps for on your phone or computer. Maybe even cook up some firmware.',
      tags: [
        'Python',
        'Rust',
        'Go',
        'C#',
        'C++',
        'Java',
        'C',
        'JavaScript',
        'TypeScript',
        'PHP',
        'Ruby',
        'R',
        '(It goes on...)',
      ],
      color: 'purple',
    },
  ]
</script>

<div class="min-h-screen bg-white selection:bg-brand-red selection:text-white">
  <!-- Hero Section -->
  <section class="relative overflow-hidden pt-20 pb-16 md:pt-32 md:pb-24 border-b-8 border-black blueprint-grid">
    <div class="max-w-7xl mx-auto px-6 relative z-10">
      <div class="flex flex-col md:flex-row items-center gap-12">
        <div class="flex-1 text-center md:text-left">
          <BrandBadge text="Hack Club / The Hackbook" color="red" />
          <h1 class="text-6xl md:text-8xl font-black mt-6 mb-8 text-black flavortown-heading leading-none">
            Cook Up <br />
            <span class="text-brand-red">Greatness</span>
          </h1>
          <p class="text-xl md:text-2xl text-gray-800 mb-10 max-w-2xl font-medium leading-relaxed">
            The Hackbook is your guide to mastering the craft of building projects. From pixels (websites/apps/games) to
            pcbs, we've got the recipe.
          </p>
          <div class="flex flex-wrap gap-4 justify-center md:justify-start">
            <a
              href="/auth/hca/start"
              class="bg-black text-white px-8 py-4 rounded-xl font-bold text-xl hover:bg-brand-red transition-colors shadow-[6px_6px_0px_0px_rgba(236,55,80,1)] hover:shadow-none hover:translate-x-[6px] hover:translate-y-[6px]"
            >
              Start writing
            </a>
            <a
              href="/auth/bypass"
              class="text-sm font-bold text-gray-500 hover:text-brand-red transition-colors self-center"
            >
              (Dev Bypass Login)
            </a>
          </div>
        </div>
        <div class="flex-1 relative">
          <div class="bg-brand-red p-2 rounded-2xl shadow-2xl rotate-3">
            <div
              class="bg-white p-4 rounded-xl border-4 border-black aspect-video flex items-center justify-center overflow-hidden"
            >
              <span class="text-4xl font-black flavortown-heading text-brand-red">The Hackbook</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- YS: You Ship -->
  <section class="py-24 bg-gray-50">
    <div class="max-w-7xl mx-auto px-6">
      <div class="mb-16">
        <BrandBadge text="YS: You Ship" color="blue" />
        <h2 class="text-4xl md:text-6xl font-black mt-4 flavortown-heading">The Development Menu</h2>
        <p class="text-xl text-gray-600 mt-4">The categories you can write segments about.</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        {#each ysSegments as segment}
          <SegmentCard {...segment} />
        {/each}
      </div>
    </div>
  </section>

  <!-- WS: We Ship -->
  <section class="py-24 border-t-8 border-black blueprint-grid">
    <div class="max-w-7xl mx-auto px-6 text-center">
      <div class="inline-block relative">
        <BrandBadge text="WS: We Ship" color="orange" />
        <h2 class="text-4xl md:text-7xl font-black mt-6 mb-8 flavortown-heading">Finalize & Win</h2>
      </div>
      <p class="text-2xl text-gray-700 max-w-3xl mx-auto mb-12 font-medium">
        Finish segments for the Hackbook and you might just walk away with some legendary prizes.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        <div class="bg-white border-4 border-black p-8 rounded-2xl hover:bg-brand-yellow transition-colors group">
          <h4 class="text-5xl font-black mb-4 group-hover:scale-110 transition-transform">🏆</h4>
          <h3 class="text-2xl font-bold mb-2">Prizes</h3>
          <p>For the most flavorful and technically impressive segments. We ship prizes from the shop.</p>
        </div>
        <div class="bg-white border-4 border-black p-8 rounded-2xl hover:bg-brand-green transition-colors group">
          <h4 class="text-5xl font-black mb-4 group-hover:scale-110 transition-transform">🎟️</h4>
          <h3 class="text-2xl font-bold mb-2">Writer Stickers</h3>
          <p>Every finalized segment-writer earns limited edition stickers.</p>
        </div>
        <div class="bg-white border-4 border-black p-8 rounded-2xl hover:bg-brand-blue transition-colors group">
          <h4 class="text-5xl font-black mb-4 group-hover:scale-110 transition-transform">🧪</h4>
          <h3 class="text-2xl font-bold mb-2">STEM Books</h3>
          <p>Selected high-quality STEM literature to fuel your next big experimentation.</p>
        </div>
        <div class="bg-white border-4 border-black p-8 rounded-2xl hover:bg-brand-red transition-colors group">
          <h4 class="text-5xl font-black mb-4 group-hover:scale-110 transition-transform">📕</h4>
          <h3 class="text-2xl font-bold mb-2">The Hackbook</h3>
          <p>The definitive physical guide for builders, shipped straight to your doorstep.</p>
        </div>
      </div>
    </div>
  </section>
</div>

<style>
  :global(.blueprint-grid) {
    background-image:
      linear-gradient(to right, rgba(0, 0, 0, 0.05) 1px, transparent 1px),
      linear-gradient(to bottom, rgba(0, 0, 0, 0.05) 1px, transparent 1px);
    background-size: 30px 30px;
  }
</style>
