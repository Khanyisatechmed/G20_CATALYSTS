import Link from "next/link";
import { ArrowRight, BarChart3, CalendarDays, PackageCheck, ShieldCheck, Users } from "lucide-react";
import { adminMetrics } from "@/lib/demoData";
import { asset } from "@/lib/basePath";

const adminModules = [
  ["Users", "/admin/users", Users],
  ["Vendors", "/admin/vendors", ShieldCheck],
  ["Products", "/admin/products", PackageCheck],
  ["Bookings", "/admin/bookings", CalendarDays],
  ["Analytics", "/admin/analytics", BarChart3],
  ["Settings", "/admin/settings", ShieldCheck]
] as const;

export default function AdminDashboardPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-30" style={{ backgroundImage: `url(${asset("/images/hologram-hub/hologram-hub.png")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-brand-deep/78 to-brand-deep/35" />
        <div className="relative mx-auto min-h-[360px] max-w-[1800px] px-6 py-16 text-white md:px-20">
          <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">Admin</p>
          <h1 className="mt-5 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl">Platform operations dashboard</h1>
          <p className="mt-5 max-w-2xl text-lg leading-8 text-white/82">
            Showcase moderation, approvals, booking oversight and platform controls in a unified operations view.
          </p>
        </div>
      </section>

      <section className="mx-auto max-w-[1800px] px-6 py-12 md:px-20">
        <div className="grid gap-5 md:grid-cols-4">
          {adminMetrics.map((metric) => (
            <article key={metric.label} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
              <p className="text-sm font-black uppercase tracking-[0.18em] text-brand-terracotta">{metric.label}</p>
              <p className="mt-3 font-serif text-4xl font-black text-brand-deep">{metric.value}</p>
              <p className="mt-2 text-sm text-brand-deep/65">{metric.detail}</p>
            </article>
          ))}
        </div>

        <div className="mt-8 grid gap-4 md:grid-cols-3">
          {adminModules.map(([label, href, Icon]) => (
            <Link key={href} href={href} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
              <Icon className="text-brand-terracotta" size={26} />
              <h2 className="mt-4 font-serif text-3xl font-black text-brand-deep">{label}</h2>
              <p className="mt-3 flex items-center gap-2 font-bold text-brand-forest">Open workflow <ArrowRight size={16} /></p>
            </Link>
          ))}
        </div>
      </section>
    </main>
  );
}
