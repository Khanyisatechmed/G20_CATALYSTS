import Link from "next/link";
import { ArrowRight, LockKeyhole, ShieldCheck, Users } from "lucide-react";
import DemoLoginPanel from "@/components/DemoLoginPanel";
import { asset } from "@/lib/basePath";

export default function LoginPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-30" style={{ backgroundImage: `url(${asset("/images/hero/south-africa-heritage.jpg")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-brand-deep/78 to-brand-deep/35" />
        <div className="relative mx-auto grid min-h-[520px] max-w-[1800px] items-center gap-10 px-6 py-16 lg:grid-cols-[minmax(0,1fr)_430px] md:px-20">
          <div className="text-white">
            <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">Demo Access</p>
            <h1 className="mt-5 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl">Switch roles and explore every workflow.</h1>
            <p className="mt-6 max-w-2xl text-lg leading-8 text-white/82">
              Use role-based demo access to move between visitor, vendor, museum staff and admin perspectives. This is a showcase control, not production authentication.
            </p>
            <Link href="/account" className="mt-8 inline-flex items-center gap-3 rounded-xl bg-brand-sand px-6 py-3 font-bold text-brand-deep">
              Open account dashboard <ArrowRight size={18} />
            </Link>
          </div>
          <DemoLoginPanel />
        </div>
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-5 px-6 py-10 md:grid-cols-3 md:px-20">
        {[
          ["Visitor", "Explore bookings, cart, favourites and itineraries.", Users],
          ["Vendor", "Preview fulfilment, products and public profile tools.", ShieldCheck],
          ["Admin", "Review moderation, approvals and platform settings.", LockKeyhole]
        ].map(([title, text, Icon]) => (
          <article key={title as string} className="rounded-xl bg-white p-6 shadow-sm">
            <Icon className="text-brand-terracotta" size={26} />
            <h2 className="mt-4 font-serif text-2xl font-black text-brand-deep">{title as string}</h2>
            <p className="mt-2 leading-7 text-brand-deep/70">{text as string}</p>
          </article>
        ))}
      </section>
    </main>
  );
}
