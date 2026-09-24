"use client";

import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { useState } from "react";
import { Search } from "lucide-react";
import ImageStoryCard from "@/components/ImageStoryCard";
import { heritageEntries, provinces, type HeritageType } from "@/lib/content";

const categoryFilters: { label: string; slug: string; type: HeritageType }[] = [
  { label: "Cultural Communities", slug: "cultural-communities", type: "Cultural community" },
  { label: "Historical Kingdoms", slug: "historical-kingdoms", type: "Historical kingdom" },
  { label: "Indigenous Heritage", slug: "indigenous-heritage", type: "Indigenous heritage" },
  { label: "Heritage Sites", slug: "heritage-sites", type: "Heritage destination" }
];

function filterHref(province?: string, category?: string) {
  const params = new URLSearchParams();
  if (province) params.set("province", province);
  if (category) params.set("category", category);
  const query = params.toString();
  return query ? `/heritage?${query}#explore` : "/heritage#explore";
}

// Filters live in the URL (?province=…&category=…) so they can be shared and work on a static host.
export default function HeritageExplorer() {
  const searchParams = useSearchParams();
  const [query, setQuery] = useState("");
  const activeProvince = provinces.find((province) => province.slug === searchParams.get("province"));
  const activeCategory = categoryFilters.find((category) => category.slug === searchParams.get("category"));
  const term = query.trim().toLowerCase();

  const heritageGrid = heritageEntries
    .filter((entry) => !activeProvince || entry.provinces.includes(activeProvince.name))
    .filter((entry) => !activeCategory || entry.type === activeCategory.type)
    .filter(
      (entry) =>
        !term ||
        [entry.title, entry.subtitle, entry.language, entry.summary, ...entry.provinces, ...entry.knownFor].some((text) =>
          text.toLowerCase().includes(term)
        )
    )
    .map((entry) => ({
      title: entry.title,
      subtitle: entry.subtitle,
      href: `/heritage/${entry.slug}`,
      image: entry.image,
      alt: entry.imageAlt,
      imagePosition: entry.imagePosition,
      location: entry.provinces.join(" · "),
      tags: [entry.type]
    }));

  const provinceLinks = [
    { label: "All Provinces", slug: "", href: filterHref(undefined, activeCategory?.slug), active: !activeProvince },
    ...provinces.map((province) => ({
      label: province.name,
      slug: province.slug,
      href: filterHref(province.slug, activeCategory?.slug),
      active: activeProvince?.slug === province.slug
    }))
  ];

  return (
    <>
      <section className="border-b border-brand-sage/25 bg-brand-ivory py-5">
        <form
          role="search"
          onSubmit={(event) => event.preventDefault()}
          className="mx-auto max-w-[1800px] px-6 md:px-20"
        >
          <label className="relative block">
            <span className="sr-only">Search heritage</span>
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-brand-deep/70" size={21} />
            <input
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Search communities, languages, traditions or provinces…"
              className="w-full rounded-xl border border-brand-sage/35 bg-white px-12 py-4 shadow-sm outline-none focus:border-brand-terracotta"
            />
          </label>
        </form>
      </section>

      <section
        id="explore"
        className="relative mx-auto grid max-w-[1800px] scroll-mt-32 gap-8 px-6 py-8 md:grid-cols-[270px_1fr] md:px-20"
      >
        <aside className="hidden border-r border-brand-sage/30 pr-6 md:block">
          <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Browse by Province</p>
          <div className="mt-4 grid gap-1">
            {provinceLinks.map((link) => (
              <Link
                key={link.label}
                href={link.href}
                scroll={false}
                aria-current={link.active ? "page" : undefined}
                className={[
                  "rounded-lg px-4 py-2 text-left text-sm font-semibold",
                  link.active ? "bg-brand-forest text-white" : "text-brand-deep/75 hover:bg-white"
                ].join(" ")}
              >
                {link.label}
              </Link>
            ))}
          </div>
          <p className="mt-8 text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Browse by Category</p>
          <div className="mt-4 grid gap-1">
            {categoryFilters.map((category) => {
              const isActive = activeCategory?.slug === category.slug;
              return (
                <Link
                  key={category.slug}
                  href={filterHref(activeProvince?.slug, isActive ? undefined : category.slug)}
                  scroll={false}
                  aria-current={isActive ? "page" : undefined}
                  className={[
                    "rounded-lg px-4 py-2 text-left text-sm font-semibold",
                    isActive ? "bg-brand-forest text-white" : "text-brand-deep/75 hover:bg-white"
                  ].join(" ")}
                >
                  {category.label}
                </Link>
              );
            })}
          </div>
        </aside>

        {/* min-w-0 stops the scrollable chip row from stretching this grid column on phones. */}
        <div className="min-w-0">
          <nav aria-label="Filter by province" className="-mx-6 mb-3 flex gap-2 overflow-x-auto px-6 pb-2 md:hidden">
            {provinceLinks.map((link) => (
              <Link
                key={link.label}
                href={link.href}
                scroll={false}
                aria-current={link.active ? "page" : undefined}
                className={[
                  "shrink-0 whitespace-nowrap rounded-full border px-4 py-2 text-sm font-semibold",
                  link.active ? "border-brand-forest bg-brand-forest text-white" : "border-brand-sage/40 bg-white text-brand-deep"
                ].join(" ")}
              >
                {link.label}
              </Link>
            ))}
          </nav>
          <nav aria-label="Filter by category" className="-mx-6 mb-6 flex gap-2 overflow-x-auto px-6 pb-2 md:hidden">
            {categoryFilters.map((category) => {
              const isActive = activeCategory?.slug === category.slug;
              return (
                <Link
                  key={category.slug}
                  href={filterHref(activeProvince?.slug, isActive ? undefined : category.slug)}
                  scroll={false}
                  aria-current={isActive ? "page" : undefined}
                  className={[
                    "shrink-0 whitespace-nowrap rounded-full border px-4 py-2 text-sm font-semibold",
                    isActive ? "border-brand-terracotta bg-brand-terracotta text-white" : "border-brand-sage/40 bg-white text-brand-deep"
                  ].join(" ")}
                >
                  {category.label}
                </Link>
              );
            })}
          </nav>

          <h2 className="font-serif text-3xl font-black text-brand-deep sm:text-4xl">
            {activeProvince ? `Heritage of ${activeProvince.name}` : "Explore Our Heritage"}
          </h2>
          <p className="mt-2 text-sm text-brand-deep/70">
            {heritageGrid.length} {heritageGrid.length === 1 ? "entry" : "entries"}
            {activeCategory ? ` in ${activeCategory.label}` : ""}. Communities are shown in the provinces where they are most
            rooted; people of every heritage live across South Africa.
          </p>

          <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {heritageGrid.map((entry) => (
              <ImageStoryCard key={entry.href} {...entry} />
            ))}
          </div>
          {heritageGrid.length === 0 ? (
            <p className="mt-6 rounded-xl border border-brand-sage/30 bg-white p-6 text-brand-deep/75">
              No entries match your filters.{" "}
              <Link href="/heritage#explore" scroll={false} onClick={() => setQuery("")} className="font-bold text-brand-forest underline">
                Show everything
              </Link>
            </p>
          ) : null}
        </div>
      </section>
    </>
  );
}
