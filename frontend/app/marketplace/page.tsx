import Image from "next/image";
import Link from "next/link";
import {
  Heart,
  PackageCheck,
  Search,
  ShieldCheck,
  ShoppingBasket,
  Star,
  Truck,
  UsersRound
} from "lucide-react";
import ActionStrip from "@/components/ActionStrip";
import Marketplace3DShowcase from "@/components/Marketplace3DShowcase";
import MockupHero from "@/components/MockupHero";
import { marketplaceProducts } from "@/lib/products";

const marketplaceActions = [
  {
    title: "Authentic Products",
    subtitle: "Direct from local artisans",
    href: "/marketplace",
    icon: ShoppingBasket
  },
  {
    title: "Support Local Communities",
    subtitle: "Empowering sustainable livelihoods",
    href: "/vendors",
    icon: UsersRound
  },
  {
    title: "Nationwide Delivery",
    subtitle: "Across South Africa",
    href: "/checkout",
    icon: Truck
  },
  {
    title: "Cultural Significance",
    subtitle: "Products with a story",
    href: "/heritage",
    icon: PackageCheck
  },
  {
    title: "Verified Vendors",
    subtitle: "Trusted and approved",
    href: "/vendors",
    icon: ShieldCheck
  }
];

const categoryFilters = [
  "All Products",
  "Beadwork",
  "Pottery & Ceramics",
  "Traditional Clothing",
  "Textiles & Fabrics",
  "Home Decor",
  "Art & Carvings",
  "Handmade Crafts",
  "Cultural Gifts",
  "Food Products"
];

const provinceFilters = [
  ["Eastern Cape", 24],
  ["Free State", 18],
  ["Gauteng", 32],
  ["KwaZulu-Natal", 45],
  ["Limpopo", 38],
  ["Mpumalanga", 20],
  ["Northern Cape", 12],
  ["North West", 15],
  ["Western Cape", 28]
];

const showcaseProducts = [
  ...marketplaceProducts,
  {
    id: "balobedu-necklace",
    title: "Balobedu Beaded Necklace",
    artisan: "Modjadji Artisans",
    price: 980,
    currency: "ZAR" as const,
    imageUrl: "/images/zulunecklace.png",
    modelUrl: "",
    region: "Limpopo",
    materials: ["glass beads"],
    description: "Demo beaded necklace product for marketplace showcase.",
    culturalSignificance: "Cultural notes require reviewed vendor input."
  },
  {
    id: "tsonga-basket",
    title: "Tsonga Handwoven Basket",
    artisan: "Tsonga Weaves",
    price: 720,
    currency: "ZAR" as const,
    imageUrl: "/images/zulubasket.png",
    modelUrl: "",
    region: "Mpumalanga",
    materials: ["woven fibre"],
    description: "Demo basket product for marketplace showcase.",
    culturalSignificance: "Cultural notes require reviewed vendor input."
  },
  {
    id: "ndebele-wall-hanging",
    title: "Ndebele Wall Hanging",
    artisan: "Ndebele Creations",
    price: 1100,
    currency: "ZAR" as const,
    imageUrl: "/images/zulushield.png",
    modelUrl: "",
    region: "Gauteng",
    materials: ["textile"],
    description: "Demo wall hanging product for marketplace showcase.",
    culturalSignificance: "Cultural notes require reviewed vendor input."
  },
  {
    id: "xhosa-sculpture",
    title: "Xhosa Wooden Sculpture",
    artisan: "Ubuntu Crafts",
    price: 1450,
    currency: "ZAR" as const,
    imageUrl: "/images/shakaimage.png",
    modelUrl: "",
    region: "Eastern Cape",
    materials: ["wood"],
    description: "Demo sculpture product for marketplace showcase.",
    culturalSignificance: "Cultural notes require reviewed vendor input."
  },
  {
    id: "pedi-earrings",
    title: "Pedi Beaded Earrings",
    artisan: "Pedi Artisans",
    price: 450,
    currency: "ZAR" as const,
    imageUrl: "/images/zulunecklace.png",
    modelUrl: "",
    region: "Limpopo",
    materials: ["glass beads"],
    description: "Demo earrings product for marketplace showcase.",
    culturalSignificance: "Cultural notes require reviewed vendor input."
  },
  {
    id: "sotho-grass-mat",
    title: "Sotho Grass Mat",
    artisan: "Thabo Traditional Crafts",
    price: 680,
    currency: "ZAR" as const,
    imageUrl: "/images/zulubasket.png",
    modelUrl: "",
    region: "Free State",
    materials: ["grass fibre"],
    description: "Demo grass mat product for marketplace showcase.",
    culturalSignificance: "Cultural notes require reviewed vendor input."
  }
];

