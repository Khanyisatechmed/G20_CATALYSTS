import Image from "next/image";
import Link from "next/link";
import { ArrowRight, Handshake, Landmark, Leaf, MapPin, Sparkles } from "lucide-react";
import { asset } from "@/lib/basePath";

const container = "mx-auto max-w-[1440px] px-6 md:px-12 xl:px-20";
const eyebrow = "text-xs font-black uppercase tracking-[0.32em] text-brand-terracotta md:text-sm";
const sectionHeading = "font-serif text-4xl font-black leading-[1.08] text-brand-deep md:text-5xl";
const primaryButton =
  "inline-flex items-center justify-center gap-3 rounded-xl bg-brand-forest px-7 py-3.5 font-bold text-white shadow-sm transition hover:bg-brand-deep";
const secondaryButton =
  "inline-flex items-center justify-center gap-3 rounded-xl border border-brand-forest/40 bg-white px-7 py-3.5 font-bold text-brand-deep transition hover:border-brand-terracotta hover:text-brand-terracotta";

const pillars = [
  {
    title: "Heritage Preservation",
    text: "Recording and sharing the histories, traditions and sacred places of South Africa's many cultures with care and respect.",
    Icon: Landmark
  },
  {
    title: "Immersive Innovation",
    text: "Hologram storytelling, 3D previews and guided discovery that let heritage be seen, heard and remembered.",
    Icon: Sparkles
  },
  {
    title: "Community Commerce",
    text: "Connecting visitors with local artisans, makers and cultural businesses so that heritage supports livelihoods.",
    Icon: Handshake
  },
  {
    title: "Responsible Tourism",
    text: "Encouraging travel that honours host communities, protects landscapes and shares value with the people behind each story.",
    Icon: Leaf
  }
];

const hubFacts = [
  "An indoor, two-storey heritage museum",
  "Inaugural experience: the Balobedu Rain Queen",
  "First physical hub hosted in Limpopo"
];

