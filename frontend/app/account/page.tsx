"use client";

import Link from "next/link";
import { ArrowRight, CalendarDays, Heart, PackageCheck, Route } from "lucide-react";
import DemoLoginPanel from "@/components/DemoLoginPanel";
import { demoBookings, demoOrders } from "@/lib/demoData";
import { useDemoSessionStore } from "@/stores/demoSessionStore";
import { asset } from "@/lib/basePath";

export default function AccountPage() {
  const role = useDemoSessionStore((state) => state.role);
  const name = useDemoSessionStore((state) => state.name);

  const modules = [
    { label: "Bookings", href: "/account/bookings", Icon: CalendarDays },
    { label: "Orders", href: "/account/orders", Icon: PackageCheck },
    { label: "Itineraries", href: "/account/itineraries", Icon: Route },
    { label: "Favourites", href: "/account/favourites", Icon: Heart }
  ];

  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-30" style={{ backgroundImage: `url(${asset("/images/hero/south-africa-heritage.jpg")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-brand-deep/78 to-brand-deep/35" />
        <div className="relative mx-auto grid min-h-[420px] max-w-[1800px] items-center gap-8 px-6 py-16 md:grid-cols-[1fr_380px] md:px-20">
          <div className="text-white">
            <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">Account</p>
            <h1 className="mt-5 font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl">Welcome, {name}</h1>
            <p className="mt-5 max-w-2xl text-lg leading-8 text-white/82">
              Current demo role: {role}. This dashboard collects saved trips, orders, reservations and profile controls into one place.
            </p>
          </div>
          <DemoLoginPanel />
        </div>
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-12 lg:grid-cols-[minmax(0,1fr)_420px] md:px-20">
        <div>
          <div className="grid gap-4 md:grid-cols-4">
            {modules.map(({ label, href, Icon }) => (
              <Link key={href} href={href} className="rounded-xl border border-brand-sage/25 bg-white p-5 shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
                <Icon className="text-brand-terracotta" size={25} />
                <p className="mt-4 font-serif text-2xl font-black text-brand-deep">{label}</p>
                <p className="mt-2 text-sm font-bold text-brand-forest">Open module -&gt;</p>
              </Link>
            ))}
          </div>

          <div className="mt-8 grid gap-5 md:grid-cols-2">
            <section className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
              <h2 className="font-serif text-3xl font-black text-brand-deep">Booking history</h2>
              <div className="mt-4 grid gap-3">
                {demoBookings.map((booking) => (
                  <article key={booking.reference} className="rounded-xl bg-brand-ivory p-4">
                    <p className="font-black text-brand-deep">{booking.experience}</p>
                    <p className="mt-1 text-sm text-brand-deep/65">{booking.reference}</p>
                    <p className="mt-2 text-sm font-semibold text-brand-terracotta">{booking.status} / {booking.paymentStatus}</p>
                  </article>
                ))}
              </div>
            </section>

            <section className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
              <h2 className="font-serif text-3xl font-black text-brand-deep">Order history</h2>
              <div className="mt-4 grid gap-3">
                {demoOrders.map((order) => (
                  <article key={order.reference} className="rounded-xl bg-brand-ivory p-4">
                    <p className="font-black text-brand-deep">{order.item}</p>
                    <p className="mt-1 text-sm text-brand-deep/65">{order.reference}</p>
                    <p className="mt-2 text-sm font-semibold text-brand-terracotta">{order.status} / {order.fulfilment}</p>
                  </article>
                ))}
              </div>
            </section>
          </div>
        </div>

        <aside className="rounded-xl bg-brand-deep p-6 text-white">
          <p className="text-sm font-black uppercase tracking-[0.24em] text-brand-sand">Profile Note</p>
          <h2 className="mt-3 font-serif text-3xl font-black">Demo state</h2>
          <p className="mt-4 leading-7 text-white/75">
            Account data is stored client-side for presentation only. Production requires secure auth, server sessions and database-backed records.
          </p>
          <Link href="/plan-your-visit" className="mt-6 inline-flex items-center gap-2 rounded-xl bg-brand-sand px-5 py-3 font-bold text-brand-deep">
            Plan another trip <ArrowRight size={17} />
          </Link>
        </aside>
      </section>
    </main>
  );
}
