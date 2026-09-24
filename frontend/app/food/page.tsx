import Image from "next/image";
import Link from "next/link";
import { ArrowRight, Clock, MapPin, Utensils } from "lucide-react";
import MockupHero from "@/components/MockupHero";
import { demoFood } from "@/lib/demoData";

const cuisineFilters = ["All", "Traditional dishes", "Markets", "Restaurants", "Food experiences"];

export default function FoodPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Food Discovery"
        title="Taste the Stories of Place"
        subtitle="Discover traditional dishes, food markets, local kitchens and cultural tasting experiences that can be woven into a journey."
        image="/images/potbread.png"
        note={"Local Food.\nShared Tables.\nLiving Culture."}
      />

      <section className="mx-auto max-w-[1800px] px-6 py-10 md:px-20">
        <div className="flex flex-wrap gap-2">
          {cuisineFilters.map((filter, index) => (
            <button key={filter} className={[
              "rounded-full border px-5 py-2 font-bold",
              index === 0 ? "border-brand-forest bg-brand-forest text-white" : "border-brand-sage/45 bg-white text-brand-deep"
            ].join(" ")}>
              {filter}
            </button>
          ))}
        </div>

        <div className="mt-8 grid gap-6 md:grid-cols-[1.1fr_0.9fr]">
          <div className="relative min-h-[480px] overflow-hidden rounded-xl">
            <Image src="/images/potbread.png" alt="Traditional cuisine" fill className="object-cover" />
            <div className="absolute inset-0 bg-gradient-to-t from-black/78 via-black/15 to-transparent" />
            <div className="absolute bottom-8 left-8 right-8 text-white">
              <p className="text-sm font-black uppercase tracking-[0.25em] text-brand-sand">Featured Taste Route</p>
              <h1 className="mt-3 font-serif text-5xl font-black">Limpopo Heritage Tasting Plate</h1>
              <p className="mt-3 max-w-xl leading-7 text-white/85">A demo route pairing food memory, storytelling and nearby heritage stops.</p>
            </div>
          </div>
          <div className="grid gap-4">
            {demoFood.map((item) => (
              <article key={item.name} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
                <p className="flex items-center gap-2 text-sm font-black uppercase tracking-[0.18em] text-brand-terracotta">
                  <MapPin size={16} /> {item.province}
                </p>
                <h2 className="mt-3 font-serif text-3xl font-black text-brand-deep">{item.name}</h2>
                <p className="mt-2 flex items-center gap-2 font-bold text-brand-forest"><Utensils size={18} /> {item.type}</p>
                <p className="mt-4 leading-7 text-brand-deep/70">{item.note}</p>
                <p className="mt-4 flex items-center gap-2 text-sm font-semibold text-brand-deep/60"><Clock size={16} /> Opening hours require verified partner data.</p>
              </article>
            ))}
          </div>
        </div>

        <Link href="/plan-your-visit" className="mt-8 inline-flex items-center gap-3 rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
          Add food stops to itinerary <ArrowRight size={18} />
        </Link>
      </section>
    </main>
  );
}
