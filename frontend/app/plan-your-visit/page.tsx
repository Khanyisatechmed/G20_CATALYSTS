"use client";

import Image from "next/image";
import Link from "next/link";
import { useState } from "react";
import {
  Bed,
  CalendarDays,
  Car,
  Edit3,
  Heart,
  Map,
  MapPin,
  Plane,
  Save,
  Share2,
  Sparkles,
  Store,
  Tag,
  Users,
  Utensils,
  Wand2
} from "lucide-react";
import dynamic from "next/dynamic";
import MockupHero from "@/components/MockupHero";
import { sampleItineraryStops } from "@/lib/itinerary";

// Leaflet needs the browser, so the route map renders client-side only.
const ItineraryLeaflet = dynamic(() => import("@/components/ItineraryLeaflet"), {
  ssr: false,
  loading: () => (
    <div className="grid h-full place-items-center bg-[#dfead6] text-sm font-semibold text-brand-deep/80">Loading map…</div>
  )
});

const chips = ["Heritage & History", "Cultural Experiences", "Nature & Wildlife", "Local Food", "Arts & Crafts"];

const days = [
  { label: "Day 1", place: "Limpopo" },
  { label: "Day 2", place: "Limpopo" },
  { label: "Day 3", place: "Mpumalanga" },
  { label: "Day 4", place: "Mpumalanga" },
  { label: "Day 5", place: "Return" }
];

const itinerary = [
  {
    time: "08:00",
    Icon: Plane,
    title: "Arrive in Polokwane",
    description: "Arrive at Polokwane International Airport, collect your rental car and begin your journey into Limpopo's cultural landscape.",
    image: "/images/hero/south-africa-heritage.jpg",
    tag: "Arrival"
  },
  {
    time: "10:30",
    Icon: MapPin,
    title: "Modjadji Royal Heritage Experience",
    description: "Learn about the Balobedu kingdom, including the Modjadji Rain Queen legacy, oral histories and sacred landscapes.",
    image: "/images/heritage/balobedu.jpg",
    tag: "Cultural Experience"
  },
  {
    time: "13:00",
    Icon: Utensils,
    title: "Traditional Lunch Experience",
    description: "Enjoy authentic Limpopo cuisine at a local restaurant featuring traditional dishes and seasonal ingredients.",
    image: "/images/potbread.png",
    tag: "Food & Drink"
  },
  {
    time: "15:00",
    Icon: Store,
    title: "Local Artisan Market",
    description: "Explore handmade crafts, beadwork, pottery and traditional products from local artisans.",
    image: "/images/zulubasket.png",
    tag: "Shopping"
  },
  {
    time: "17:00",
    Icon: Bed,
    title: "Check-in at Accommodation",
    description: "Settle into your stay, review saved experiences and prepare for the next day's nature routes.",
    image: "/images/provinces/mpumalanga.png",
    tag: "Accommodation"
  }
];

const featured = [
  {
    title: "Modjadji Hologram Experience",
    location: "Limpopo",
    image: "/images/hologram-hub/rain-queen-frame-4.jpg"
  },
  {
    title: "Magoebaskloof Nature Trails",
    location: "Limpopo",
    image: "/images/magoebaskloof.png"
  },
  {
    title: "Kruger National Park Safari",
    location: "Mpumalanga",
    image: "/images/kruger.png"
  }
];

