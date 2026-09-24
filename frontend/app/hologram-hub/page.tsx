import Image from "next/image";
import Link from "next/link";
import {
  ArrowRight,
  CalendarDays,
  GraduationCap,
  Landmark,
  MessageCircleQuestion,
  Play,
  ShieldCheck,
  Ticket,
  UsersRound,
  Warehouse
} from "lucide-react";
import ActionStrip from "@/components/ActionStrip";
import HologramPreview from "@/components/HologramPreview";
import { rainQueenPoster } from "@/lib/hologramMedia";
import { exhibitions } from "@/lib/content";
import { asset } from "@/lib/basePath";

const hubActions = [
  {
    title: "Museum Overview",
    subtitle: "A new way to experience heritage",
    href: "#overview",
    icon: Landmark
  },
  {
    title: "Exhibitions",
    subtitle: "Stories from across South Africa",
    href: "#exhibitions",
    icon: Warehouse
  },
  {
    title: "Plan Your Visit",
    subtitle: "Tickets, hours and information",
    href: "/bookings/hologram",
    icon: CalendarDays
  },
  {
    title: "School & Group Visits",
    subtitle: "Educational experiences",
    href: "/experiences",
    icon: UsersRound
  },
  {
    title: "FAQ",
    subtitle: "Everything you need to know",
    href: "#faq",
    icon: MessageCircleQuestion
  }
];

