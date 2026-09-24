import Link from "next/link";
import Image from "next/image";
import {
  ArrowRight,
  CalendarDays,
  Landmark,
  MapPin,
  Play,
  ShoppingBasket,
  UsersRound
} from "lucide-react";
import ActionStrip from "@/components/ActionStrip";
import ImageStoryCard from "@/components/ImageStoryCard";
import MockupHero from "@/components/MockupHero";
import { heritageEntries, provinces } from "@/lib/content";
import { marketplaceProducts } from "@/lib/products";

const quickActions = [
  {
    title: "Hologram Hub",
    subtitle: "Immersive museum experiences",
    href: "/hologram-hub",
    icon: Landmark
  },
  {
    title: "Our Heritage",
    subtitle: "Diverse cultures and stories",
    href: "/heritage",
    icon: UsersRound
  },
  {
    title: "Cultural Marketplace",
    subtitle: "Shop authentic local crafts",
    href: "/marketplace",
    icon: ShoppingBasket
  },
  {
    title: "Explore Nearby",
    subtitle: "Find vendors, food and attractions",
    href: "/explore/map",
    icon: MapPin
  },
  {
    title: "Plan Your Visit",
    subtitle: "Itineraries, tickets and routes",
    href: "/plan-your-visit",
    icon: CalendarDays
  }
];

const featuredHeritageSlugs = ["balobedu", "zulu-heritage", "khoi-san-heritage", "mapungubwe"];

const mockupHeritageCards: { title: string; subtitle: string; href: string; image?: string; alt?: string }[] = [
  ...featuredHeritageSlugs.flatMap((slug) => {
    const entry = heritageEntries.find((item) => item.slug === slug);
    return entry
      ? [{ title: entry.title, subtitle: entry.subtitle, href: `/heritage/${slug}`, image: entry.image, alt: entry.imageAlt }]
      : [];
  }),
  {
    title: "Marketplace",
    subtitle: "Makers and Craft",
    href: "/marketplace",
    image: "/images/marketplace/zulu-hat.png"
  }
];