export default function AboutPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      {/* Hero */}
      <section className="relative -mt-8 overflow-hidden">
        <Image
          src="/images/provinces/free-state.png"
          alt="Sunset over the sandstone cliffs of the Golden Gate Highlands, Free State"
          fill
          priority
          sizes="100vw"
          className="object-cover object-[70%_center]"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-black/85 via-black/60 to-black/25" />
        <div className="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-black/50 to-transparent" />
        <div className={`${container} relative flex min-h-[560px] items-center pb-20 pt-28 md:min-h-[640px]`}>
          <div className="max-w-3xl">
            <p className="text-xs font-black uppercase tracking-[0.4em] text-brand-sand md:text-sm">
              About Catalystic Wanders
            </p>
            <h1 className="mt-5 font-serif text-[2.6rem] font-black leading-[1.02] text-white sm:text-6xl lg:text-7xl">
              Where Heritage Meets Innovation
            </h1>
            <p className="mt-6 max-w-2xl text-lg leading-8 text-white/90 md:text-xl md:leading-9">
              Catalystic Wanders connects people with South Africa&apos;s living heritage through immersive
              storytelling, cultural discovery, local artisan commerce and intelligent travel experiences.
            </p>
            <div className="mt-9 flex flex-col gap-4 sm:flex-row">
              <Link href="/heritage" className={primaryButton}>
                Explore Our Heritage <ArrowRight size={18} />
              </Link>
              <Link
                href="/hologram-hub"
                className="inline-flex items-center justify-center gap-3 rounded-xl border border-white/80 bg-black/25 px-7 py-3.5 font-bold text-white backdrop-blur transition hover:bg-white hover:text-brand-deep"
              >
                Discover the Hologram Hub
              </Link>
            </div>
          </div>
        </div>
        <p className="absolute bottom-5 right-6 hidden text-xs font-semibold tracking-wide text-white/70 md:block md:right-12 xl:right-20">
          Golden Gate Highlands, Free State
        </p>
      </section>

      {/* Our Story */}
      <section className={`${container} grid items-center gap-12 py-20 md:py-28 lg:grid-cols-2 lg:gap-20`}>
        <div className="relative pb-16 pr-10 sm:pb-20 sm:pr-16">
          <div className="relative aspect-[4/3] overflow-hidden rounded-2xl shadow-xl shadow-black/10">
            <Image
              src="/images/provinces/western-cape.png"
              alt="Robben Island and its lighthouse seen from the water, Western Cape"
              fill
              sizes="(min-width: 1024px) 45vw, 90vw"
              className="object-cover"
            />
          </div>
          <div className="absolute bottom-0 right-0 aspect-[4/3] w-1/2 overflow-hidden rounded-2xl border-[6px] border-brand-ivory shadow-xl shadow-black/15">
            <Image
              src="/images/magoebaskloof.png"
              alt="Forest reflected in a still lake in Magoebaskloof, Limpopo"
              fill
              sizes="(min-width: 1024px) 22vw, 45vw"
              className="object-cover"
            />
          </div>
        </div>

        <div>
          <p className={eyebrow}>Our Story</p>
          <h2 className={`mt-4 ${sectionHeading}`}>A New Way to Experience South Africa</h2>
          <div className="mt-6 space-y-5 text-lg leading-8 text-brand-deep/80">
            <p>
              South Africa&apos;s heritage lives in its languages, crafts, landscapes, sacred sites and the stories
              passed between generations. Catalystic Wanders brings these together in one place so that visitors
              can discover them with depth and respect.
            </p>
            <p>
              We combine cultural storytelling, thoughtful technology and the knowledge of local communities to
              help travellers look beyond the familiar, from Robben Island to the forests of Magoebaskloof and
              every province in between.
            </p>
          </div>
          <dl className="mt-10 grid grid-cols-2 gap-6 border-t border-brand-sage/40 pt-8">
            <div>
              <dt className="text-sm font-semibold text-brand-deep/65">Provinces celebrated</dt>
              <dd className="mt-1 font-serif text-3xl font-black text-brand-forest sm:text-4xl">All nine</dd>
            </div>
            <div>
              <dt className="text-sm font-semibold text-brand-deep/65">Built around</dt>
              <dd className="mt-1 font-serif text-3xl font-black text-brand-forest sm:text-4xl">Community</dd>
            </div>
          </dl>
        </div>
      </section>

      {/* Our Vision */}
      <section className="border-y border-brand-sage/25 bg-[#eef0e3] py-20 md:py-28">
        <div className={container}>
          <div className="mx-auto max-w-3xl text-center">
            <p className={eyebrow}>Our Vision</p>
            <h2 className={`mt-4 ${sectionHeading}`}>One Country. Many Cultures. Countless Stories.</h2>
            <p className="mt-6 text-lg leading-8 text-brand-deep/75">
              We want every journey through South Africa to leave visitors closer to the people and places that
              shape it. Four principles guide how we build.
            </p>
          </div>
          <div className="mt-14 grid gap-6 sm:grid-cols-2 xl:grid-cols-4">
            {pillars.map(({ title, text, Icon }) => (
              <article
                key={title}
                className="rounded-2xl border border-brand-sage/30 bg-brand-ivory p-8 shadow-sm transition hover:-translate-y-1 hover:shadow-lg hover:shadow-black/5"
              >
                <div className="grid h-12 w-12 place-items-center rounded-full bg-brand-terracotta/10 text-brand-terracotta">
                  <Icon size={22} />
                </div>
                <h3 className="mt-6 font-serif text-2xl font-black text-brand-deep">{title}</h3>
                <p className="mt-3 leading-7 text-brand-deep/70">{text}</p>
              </article>
            ))}
          </div>
        </div>
      </section>

      {/* Hologram Hub */}
      <section className="bg-brand-deep py-20 text-white md:py-28">
        <div className={`${container} grid items-center gap-12 lg:grid-cols-[1.15fr_0.85fr] lg:gap-20`}>
          <div className="relative overflow-hidden rounded-2xl border border-white/10 bg-black shadow-2xl shadow-black/40">
            <video
              src={asset("/videos/rain-queen-preview.mp4")}
              poster={asset("/images/hologram-hub/rain-queen-frame-4.jpg")}
              autoPlay
              muted
              loop
              playsInline
              preload="metadata"
              aria-label="Preview of the Balobedu Rain Queen hologram experience"
              className="aspect-video w-full object-cover"
            />
            <p className="absolute bottom-4 left-4 rounded-full bg-black/60 px-4 py-2 text-xs font-bold uppercase tracking-[0.2em] text-brand-sand backdrop-blur">
              Inaugural experience
            </p>
          </div>

          <div>
            <p className="text-xs font-black uppercase tracking-[0.32em] text-brand-sand md:text-sm">
              The Hologram Hub
            </p>
            <h2 className="mt-4 font-serif text-4xl font-black leading-[1.08] md:text-5xl">
              A Museum Where Stories Come to Life
            </h2>
            <p className="mt-6 text-lg leading-8 text-white/85">
              The Hologram Hub is an indoor, two-storey museum where heritage is experienced rather than simply
              read. Its inaugural experience honours the Balobedu Rain Queen, the Modjadji, whose legacy of
              leadership and rain-making is central to the history of Limpopo.
            </p>
            <p className="mt-4 text-lg leading-8 text-white/85">
              Limpopo hosts the first physical hub, while the Catalystic Wanders platform celebrates heritage
              across all nine provinces.
            </p>
            <ul className="mt-8 space-y-3">
              {hubFacts.map((fact) => (
                <li key={fact} className="flex items-start gap-3 font-semibold text-white/90">
                  <MapPin size={18} className="mt-1 shrink-0 text-brand-sand" />
                  {fact}
                </li>
              ))}
            </ul>
            <Link
              href="/hologram-hub"
              className="mt-10 inline-flex items-center gap-3 rounded-xl bg-brand-ivory px-7 py-3.5 font-bold text-brand-deep transition hover:bg-brand-sand"
            >
              Discover the Hologram Hub <ArrowRight size={18} />
            </Link>
          </div>
        </div>
      </section>

      {/* Community Impact */}
      <section className={`${container} grid items-center gap-12 py-20 md:py-28 lg:grid-cols-2 lg:gap-20`}>
        <div className="order-2 lg:order-1">
          <p className={eyebrow}>Community Impact</p>
          <h2 className={`mt-4 ${sectionHeading}`}>Supporting the People Behind the Culture</h2>
          <div className="mt-6 space-y-5 text-lg leading-8 text-brand-deep/80">
            <p>
              Heritage is carried by people: weavers, potters, storytellers, cooks and guides. Our cultural
              marketplace gives their work a place in every journey, with the story behind each piece.
            </p>
            <p>
              Vendor discovery tools help visitors find participating local businesses across South Africa, so
              that time and money spent exploring heritage stays with the communities who keep it alive.
            </p>
          </div>
          <div className="mt-9 flex flex-col gap-4 sm:flex-row">
            <Link href="/marketplace" className={primaryButton}>
              Explore the Marketplace <ArrowRight size={18} />
            </Link>
            <Link href="/vendors" className={secondaryButton}>
              Find Local Vendors
            </Link>
          </div>
        </div>

        <div className="order-1 grid grid-cols-2 gap-4 lg:order-2">
          <div className="relative col-span-2 aspect-[16/9] overflow-hidden rounded-2xl shadow-lg shadow-black/10">
            <Image
              src="/images/heritage/khoi-san.png"
              alt="Artisans practising traditional crafts outside a reed shelter"
              fill
              sizes="(min-width: 1024px) 45vw, 90vw"
              className="object-cover"
            />
          </div>
          <div className="relative aspect-square overflow-hidden rounded-2xl shadow-lg shadow-black/10">
            <Image
              src="/images/zulubasket.png"
              alt="Hand-woven Zulu basket with a lid"
              fill
              sizes="(min-width: 1024px) 22vw, 45vw"
              className="object-cover"
            />
          </div>
          <div className="relative aspect-square overflow-hidden rounded-2xl shadow-lg shadow-black/10">
            <Image
              src="/images/marketplace/zulu-ikhamba.png"
              alt="Traditional Zulu ikhamba clay vessel"
              fill
              sizes="(min-width: 1024px) 22vw, 45vw"
              className="object-cover"
            />
          </div>
        </div>
      </section>

      {/* Final CTA */}
      <section className="px-6 pb-24 md:px-12 xl:px-20">
        <div className="mx-auto max-w-[1280px] overflow-hidden rounded-3xl bg-brand-forest px-8 py-16 text-center text-white shadow-xl shadow-brand-forest/20 md:px-16 md:py-20">
          <h2 className="mx-auto max-w-3xl font-serif text-4xl font-black leading-[1.1] md:text-5xl">
            Your Journey Into South Africa&apos;s Living Heritage Starts Here
          </h2>
          <div className="mt-10 flex flex-col justify-center gap-4 sm:flex-row">
            <Link
              href="/heritage"
              className="inline-flex items-center justify-center gap-3 rounded-xl bg-brand-ivory px-7 py-3.5 font-bold text-brand-deep transition hover:bg-brand-sand"
            >
              Explore Our Heritage <ArrowRight size={18} />
            </Link>
            <Link
              href="/plan-your-visit"
              className="inline-flex items-center justify-center gap-3 rounded-xl border border-white/70 px-7 py-3.5 font-bold text-white transition hover:bg-white hover:text-brand-deep"
            >
              Plan Your Visit
            </Link>
          </div>
        </div>
      </section>
    </main>
  );
}