export default function HologramHubPage() {
  return (
    <main className="bg-brand-ivory">
      <section className="relative -mt-6 min-h-[430px] overflow-hidden bg-brand-deep">
        <video
          className="absolute inset-0 h-full w-full object-cover opacity-55"
          src={asset("/videos/rain-queen-preview.mp4")}
          poster={asset(rainQueenPoster)}
          autoPlay
          muted
          loop
          playsInline
        />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-black/36 to-black/8" />
        <div className="absolute inset-0 bg-black/45 md:hidden" />
        <div className="relative mx-auto grid min-h-[430px] max-w-[1800px] items-center gap-8 px-6 py-16 text-white md:grid-cols-[1fr_0.65fr] md:px-20">
          <div>
          <p className="text-sm font-black uppercase tracking-[0.3em] md:tracking-[0.48em] text-brand-sand">
            The Hologram Hub
          </p>
          <h1 className="mt-4 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl md:text-7xl md:leading-[0.9]">
            Where History Comes to Life
          </h1>
          <p className="mt-6 max-w-3xl text-lg leading-8 text-white/82">
            Step into an immersive museum experience in Limpopo, where the past
            meets the future. Discover the legacy of the Modjadji Rain Queen and
            explore the diverse stories of South Africa through holographic storytelling.
          </p>
          <div className="mt-8 flex flex-wrap gap-4">
            <Link href="/bookings/hologram" className="inline-flex items-center gap-3 rounded-xl bg-brand-terracotta px-8 py-4 font-bold text-white">
              Book Your Visit <ArrowRight size={18} />
            </Link>
            <Link href="#preview" className="inline-flex items-center gap-3 rounded-xl border border-white px-8 py-4 font-bold text-white">
              <span className="grid h-8 w-8 place-items-center rounded-full bg-white text-brand-deep">
                <Play size={16} fill="currentColor" />
              </span>
              Watch Video
            </Link>
          </div>
          </div>
          <p className="hidden -rotate-6 justify-self-end md:block font-serif text-3xl italic leading-tight text-white drop-shadow-xl">
            Immersive.
            <br />
            Educational.
            <br />
            Unforgettable.
          </p>
        </div>
      </section>

      <ActionStrip items={hubActions} />

      <section id="overview" className="relative mx-auto grid max-w-[1800px] gap-8 px-6 py-10 lg:grid-cols-[300px_minmax(0,1fr)] 2xl:grid-cols-[340px_minmax(0,1fr)_380px] md:px-20">
        <article>
          <p className="text-sm font-black uppercase tracking-[0.38em] text-brand-terracotta">
            Featured Experience
          </p>
          <h2 className="mt-4 font-serif text-5xl font-black leading-[0.95] text-brand-deep">
            The Modjadji Rain Queen
          </h2>
          <p className="mt-4 text-xl font-semibold text-brand-deep">
            A story of power, spirituality and the rain
          </p>
          <p className="mt-4 leading-7 text-brand-deep/75">
            Witness the life and legacy of the Balobedu Rain Queen through a
            breathtaking holographic experience. See history, culture and
            landscape come together in an immersive theatrical journey unlike any other.
          </p>
          <Link href="/bookings/hologram" className="mt-7 inline-flex items-center gap-3 rounded-xl bg-brand-forest px-7 py-3 font-bold text-white">
            Explore the Experience <ArrowRight size={18} />
          </Link>
        </article>

        <div id="preview">
          <HologramPreview />
        </div>

        <aside className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
          <h3 className="font-serif text-3xl font-black text-brand-deep">
            Book Your Visit
          </h3>
          <p className="mt-1 text-brand-deep/70">Experience the Hologram Hub</p>
          <div className="mt-5 grid gap-3">
            <select className="rounded-xl border border-brand-sage/40 px-4 py-3">
              <option>Modjadji Rain Queen Experience</option>
            </select>
            <div className="grid grid-cols-2 gap-3">
              <input type="month" defaultValue="2026-10" className="rounded-xl border border-brand-sage/40 px-4 py-3" />
              <select className="rounded-xl border border-brand-sage/40 px-4 py-3">
                <option>11:00 AM</option>
              </select>
            </div>
            {[
              ["Adult", "R180", "2"],
              ["Child (3–12)", "R90", "0"],
              ["Student", "R120", "0"],
              ["Family", "R420", "0"]
            ].map(([label, price, count]) => (
              <div key={label} className="flex items-center justify-between border-b border-brand-sage/25 py-2 text-sm">
                <span>{label}</span>
                <span>{price}</span>
                <span className="rounded-lg bg-brand-ivory px-3 py-1">− {count} +</span>
              </div>
            ))}
            <div className="flex justify-between rounded-lg bg-brand-sage/30 px-4 py-3 text-xl font-black text-brand-deep">
              <span>Total</span>
              <span>R360</span>
            </div>
            <Link href="/bookings/hologram" className="rounded-xl bg-brand-forest px-5 py-3 text-center font-bold text-white">
              Reserve Your Tickets →
            </Link>
            <p className="flex items-center justify-center gap-2 text-xs text-brand-deep/70">
              <ShieldCheck size={14} /> Demo booking / confirmation pending backend
            </p>
          </div>
        </aside>
      </section>

      <section id="exhibitions" className="mx-auto grid max-w-[1800px] gap-5 px-6 pb-16 md:grid-cols-4 md:px-20">
        {[
          ["Multiple Exhibitions", "Explore a growing collection of South African heritage stories and cultural experiences.", Ticket, "/images/hologram-hub/rain-queen-frame-3.jpg"],
          ["Educational Programmes", "School visits, guided tours and interactive learning for all ages.", GraduationCap, "/images/hero/south-africa-heritage.jpg"],
          ["Accessible For All", "A welcoming experience with accessible facilities and inclusive design.", ShieldCheck, "/images/provinces/mpumalanga.png"],
          ["Group & Corporate Bookings", "Tailored experiences for schools, corporate teams and tour groups.", UsersRound, "/images/heritage/khoi-san.png"]
        ].map(([title, text, Icon, image]) => (
          <article key={title as string} className="grid grid-cols-[1fr_150px] overflow-hidden rounded-xl bg-white shadow-sm">
            <div className="p-6">
              <Icon className="text-brand-terracotta" size={32} />
              <h3 className="mt-3 text-xl font-black text-brand-deep">{title as string}</h3>
              <p className="mt-3 text-sm leading-6 text-brand-deep/70">{text as string}</p>
            </div>
            <div className="relative min-h-44">
              <Image src={image as string} alt={title as string} fill className="object-cover" />
            </div>
          </article>
        ))}

        <div className="md:col-span-4">
          <div className="mt-5 grid gap-5 md:grid-cols-2">
            {exhibitions.map((exhibition) => (
              <article key={exhibition.slug} className="rounded-xl bg-white p-6 shadow-sm">
                <h3 className="text-2xl font-black text-brand-deep">{exhibition.title}</h3>
                <p className="mt-3 text-brand-deep/70">
                  Focus: {exhibition.focus}. Duration: {exhibition.duration}.
                  Review status: {exhibition.reviewStatus}.
                </p>
              </article>
            ))}
          </div>
        </div>
      </section>
    </main>
  );
}
