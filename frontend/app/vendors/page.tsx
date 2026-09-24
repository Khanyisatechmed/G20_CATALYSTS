import Link from "next/link";
import { BadgeCheck, MapPin, Search, ShieldCheck, Store } from "lucide-react";
import MockupHero from "@/components/MockupHero";
import { demoVendors } from "@/lib/demoData";

export default function VendorsPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Vendor Directory"
        title="Meet the Makers Behind the Journey"
        subtitle="Browse artisan studios, market collectives and cultural sellers prepared for the public discovery and marketplace experience."
        image="/images/zulubasket.png"
        note={"Real Craft.\nLocal People.\nShared Value."}
      />

      <section className="border-b border-brand-sage/25 bg-brand-ivory py-5">
        <div className="mx-auto grid max-w-[1800px] gap-4 px-6 sm:grid-cols-2 lg:grid-cols-[1fr_220px_220px_180px] md:px-20">
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-brand-deep" size={20} />
            <input className="w-full rounded-xl border border-brand-sage/35 bg-white px-12 py-4 shadow-sm" placeholder="Search artisans, markets or craft categories..." />
          </div>
          <select className="rounded-xl border border-brand-sage/35 bg-white px-4 py-4 shadow-sm">
            <option>All Provinces</option>
          </select>
          <select className="rounded-xl border border-brand-sage/35 bg-white px-4 py-4 shadow-sm">
            <option>All Categories</option>
          </select>
          <button className="rounded-xl bg-brand-forest px-5 py-4 font-bold text-white">Search -&gt;</button>
        </div>
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-12 md:px-20 lg:grid-cols-[260px_minmax(0,1fr)]">
        <aside className="hidden border-r border-brand-sage/30 pr-6 md:block">
          <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Directory</p>
          {["Approved demo vendors", "Craft studios", "Food partners", "Market collectives", "Cultural hosts"].map((item, index) => (
            <button key={item} className={[
              "mt-2 flex w-full items-center gap-3 rounded-lg px-4 py-3 text-left text-sm font-bold",
              index === 0 ? "bg-brand-forest text-white" : "text-brand-deep/75 hover:bg-white"
            ].join(" ")}>
              <Store size={18} /> {item}
            </button>
          ))}
        </aside>

        <div>
          <div className="mb-7 flex flex-wrap items-end justify-between gap-4">
            <div>
              <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Verified Discovery</p>
              <h1 className="mt-2 font-serif text-5xl font-black text-brand-deep">Public vendor profiles</h1>
            </div>
            <p className="rounded-full bg-brand-sage/20 px-4 py-2 text-sm font-bold text-brand-deep">
              Private residential addresses hidden
            </p>
          </div>
          <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-3">
            {demoVendors.map((vendor) => (
              <Link key={vendor.slug} href={`/vendors/${vendor.slug}`} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
                <div className="flex items-center justify-between">
                  <span className="rounded-full bg-brand-sand/50 px-3 py-1 text-xs font-black text-brand-deep">{vendor.category}</span>
                  <BadgeCheck className="text-brand-forest" size={21} />
                </div>
                <h2 className="mt-5 font-serif text-3xl font-black leading-tight text-brand-deep">{vendor.businessName}</h2>
                <p className="mt-2 font-semibold text-brand-deep/70">{vendor.artisanName}</p>
                <p className="mt-4 flex items-center gap-2 text-sm text-brand-deep/65"><MapPin size={16} /> {vendor.town}, {vendor.province}</p>
                <p className="mt-4 flex items-center gap-2 rounded-lg bg-brand-ivory px-4 py-3 text-sm font-bold text-brand-forest">
                  <ShieldCheck size={17} /> {vendor.status}
                </p>
              </Link>
            ))}
          </div>
        </div>
      </section>
    </main>
  );
}
