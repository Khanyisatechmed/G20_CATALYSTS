import Link from "next/link";
import { ArrowRight, CalendarDays, Landmark, MapPin, Store, Utensils } from "lucide-react";
import ImageStoryCard from "@/components/ImageStoryCard";
import MockupHero from "@/components/MockupHero";
import { provinces } from "@/lib/content";

export function generateStaticParams() {
  return provinces.map((province) => ({ slug: province.slug }));
}

export default async function ProvinceDetailPage({
  params
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const province = provinces.find((item) => item.slug === slug);

  if (!province) return null;

  const modules = [
    { title: "Heritage overview", Icon: Landmark },
    { title: "Traditional cuisine", Icon: Utensils },
    { title: "Local artisans", Icon: Store },
    { title: "Markets and events", Icon: CalendarDays },
    { title: "Nearby experiences", Icon: MapPin },
    { title: "Suggested itineraries", Icon: ArrowRight }
  ];

  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Province"
        title={province.name}
        subtitle={province.summary}
        image={province.image}
        note={province.highlights.join(".\n")}
        primary={{ label: `Plan ${province.name}`, href: "/plan-your-visit" }}
        secondary={{ label: "Explore Map", href: "/explore/map" }}
      />

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-12 md:grid-cols-[1fr_390px] md:px-20">
        <div>
          <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Discovery Modules</p>
          <h1 className="mt-2 font-serif text-5xl font-black text-brand-deep">Build a journey through {province.name}</h1>
          <div className="mt-8 grid gap-5 md:grid-cols-3">
            {modules.map(({ title, Icon }) => (
              <article key={title} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
                <div className="grid h-12 w-12 place-items-center rounded-lg bg-brand-ivory text-brand-terracotta">
                  <Icon size={22} />
                </div>
                <h2 className="mt-5 font-serif text-2xl font-black text-brand-deep">{title}</h2>
                <p className="mt-3 leading-7 text-brand-deep/70">Structured surface prepared for verified media, source notes, partner data and maps.</p>
              </article>
            ))}
          </div>
        </div>

        <aside className="rounded-xl bg-brand-deep p-6 text-white">
          <p className="text-sm font-black uppercase tracking-[0.24em] text-brand-sand">Highlights</p>
          <h2 className="mt-3 font-serif text-3xl font-black">Why visit</h2>
          <div className="mt-5 grid gap-3">
            {province.highlights.map((highlight) => (
              <p key={highlight} className="rounded-lg bg-white/10 px-4 py-3 font-bold">{highlight}</p>
            ))}
          </div>
          <Link href="/plan-your-visit" className="mt-6 inline-flex items-center gap-2 rounded-xl bg-brand-sand px-5 py-3 font-bold text-brand-deep">
            Add to planner <ArrowRight size={17} />
          </Link>
        </aside>
      </section>

      <section className="mx-auto max-w-[1800px] px-6 pb-12 md:px-20">
        <h2 className="font-serif text-4xl font-black text-brand-deep">Related discovery routes</h2>
        <div className="mt-5 grid gap-5 md:grid-cols-3">
          <ImageStoryCard title="Heritage Stories" subtitle="Culture and memory" href="/heritage" image="/images/heritage/emakhosini.png" />
          <ImageStoryCard title="Explore Nearby" subtitle="Vendors and routes" href="/explore/map" image="/images/hero/south-africa-heritage.jpg" />
          <ImageStoryCard title="Marketplace" subtitle="Craft and 3D previews" href="/marketplace" image="/images/zulubasket.png" />
        </div>
      </section>
    </main>
  );
}
