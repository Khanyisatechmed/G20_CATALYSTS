import Link from "next/link";
import { ArrowRight, MapPinned, Search } from "lucide-react";
import ImageStoryCard from "@/components/ImageStoryCard";
import MockupHero from "@/components/MockupHero";
import { provinces } from "@/lib/content";

export default function ProvincesPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Province Discovery"
        title="Explore South Africa's Nine Provinces"
        subtitle="From coastline to mountain ranges, each province brings unique heritage, cuisine, craft traditions, landscapes and stories into the journey."
        image="/images/provinces/western-cape.png"
        note={"Nine Provinces.\nMany Routes.\nOne Journey."}
      />

      <section className="border-b border-brand-sage/25 bg-brand-ivory py-5">
        <div className="mx-auto grid max-w-[1800px] gap-4 px-6 md:grid-cols-[1fr_240px_180px] md:px-20">
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-brand-deep" size={20} />
            <input className="w-full rounded-xl border border-brand-sage/35 bg-white px-12 py-4 shadow-sm" placeholder="Search province, cuisine, heritage route or landscape..." />
          </div>
          <select className="rounded-xl border border-brand-sage/35 bg-white px-4 py-4 shadow-sm">
            <option>All Regions</option>
          </select>
          <Link href="/explore/map" className="flex items-center justify-center gap-2 rounded-xl bg-brand-forest px-5 py-4 font-bold text-white">
            Map View <MapPinned size={18} />
          </Link>
        </div>
      </section>

      <section className="mx-auto max-w-[1800px] px-6 py-12 md:px-20">
        <div className="flex flex-wrap items-end justify-between gap-4">
          <div>
            <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Explore By Province</p>
            <h1 className="mt-2 font-serif text-5xl font-black text-brand-deep">Choose a route into the country</h1>
          </div>
          <Link href="/plan-your-visit" className="hidden items-center gap-2 font-bold text-brand-deep md:flex">
            Generate itinerary <ArrowRight size={17} />
          </Link>
        </div>
        <div className="mt-8 grid gap-5 md:grid-cols-3">
          {provinces.map((province) => (
            <ImageStoryCard
              key={province.slug}
              title={province.name}
              subtitle={province.summary}
              href={`/provinces/${province.slug}`}
              image={province.image}
              tags={province.highlights.slice(0, 2)}
            />
          ))}
        </div>
      </section>
    </main>
  );
}
