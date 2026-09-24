import Link from "next/link";
import { ArrowRight, BadgeCheck, MapPin, PackageCheck, ShieldCheck, Store } from "lucide-react";
import MockupHero from "@/components/MockupHero";
import { demoVendors } from "@/lib/demoData";

export function generateStaticParams() {
  return demoVendors.map((vendor) => ({ slug: vendor.slug }));
}

export default async function VendorDetailPage({
  params
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const vendor = demoVendors.find((item) => item.slug === slug);

  if (!vendor) return null;

  const image = vendor.products[0]?.imageUrl ?? "/images/zulubasket.png";
  const facts = [
    ["Province", vendor.province],
    ["Town", vendor.town],
    ["Category", vendor.category],
    ["Public location", vendor.locationLabel],
    ["Approval status", vendor.status],
    ["Privacy note", "No private residential addresses are shown."]
  ];

  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Vendor Profile"
        title={vendor.businessName}
        subtitle={`${vendor.artisanName} represents a demo public vendor profile for discovery, marketplace and map workflows.`}
        image={image}
        note={"Craft.\nTrust.\nCommunity."}
      />

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-12 md:grid-cols-[1fr_380px] md:px-20">
        <div>
          <div className="grid gap-5 md:grid-cols-3">
            {facts.map(([label, value]) => (
              <article key={label} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
                <p className="text-sm font-black uppercase tracking-[0.2em] text-brand-terracotta">{label}</p>
                <p className="mt-3 leading-7 text-brand-deep/75">{value}</p>
              </article>
            ))}
          </div>

          <section className="mt-8 rounded-xl border border-brand-sage/30 bg-white p-8 shadow-sm">
            <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Marketplace Link</p>
            <h2 className="mt-3 font-serif text-4xl font-black text-brand-deep">Products and cultural context</h2>
            <p className="mt-4 max-w-3xl leading-8 text-brand-deep/72">
              Vendor product listings are designed to connect craft details, cultural significance, 3D previews and fulfilment status once production data is connected.
            </p>
            <div className="mt-6 flex flex-wrap gap-3">
              <Link href="/marketplace" className="inline-flex items-center gap-2 rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
                Browse Marketplace <ArrowRight size={17} />
              </Link>
              <Link href="/explore/map" className="inline-flex items-center gap-2 rounded-xl border border-brand-sage/40 bg-brand-ivory px-6 py-3 font-bold text-brand-deep">
                View on Map <MapPin size={17} />
              </Link>
            </div>
          </section>
        </div>

        <aside className="grid content-start gap-5">
          <article className="rounded-xl bg-brand-deep p-6 text-white">
            <BadgeCheck className="text-brand-sand" size={34} />
            <h2 className="mt-5 font-serif text-3xl font-black">Vendor status</h2>
            <p className="mt-3 font-bold text-brand-sand">{vendor.status}</p>
            <p className="mt-4 leading-7 text-white/75">Production profiles should include verification records, moderation history and explicit public-location consent.</p>
          </article>
          {[
            ["Public listing", Store],
            ["Product approval", PackageCheck],
            ["Cultural review", ShieldCheck]
          ].map(([label, Icon]) => (
            <article key={label as string} className="flex items-center gap-4 rounded-xl bg-white p-5 shadow-sm">
              <div className="grid h-12 w-12 place-items-center rounded-lg bg-brand-ivory text-brand-terracotta">
                <Icon size={22} />
              </div>
              <p className="font-bold text-brand-deep">{label as string}</p>
            </article>
          ))}
        </aside>
      </section>
    </main>
  );
}
