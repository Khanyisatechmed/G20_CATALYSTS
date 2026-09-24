import Link from "next/link";
import { CalendarDays, MapPin, ShieldAlert } from "lucide-react";
import MockupHero from "@/components/MockupHero";
import { demoEvents } from "@/lib/demoData";

export default function EventsPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Events"
        title="Festivals, Markets and Heritage Days"
        subtitle="A styled event discovery area for museum previews, artisan showcases, school programmes and cultural festivals."
        image="/images/hero/south-africa-heritage.jpg"
        note={"Gather.\nCelebrate.\nRemember."}
      />

      <section className="mx-auto max-w-[1800px] px-6 py-12 md:px-20">
        <div className="mb-8 flex flex-wrap items-center justify-between gap-4">
          <div>
            <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Event Calendar</p>
            <h1 className="mt-2 font-serif text-5xl font-black text-brand-deep">Upcoming demo listings</h1>
          </div>
          <p className="rounded-full bg-brand-sand/45 px-4 py-2 text-sm font-bold text-brand-deep">
            Dates require verification
          </p>
        </div>
        <div className="grid gap-5 md:grid-cols-3">
          {demoEvents.map((event) => (
            <article key={event.slug} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
              <p className="text-sm font-black uppercase tracking-[0.22em] text-brand-terracotta">{event.category}</p>
              <h2 className="mt-4 font-serif text-3xl font-black text-brand-deep">{event.title}</h2>
              <p className="mt-4 flex items-center gap-2 text-brand-deep/70"><MapPin size={18} /> {event.province}</p>
              <p className="mt-2 flex items-center gap-2 text-brand-deep/70"><CalendarDays size={18} /> {event.dateLabel}</p>
              <p className="mt-5 flex items-center gap-2 rounded-lg bg-brand-ivory px-4 py-3 text-sm font-bold text-brand-deep">
                <ShieldAlert size={17} className="text-brand-terracotta" /> {event.status}
              </p>
              <Link href="/plan-your-visit" className="mt-5 inline-flex font-bold text-brand-forest">Plan around this event -&gt;</Link>
            </article>
          ))}
        </div>
      </section>
    </main>
  );
}