export default function PlanYourVisitPage() {
  const [activeDay, setActiveDay] = useState(0);

  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Travel Planner"
        title="Plan Your South African Journey"
        subtitle="Create a personalised itinerary with the help of Ask Catalyst. Discover heritage sites, local food, cultural experiences, artisans and hidden gems."
        image="/images/hero/south-africa-heritage.jpg"
        note={"Your Journey.\nYour Story.\nSouth Africa."}
      />

      <section className="mx-auto grid max-w-[1800px] gap-7 px-6 py-8 md:px-20 lg:grid-cols-[360px_minmax(0,1fr)] 2xl:grid-cols-[430px_minmax(0,1fr)_350px]">
        <aside className="rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm">
          <h1 className="font-serif text-4xl font-black text-brand-deep">Plan Your Trip</h1>
          <p className="mt-2 text-sm leading-6 text-brand-deep/70">
            Tell us about your trip and this demo will shape a culturally rich itinerary around your interests.
          </p>

          <div className="mt-7 grid gap-5">
            <label className="block">
              <span className="flex items-center gap-2 text-sm font-black text-brand-deep">
                <MapPin size={18} className="text-brand-terracotta" /> Destination(s)
              </span>
              <div className="mt-2 flex items-center justify-between rounded-xl border border-brand-sage/35 px-4 py-3">
                <div className="flex flex-wrap gap-2">
                  {["Limpopo", "Mpumalanga"].map((item) => (
                    <span key={item} className="rounded-full bg-brand-sage/25 px-3 py-1 text-sm font-semibold text-brand-deep">
                      {item} x
                    </span>
                  ))}
                </div>
                <span className="text-brand-deep/60">v</span>
              </div>
            </label>

            <label className="block">
              <span className="flex items-center gap-2 text-sm font-black text-brand-deep">
                <CalendarDays size={18} className="text-brand-terracotta" /> Travel Dates
              </span>
              <input value="10 Oct 2026 - 14 Oct 2026" readOnly className="mt-2 w-full rounded-xl border border-brand-sage/35 bg-white px-4 py-3 text-brand-deep" />
            </label>

            <label className="block">
              <span className="flex items-center gap-2 text-sm font-black text-brand-deep">
                <Users size={18} className="text-brand-terracotta" /> Number of Travellers
              </span>
              <select className="mt-2 w-full rounded-xl border border-brand-sage/35 bg-white px-4 py-3">
                <option>2 Adults</option>
                <option>Family of 4</option>
                <option>School Group</option>
              </select>
            </label>

            <label className="block">
              <span className="flex items-center gap-2 text-sm font-black text-brand-deep">
                <Tag size={18} className="text-brand-terracotta" /> Budget (per person)
              </span>
              <select className="mt-2 w-full rounded-xl border border-brand-sage/35 bg-white px-4 py-3">
                <option>R5,000 - R10,000</option>
                <option>R10,000 - R18,000</option>
                <option>R18,000+</option>
              </select>
            </label>

            <div>
              <p className="text-sm font-black text-brand-deep">Interests</p>
              <div className="mt-2 flex flex-wrap gap-2">
                {chips.map((chip) => (
                  <span key={chip} className="rounded-full bg-brand-sage/25 px-3 py-2 text-sm font-semibold text-brand-deep">
                    {chip} x
                  </span>
                ))}
              </div>
            </div>

            <label className="block">
              <span className="flex items-center gap-2 text-sm font-black text-brand-deep">
                <Sparkles size={18} className="text-brand-terracotta" /> Accessibility Requirements
              </span>
              <select className="mt-2 w-full rounded-xl border border-brand-sage/35 bg-white px-4 py-3">
                <option>None</option>
                <option>Wheelchair accessible routes</option>
                <option>Low walking intensity</option>
              </select>
            </label>
          </div>

          <button className="mt-6 flex w-full items-center justify-center gap-2 rounded-xl bg-brand-forest px-5 py-4 font-bold text-white">
            <Wand2 size={18} /> Generate My Itinerary -&gt;
          </button>

          <article className="mt-5 rounded-xl border border-brand-sage/30 bg-brand-ivory p-4">
            <p className="font-bold text-brand-deep">Or chat with Ask Catalyst</p>
            <p className="mt-1 text-sm leading-6 text-brand-deep/65">
              Get personalised recommendations, real-time demo tips and travel ideas.
            </p>
            <button
              type="button"
              onClick={() => window.dispatchEvent(new Event("open-ask-catalyst"))}
              className="mt-3 inline-flex font-bold text-brand-forest"
            >
              Chat with Ask Catalyst -&gt;
            </button>
          </article>
        </aside>

        <section className="min-w-0 rounded-xl border border-brand-sage/30 bg-white p-4 shadow-sm sm:p-6">
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div>
              <div className="flex flex-wrap items-center gap-3">
                <h2 className="font-serif text-4xl font-black text-brand-deep">Your 5-Day Itinerary</h2>
                <span className="rounded-full bg-brand-forest px-4 py-2 text-xs font-black text-white">
                  AI Recommended
                </span>
              </div>
              <p className="mt-2 text-brand-deep/70">
                A perfect blend of heritage, culture, nature and local experiences.
              </p>
            </div>
            <div className="flex flex-wrap gap-2">
              <button className="flex items-center gap-2 rounded-xl border border-brand-sage/35 px-4 py-3 font-bold text-brand-deep">
                <Edit3 size={16} /> Edit Itinerary
              </button>
              <button className="grid h-12 w-12 place-items-center rounded-xl border border-brand-sage/35 text-brand-deep">
                <Save size={17} />
              </button>
              <button className="grid h-12 w-12 place-items-center rounded-xl border border-brand-sage/35 text-brand-deep">
                <Share2 size={17} />
              </button>
            </div>
          </div>

          <div className="-mx-1 mt-7 flex gap-2 overflow-x-auto px-1 pb-1">
            {days.map((day, index) => (
              <button
                key={day.label}
                type="button"
                onClick={() => setActiveDay(index)}
                aria-pressed={activeDay === index}
                className={[
                  "min-w-[7.5rem] flex-1 shrink-0 rounded-xl border px-4 py-3 text-left",
                  activeDay === index
                    ? "border-brand-forest bg-brand-forest text-white"
                    : "border-brand-sage/35 bg-brand-ivory text-brand-deep"
                ].join(" ")}
              >
                <span className="block font-black">{day.label}</span>
                <span className="text-xs opacity-75">{day.place}</span>
              </button>
            ))}
          </div>

          <div className="mt-7 rounded-xl border border-brand-sage/30 bg-brand-ivory/40 p-3 sm:p-5">
            <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
              <div>
                <h3 className="font-serif text-3xl font-black text-brand-deep">Day 1 - Arrival & Cultural Immersion</h3>
                <p className="mt-1 text-brand-deep/65">Limpopo | Fri, 10 Oct 2026</p>
              </div>
              <a href="#itinerary-map" className="flex items-center gap-2 rounded-xl border border-brand-sage/35 bg-white px-5 py-3 font-bold text-brand-deep">
                <Map size={17} /> View Full Day Map
              </a>
            </div>

            {/* Laid out by the width of this column (container queries in globals.css), not the screen. */}
            <div className="itinerary-list relative grid gap-5">
              <div className="itinerary-line absolute top-4 h-[calc(100%-40px)] w-1 bg-brand-forest" aria-hidden="true" />
              {itinerary.map((item, index) => (
                <article key={item.title} className="itinerary-row">
                  <p className="pt-3 text-sm font-bold text-brand-deep">{item.time}</p>
                  <div className="itinerary-icon relative z-10 h-11 w-11 place-items-center rounded-full bg-brand-forest text-white">
                    <item.Icon size={20} />
                  </div>
                  <div className="itinerary-card rounded-xl bg-white p-4">
                    <div className="min-w-0">
                      <h4 className="font-serif text-xl font-black text-brand-deep">{item.title}</h4>
                      <p className="mt-1 text-sm leading-6 text-brand-deep/80">{item.description}</p>
                      <span className="mt-3 inline-flex rounded-full bg-brand-sand/55 px-3 py-1 text-xs font-bold text-brand-deep">
                        {item.tag}
                      </span>
                    </div>
                    <div className="relative min-h-36 overflow-hidden rounded-lg">
                      <Image src={item.image} alt={item.title} fill sizes="(min-width: 1280px) 220px, 90vw" className="object-cover" />
                      {index === 1 ? <Heart className="absolute right-3 top-3 text-white" size={19} /> : null}
                    </div>
                  </div>
                </article>
              ))}
            </div>
          </div>
        </section>

        <aside className="grid min-w-0 content-start gap-5 lg:col-span-2 lg:grid-cols-2 2xl:col-span-1 2xl:grid-cols-1">
          <article className="rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm">
            <h2 className="font-serif text-3xl font-black text-brand-deep">Trip Overview</h2>
            <div className="mt-5 grid gap-4 text-sm text-brand-deep/75">
              <p className="flex gap-3">
                <CalendarDays className="text-brand-terracotta" size={22} />
                <span><strong className="block text-brand-deep">10 - 14 Oct 2026</strong>5 Days, 4 Nights</span>
              </p>
              <p className="flex gap-3">
                <Users className="text-brand-terracotta" size={22} />
                <span><strong className="block text-brand-deep">2 Adults</strong>R5,000 - R10,000 per person</span>
              </p>
              <p className="flex gap-3">
                <MapPin className="text-brand-terracotta" size={22} />
                <span><strong className="block text-brand-deep">Limpopo, Mpumalanga</strong>Heritage, Nature, Food, Culture</span>
              </p>
            </div>
          </article>

          <article id="itinerary-map" className="scroll-mt-32 rounded-xl border border-brand-sage/30 bg-white p-5 shadow-sm">
            <div className="flex flex-wrap items-baseline justify-between gap-2">
              <h2 className="font-serif text-2xl font-black text-brand-deep">Itinerary Map</h2>
              <p className="text-sm font-semibold text-brand-terracotta">
                {days[activeDay].label} · {days[activeDay].place}
              </p>
            </div>
            <div className="relative isolate mt-4 h-80 overflow-hidden rounded-xl border border-brand-sage/30">
              <ItineraryLeaflet stops={sampleItineraryStops} activeDay={activeDay} />
            </div>
            <ol className="mt-4 grid gap-2 text-sm">
              {sampleItineraryStops.map((stop, index) => (
                <li key={stop.name} className="flex items-start gap-3">
                  <span
                    className={[
                      "grid h-6 w-6 shrink-0 place-items-center rounded-full text-xs font-bold text-white",
                      stop.day === activeDay ? "bg-brand-forest" : "bg-brand-sage"
                    ].join(" ")}
                  >
                    {index + 1}
                  </span>
                  <span className={stop.day === activeDay ? "font-semibold text-brand-deep" : "text-brand-deep/80"}>
                    {stop.name} <span className="text-brand-deep/80">· Day {stop.day + 1}</span>
                  </span>
                </li>
              ))}
            </ol>
            <div className="mt-4 flex flex-wrap items-center justify-between gap-3">
              <p className="text-xs text-brand-deep/80">Straight-line route between stops, not driving directions.</p>
              <Link href="/explore/map" className="rounded-xl bg-brand-forest px-5 py-3 font-bold text-white">
                View Full Map -&gt;
              </Link>
            </div>
          </article>

          <article className="rounded-xl border border-brand-sage/30 bg-white p-5 shadow-sm">
            <div className="flex items-center justify-between">
              <h2 className="font-serif text-xl font-black text-brand-deep">Featured Experiences</h2>
              <Link href="/experiences" className="text-xs font-bold text-brand-deep">View All -&gt;</Link>
            </div>
            <div className="mt-4 grid gap-3">
              {featured.map((item) => (
                <Link key={item.title} href="/hologram-hub" className="grid grid-cols-[96px_1fr] gap-3">
                  <div className="relative min-h-20 overflow-hidden rounded-lg">
                    <Image src={item.image} alt={item.title} fill className="object-cover" />
                  </div>
                  <div>
                    <p className="font-serif font-black leading-tight text-brand-deep">{item.title}</p>
                    <p className="mt-1 text-xs text-brand-deep/65">{item.location}</p>
                    <p className="mt-1 text-xs text-brand-terracotta">***** 4.8</p>
                  </div>
                </Link>
              ))}
            </div>
          </article>

          <article className="rounded-xl bg-brand-deep p-5 text-white">
            <div className="flex items-center gap-3">
              <Car className="text-brand-sand" size={24} />
              <p className="font-bold">Demo routes use sample data. Live travel times and bookings need provider integration.</p>
            </div>
          </article>
        </aside>
      </section>
    </main>
  );
}
