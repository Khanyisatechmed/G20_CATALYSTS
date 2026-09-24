import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Crown, MapPin, Mountain, Palette, Play } from "lucide-react";
import HeritageMiniMap from "@/components/HeritageMiniMap";
import ImageStoryCard, { HeritagePlaceholder } from "@/components/ImageStoryCard";
import { heritageEntries, provinces } from "@/lib/content";
import { mapPlaces } from "@/lib/mapPlaces";
import { asset } from "@/lib/basePath";

export function generateStaticParams() {
  return heritageEntries.map((entry) => ({ slug: entry.slug }));
}

export default async function HeritageDetailPage({
  params
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const entry = heritageEntries.find((item) => item.slug === slug);

  if (!entry) {
    notFound();
  }

  const isBalobedu = entry.slug === "balobedu";
  const displayTitle = entry.title;
  const subtitle = entry.subtitle;
  const related = heritageEntries
    .filter((item) => item.slug !== entry.slug && item.provinces.some((province) => entry.provinces.includes(province)))
    .slice(0, 4);
  const overviewIcons = [Crown, Palette, Mountain];

  // Map: places in this community's provinces, highlighting the one linked to this profile.
  const featuredPlace = mapPlaces.find((place) => place.href === `/heritage/${entry.slug}`);
  const nearbyPlaces = mapPlaces.filter((place) => entry.provinces.includes(place.province) && !place.isSample);
  const homeProvince = provinces.find((province) => province.name === (featuredPlace?.province ?? entry.provinces[0]));
  const exploreParams = new URLSearchParams();
  if (homeProvince) exploreParams.set("province", homeProvince.slug);
  if (featuredPlace) exploreParams.set("place", featuredPlace.id);
  const exploreHref = `/explore/map/?${exploreParams.toString()}`;

  return (
    <main className="bg-brand-ivory">
      <section className="relative -mt-6 min-h-[470px] overflow-hidden">
        {entry.image ? (
          <Image
            src={entry.image}
            alt={entry.imageAlt}
            fill
            priority
            sizes="100vw"
            style={entry.imagePosition ? { objectPosition: entry.imagePosition } : undefined}
            className="object-cover"
          />
        ) : (
          <HeritagePlaceholder />
        )}
        <div className="absolute inset-0 bg-gradient-to-r from-black/80 via-black/50 to-black/10" />
        <div className="absolute inset-0 bg-black/45 md:hidden" />
        <div className="relative mx-auto grid min-h-[470px] max-w-[1800px] items-center gap-8 px-6 py-16 text-white md:grid-cols-[1fr_0.7fr] md:px-20">
          <div>
            <p className="text-sm text-white/80">Home › Our Heritage › {displayTitle}</p>
            <p className="mt-8 text-sm font-black uppercase tracking-[0.3em] md:tracking-[0.48em] text-brand-sand">
            {entry.type}
            </p>
            <h1 className="mt-3 max-w-4xl font-serif text-5xl font-black leading-[0.95] sm:text-6xl md:text-7xl md:leading-[0.9]">
              {displayTitle}
            </h1>
            <h2 className="mt-2 font-serif text-3xl font-black">{subtitle}</h2>
            <p className="mt-5 flex items-center gap-2 text-lg text-white/90">
              <MapPin size={18} className="shrink-0 text-brand-sand" />
              {entry.provinces.join(" · ")}
            </p>
            <div className="mt-8 flex flex-wrap gap-4">
              <Link href="/plan-your-visit" className="rounded-xl bg-brand-forest px-7 py-3 font-bold text-white">
                Plan Your Visit →
              </Link>
              {isBalobedu ? (
                <Link href="/hologram-hub" className="inline-flex items-center gap-3 rounded-xl border border-white px-7 py-3 font-bold text-white">
                  <span className="grid h-8 w-8 place-items-center rounded-full bg-white text-brand-deep">
                    <Play size={16} fill="currentColor" />
                  </span>
                  Watch Video
                </Link>
              ) : null}
            </div>
          </div>
          <p className="hidden -rotate-6 justify-self-end md:block font-serif text-3xl italic leading-tight text-white drop-shadow-xl">
            The Land.
            <br />
            The People.
            <br />
            A Living Legacy.
          </p>
        </div>
        {entry.imageCredit ? (
          <p className="absolute bottom-3 right-6 max-w-[60%] text-right text-[11px] text-white/70 md:right-20">
            {entry.imageCaption ? `${entry.imageCaption}. ` : ""}Photo:{" "}
            {entry.imageCredit.sourceUrl ? (
              <a href={entry.imageCredit.sourceUrl} target="_blank" rel="noreferrer" className="underline">
                {entry.imageCredit.author}
              </a>
            ) : (
              entry.imageCredit.author
            )}
            , {entry.imageCredit.license}
          </p>
        ) : null}
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-10 md:px-20 lg:grid-cols-[1fr_320px_270px]">
        <article>
          <h2 className="font-serif text-5xl font-black text-brand-deep">Overview</h2>
          <p className="mt-4 max-w-3xl text-lg leading-8 text-brand-deep/75">{entry.summary}</p>
          <h3 className="mt-10 text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Known For</h3>
          <ul className="mt-4 grid gap-4 sm:grid-cols-3">
            {entry.knownFor.map((item, index) => {
              const Icon = overviewIcons[index % overviewIcons.length];
              return (
                <li key={item} className="rounded-xl border border-brand-sage/25 bg-white p-5 shadow-sm">
                  <Icon className="text-brand-terracotta" size={26} />
                  <p className="mt-3 font-semibold leading-6 text-brand-deep">{item}</p>
                </li>
              );
            })}
          </ul>
          {entry.reviewStatus === "development-review" ? (
            <p className="mt-8 text-sm text-brand-deep/60">
              This profile is an introduction. Fuller histories will be published with community review and cited sources.
            </p>
          ) : null}
        </article>

        <aside className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
          <h3 className="font-serif text-2xl font-black text-brand-deep">Quick Information</h3>
          <div className="mt-5 grid gap-4">
            {[
              ["Provinces", entry.provinces.join(", ")],
              ["Heritage", entry.type],
              ["Language", entry.language],
              ["Known For", entry.knownFor[0]]
            ].map(([label, value]) => (
              <div key={label} className="flex gap-3">
                <MapPin className="mt-1 shrink-0 text-brand-terracotta" size={22} />
                <span>
                  <strong className="block text-sm text-brand-deep">{label}</strong>
                  <span className="text-sm text-brand-deep/70">{value}</span>
                </span>
              </div>
            ))}
          </div>
        </aside>

        <aside className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
          <h3 className="font-serif text-2xl font-black text-brand-deep">Explore on Map</h3>
          <p className="mt-2 text-sm text-brand-deep/80">
            {nearbyPlaces.length} heritage {nearbyPlaces.length === 1 ? "place" : "places"} in {entry.provinces.join(", ")}.
            {featuredPlace ? ` Highlighted: ${featuredPlace.name}.` : ""}
          </p>
          <div className="mt-4">
            <HeritageMiniMap places={nearbyPlaces} initialSelectedId={featuredPlace?.id ?? null} />
          </div>
          <Link href={exploreHref} className="mt-4 flex justify-center rounded-xl bg-brand-forest px-4 py-3 font-bold text-white">
            Open Interactive Map →
          </Link>
        </aside>
      </section>

      {isBalobedu ? (
        <section className="mx-auto max-w-[1800px] px-6 pb-10 md:px-20">
          <div className="relative overflow-hidden rounded-xl bg-black">
            <video
              src={asset("/videos/rain-queen-preview.mp4")}
              poster={asset("/images/hologram-hub/rain-queen-frame-4.jpg")}
              controls
              playsInline
              preload="metadata"
              className="aspect-video max-h-[520px] w-full object-cover"
            />
          </div>
          <div className="mt-4 flex flex-wrap items-center justify-between gap-4">
            <p className="font-serif text-2xl font-black text-brand-deep">The Modjadji Rain Queen at the Hologram Hub</p>
            <Link href="/bookings/hologram" className="rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
              Book the Experience →
            </Link>
          </div>
        </section>
      ) : null}

      {related.length > 0 ? (
        <section className="bg-white/65 py-10">
          <div className="mx-auto max-w-[1800px] px-6 md:px-20">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="font-serif text-4xl font-black text-brand-deep">Heritage Nearby</h2>
                <p className="mt-1 text-brand-deep/70">Other cultures rooted in {entry.provinces.join(", ")}.</p>
              </div>
              <Link href="/heritage" className="hidden font-bold text-brand-deep md:inline">
                View All Heritage →
              </Link>
            </div>
            <div className="mt-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
              {related.map((item) => (
                <ImageStoryCard
                  key={item.slug}
                  title={item.title}
                  subtitle={item.subtitle}
                  href={`/heritage/${item.slug}`}
                  image={item.image}
                  alt={item.imageAlt}
                  location={item.provinces.join(" · ")}
                />
              ))}
            </div>
          </div>
        </section>
      ) : null}
    </main>
  );
}