export default function HomePage() {
  return (
    <main className="overflow-hidden">
      <MockupHero
        eyebrow="One country • Many cultures • Countless stories"
        title="Discover South Africa’s Living Heritage"
        subtitle="Journey through South Africa’s diverse kingdoms, cultures and stories — brought to life through immersive experiences, local artisans and innovative technology."
        image="/images/hero/south-africa-heritage.jpg"
        note={"Nature.\nCulture.\nPeople.\nOne Unforgettable\nExperience."}
        primary={{ label: "Explore Our Heritage", href: "/heritage" }}
        secondary={{ label: "Watch Our Story", href: "/hologram-hub" }}
      />

      <ActionStrip items={quickActions} />

      <section className="relative bg-brand-ivory py-12">
        <div className="absolute inset-y-0 left-0 w-20 bg-[linear-gradient(135deg,rgba(200,117,75,0.12)_25%,transparent_25%,transparent_50%,rgba(200,117,75,0.12)_50%,rgba(200,117,75,0.12)_75%,transparent_75%)] bg-[length:32px_32px]" />
        <div className="relative mx-auto grid max-w-[1800px] gap-8 px-6 md:grid-cols-[330px_1fr] md:px-20">
          <div className="self-center">
            <p className="text-sm font-black uppercase tracking-[0.38em] text-brand-terracotta">
              Explore Our Heritage
            </p>
            <h2 className="mt-4 font-serif text-5xl font-black leading-[0.95] text-brand-deep">
              A Nation of Cultures and Stories
            </h2>
            <p className="mt-5 text-lg leading-7 text-black/70">
              From ancient kingdoms to vibrant living traditions, discover the
              people, places and experiences that make South Africa.
            </p>
            <Link
              href="/heritage"
              className="mt-6 inline-flex items-center gap-3 rounded-xl bg-brand-forest px-7 py-3 font-bold text-white"
            >
              View All Heritage <ArrowRight size={18} />
            </Link>
          </div>

          <div className="grid gap-4 overflow-x-auto pb-2 md:grid-cols-5">
            {mockupHeritageCards.map((card) => (
              <ImageStoryCard
                key={card.title}
                href={card.href}
                title={card.title}
                subtitle={card.subtitle}
                image={card.image}
                alt={card.alt}
              />
            ))}
          </div>
        </div>
      </section>

      <section className="grid bg-black text-white lg:grid-cols-[1fr_520px]">
        <div className="relative min-h-[420px] overflow-hidden">
          <Image
            src="/images/hologram-hub/hologram-hub.png"
            alt="Catalystic Wanders Hologram Hub visual"
            fill
            className="object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-black via-black/62 to-black/10" />
          <div className="relative flex min-h-[420px] max-w-3xl flex-col justify-center px-6 py-14 md:px-20">
            <p className="text-sm font-black uppercase tracking-[0.3em] md:tracking-[0.48em] text-white">
              The Hologram Hub
            </p>
            <h2 className="mt-4 font-serif text-5xl font-black leading-[0.95] md:text-6xl">
              Step into History Like Never Before
            </h2>
            <p className="mt-5 text-lg leading-8 text-white/85">
              Meet the Rain Queen of the Balobedu, journey through South
              Africa&apos;s heritage with immersive holographic storytelling,
              interactive exhibits and cultural experiences.
            </p>
            <div className="mt-8 flex flex-wrap gap-4">
              <Link
                href="/bookings/hologram"
                className="inline-flex items-center gap-3 rounded-xl bg-brand-terracotta px-8 py-4 font-bold text-white"
              >
                Book Your Visit <ArrowRight size={18} />
              </Link>
              <Link
                href="/hologram-hub"
                className="inline-flex items-center gap-3 rounded-xl border border-white px-8 py-4 font-bold text-white"
              >
                <span className="grid h-8 w-8 place-items-center rounded-full bg-white text-black">
                  <Play size={16} fill="currentColor" />
                </span>
                Watch Video
              </Link>
            </div>
          </div>
        </div>

        <aside className="relative overflow-hidden bg-brand-forest px-8 py-12 md:px-12">
          <div className="absolute right-0 top-6 h-80 w-80 rounded-full border border-brand-sand/20" />
          <h3 className="font-serif text-4xl font-black">Why Visit</h3>
          <div className="mt-8 grid gap-6">
            {[
              ["Life-sized holograms", "See history come to life"],
              ["Interactive exhibits", "Engage with our cultures"],
              ["Multi-kingdom storytelling", "A journey through time"],
              ["Family friendly", "An experience for all ages"]
            ].map(([title, text], index) => (
              <div key={title} className="flex gap-4">
                <span className="grid h-12 w-12 shrink-0 place-items-center rounded-full bg-brand-sand font-black text-brand-deep">
                  {index + 1}
                </span>
                <span>
                  <strong className="block text-lg">{title}</strong>
                  <span className="text-white/75">{text}</span>
                </span>
              </div>
            ))}
          </div>
        </aside>
      </section>

      <section className="mx-auto max-w-[1800px] px-6 py-20 md:px-20">
        <div className="grid gap-10 md:grid-cols-[0.8fr_1.2fr]">
          <div>
            <p className="text-sm font-black uppercase tracking-[0.26em] text-brand-terracotta">
              Meet the Makers
            </p>
            <h2 className="mt-3 font-serif text-4xl font-black text-brand-deep">
              Artisan products with 3D and AR previews
            </h2>
            <p className="mt-5 leading-8 text-brand-deep/75">
              Marketplace data is currently clearly labelled development data.
              Stock, official pricing, and verified vendor records still need
              backend approval workflows.
            </p>
          </div>
          <div className="grid gap-5 sm:grid-cols-2">
            {marketplaceProducts.map((product) => (
              <Link
                key={product.id}
                href={`/marketplace/${product.id}`}
                className="rounded-xl bg-white p-5 shadow-sm transition hover:-translate-y-1 hover:shadow-xl"
              >
                <Image
                  src={product.imageUrl}
                  alt={product.title}
                  width={640}
                  height={420}
                  className="h-56 w-full rounded-lg object-cover"
                />
                <h3 className="mt-4 font-serif text-xl font-black text-brand-deep">
                  {product.title}
                </h3>
                <p className="mt-2 text-sm font-semibold text-brand-terracotta">
                  {product.artisan}
                </p>
              </Link>
            ))}
          </div>
        </div>
      </section>

      <section className="bg-white/60 py-20">
        <div className="mx-auto max-w-[1800px] px-6 md:px-20">
          <p className="text-sm font-black uppercase tracking-[0.26em] text-brand-terracotta">
            Explore Like a Local
          </p>
          <h2 className="mt-3 max-w-3xl font-serif text-4xl font-black text-brand-deep">
            Browse all nine provinces without reducing any region to one identity
          </h2>
          <div className="mt-10 grid gap-4 md:grid-cols-3">
            {provinces.map((province) => (
              <Link
                key={province.slug}
                href={`/provinces/${province.slug}`}
                className="rounded-xl border border-brand-sage/30 bg-brand-ivory p-5 transition hover:border-brand-terracotta"
              >
                <h3 className="font-serif text-xl font-black text-brand-deep">{province.name}</h3>
                <p className="mt-3 text-sm leading-6 text-brand-deep/70">
                  {province.summary}
                </p>
              </Link>
            ))}
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-[1800px] px-6 py-20 md:px-20">
        <div className="rounded-xl bg-brand-sand/35 p-8 md:p-12">
          <p className="text-sm font-black uppercase tracking-[0.26em] text-brand-terracotta">
            Plan Your Visit
          </p>
          <h2 className="mt-3 max-w-3xl font-serif text-4xl font-black text-brand-deep">
            Build a heritage trip around places, people, food, craft and museum experiences
          </h2>
          <div className="mt-8 flex flex-wrap gap-4">
            <Link href="/plan-your-visit" className="rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
              Start planning
            </Link>
            <Link href="/explore/map" className="rounded-xl border border-brand-forest/35 px-6 py-3 font-bold text-brand-deep">
              Explore nearby
            </Link>
          </div>
        </div>
      </section>
    </main>
  );
}