export default function MarketplacePage() {
  return (
    <main className="bg-brand-ivory">
      <MockupHero
        eyebrow="Cultural Marketplace"
        title="Authentic Craft. Real People. Lasting Impact."
        subtitle="Discover unique, high-quality products from talented artisans and local communities across South Africa. Every purchase supports culture, community and sustainable livelihoods."
        image="/images/marketplace/zulu-hat.png"
        note={"Support\nLocal Artisans.\nCelebrate\nSouth Africa."}
        primary={{ label: "Shop the Marketplace", href: "#products" }}
      />

      <ActionStrip items={marketplaceActions} />

      <section className="border-b border-brand-sage/25 bg-brand-ivory py-5">
        <div className="mx-auto grid max-w-[1800px] gap-4 px-6 sm:grid-cols-2 md:px-16 lg:grid-cols-4 2xl:grid-cols-[1fr_170px_220px_220px_220px_240px]">
          <div className="relative sm:col-span-2 lg:col-span-3 2xl:col-span-1">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-black" size={21} />
            <input
              placeholder="Search for products, artisans or cultural crafts..."
              className="w-full rounded-xl border border-brand-sage/35 bg-white px-12 py-4 shadow-sm outline-none focus:border-brand-terracotta"
            />
          </div>
          <button className="rounded-xl bg-brand-forest px-6 py-4 font-bold text-white">
            Search →
          </button>
          <select className="rounded-xl border border-brand-sage/35 bg-white px-5 py-4 shadow-sm">
            <option>All Provinces</option>
          </select>
          <select className="rounded-xl border border-brand-sage/35 bg-white px-5 py-4 shadow-sm">
            <option>All Cultures</option>
          </select>
          <select className="rounded-xl border border-brand-sage/35 bg-white px-5 py-4 shadow-sm">
            <option>All Categories</option>
          </select>
          <select className="rounded-xl border border-brand-sage/35 bg-white px-5 py-4 shadow-sm">
            <option>Featured</option>
          </select>
        </div>
      </section>

      <section id="products" className="mx-auto grid max-w-[1800px] gap-8 px-6 py-8 md:grid-cols-[220px_minmax(0,1fr)] 2xl:grid-cols-[270px_minmax(0,1fr)_360px] md:px-16">
        <aside className="hidden border-r border-brand-sage/30 pr-6 md:block">
          <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">
            Categories
          </p>
          <div className="mt-4 grid gap-1">
            {categoryFilters.map((filter, index) => (
              <button
                key={filter}
                className={[
                  "rounded-lg px-4 py-2 text-left text-sm font-semibold",
                  index === 0
                    ? "bg-brand-forest text-white"
                    : "text-brand-deep/75 hover:bg-white"
                ].join(" ")}
              >
                {filter}
              </button>
            ))}
          </div>
          <p className="mt-8 text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">
            Filter by Province
          </p>
          <div className="mt-4 grid gap-2">
            {provinceFilters.map(([province, count]) => (
              <label key={province} className="flex items-center justify-between gap-3 text-sm text-brand-deep/75">
                <span className="flex items-center gap-2">
                  <input type="checkbox" /> {province}
                </span>
                <span>({count})</span>
              </label>
            ))}
          </div>
        </aside>

        <div>
          <div className="flex items-center justify-between">
            <h2 className="font-serif text-4xl font-black text-brand-deep">
              Featured Products
            </h2>
            <Link href="/marketplace" className="hidden font-bold text-brand-deep md:inline">
              View All Products →
            </Link>
          </div>
          <div className="mt-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-3">
            {showcaseProducts.map((product) => (
              <Link
                key={product.id}
                href={product.modelUrl ? `/marketplace/${product.id}` : "/marketplace/zulu-hat"}
                className="overflow-hidden rounded-xl bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-xl"
              >
                <div className="relative h-48">
                  <Image src={product.imageUrl} alt={product.title} fill className="object-cover" />
                  <span className="absolute left-3 top-3 rounded-full bg-brand-sand px-3 py-1 text-xs font-bold text-brand-deep">
                    {product.region}
                  </span>
                  <Heart className="absolute right-3 top-3 text-white drop-shadow" />
                </div>
                <div className="p-4">
                  <h3 className="font-serif text-xl font-black text-brand-deep">{product.title}</h3>
                  <p className="text-sm text-brand-deep/65">by {product.artisan}</p>
                  <div className="mt-2 flex items-center gap-1 text-brand-terracotta">
                    {Array.from({ length: 5 }).map((_, index) => (
                      <Star key={index} size={14} fill="currentColor" />
                    ))}
                    <span className="ml-2 text-xs text-brand-deep/60">(demo)</span>
                  </div>
                  <div className="mt-3 flex items-center justify-between">
                    <strong className="text-xl text-brand-deep">R{product.price.toLocaleString("en-ZA")}</strong>
                    <span className="grid h-10 w-10 place-items-center rounded-full bg-brand-forest text-white">
                      <ShoppingBasket size={18} />
                    </span>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>

        <Marketplace3DShowcase className="md:col-span-2 2xl:col-span-1" />
      </section>
    </main>
  );
}
