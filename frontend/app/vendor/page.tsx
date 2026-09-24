import Link from "next/link";
import { ArrowRight, BadgeCheck, PackageCheck, ShoppingBag, Store } from "lucide-react";
import { demoOrders, demoVendors } from "@/lib/demoData";
import { marketplaceProducts } from "@/lib/products";
import { asset } from "@/lib/basePath";

export default function VendorDashboardPage() {
  const vendor = demoVendors[1];

  const cards = [
    { title: "Profile status", value: vendor.status, href: "/vendor/profile", Icon: BadgeCheck },
    { title: "Products", value: `${marketplaceProducts.length} items`, href: "/vendor/products", Icon: PackageCheck },
    { title: "Orders", value: `${demoOrders.length} draft`, href: "/vendor/orders", Icon: ShoppingBag }
  ];

  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-30" style={{ backgroundImage: `url(${asset("/images/claypot.png")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-brand-deep/78 to-brand-deep/35" />
        <div className="relative mx-auto min-h-[360px] max-w-[1800px] px-6 py-16 text-white md:px-20">
          <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">Vendor Dashboard</p>
          <h1 className="mt-5 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl">{vendor.businessName}</h1>
          <p className="mt-5 max-w-2xl text-lg leading-8 text-white/82">
            Manage product readiness, order fulfilment and public vendor profile quality from one demo workspace.
          </p>
        </div>
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-12 md:grid-cols-[1fr_380px] md:px-20">
        <div className="grid gap-5 md:grid-cols-3">
          {cards.map(({ title, value, href, Icon }) => (
            <Link key={href} href={href} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
              <Icon className="text-brand-terracotta" size={28} />
              <h2 className="mt-4 font-serif text-3xl font-black text-brand-deep">{title}</h2>
              <p className="mt-3 font-bold text-brand-forest">{value}</p>
              <p className="mt-4 flex items-center gap-2 text-sm font-bold text-brand-deep">Manage <ArrowRight size={16} /></p>
            </Link>
          ))}
        </div>

        <aside className="rounded-xl bg-brand-deep p-6 text-white">
          <Store className="text-brand-sand" size={32} />
          <h2 className="mt-4 font-serif text-3xl font-black">Public listing</h2>
          <p className="mt-4 leading-7 text-white/75">{vendor.locationLabel}</p>
          <Link href={`/vendors/${vendor.slug}`} className="mt-6 inline-flex items-center gap-2 rounded-xl bg-brand-sand px-5 py-3 font-bold text-brand-deep">
            View profile <ArrowRight size={17} />
          </Link>
        </aside>
      </section>
    </main>
  );
}
