import Link from "next/link";
import Image from "next/image";
import { Suspense } from "react";
import HeritageExplorer from "@/components/HeritageExplorer";
import MockupHero from "@/components/MockupHero";
import { heritageEntries } from "@/lib/content";

export default function HeritagePage() {
  return (
    <main className="bg-brand-ivory">
      <MockupHero
        eyebrow="Our Heritage"
        title="Diverse Peoples. Shared Stories."
        subtitle="Explore South Africa’s rich cultural heritage, from ancient kingdoms to vibrant living traditions. Discover the people, places, languages and experiences that make our nation extraordinary."
        image="/images/hero/south-africa-heritage.jpg"
        note={"One Country.\nMany Cultures.\nCountless Stories."}
      />

      <Suspense>
        <HeritageExplorer />
      </Suspense>

      <section className="bg-white/70">
        <div className="mx-auto grid max-w-[1800px] items-center gap-8 px-6 py-8 md:grid-cols-[1fr_1.2fr_240px] md:px-20">
          <div className="relative hidden min-h-48 overflow-hidden rounded-r-[6rem] md:block">
            <Image
              src="/images/provinces/western-cape.png"
              alt="South African province landscape"
              fill
              className="object-cover"
            />
          </div>
          <div>
            <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">
              Explore by Province
            </p>
            <h2 className="font-serif text-4xl font-black text-brand-deep">
              Discover South Africa’s Nine Provinces
            </h2>
            <p className="mt-2 text-brand-deep/70">
              From coastal beauty to mountain ranges, each province has its own
              unique heritage, cultures, cuisine and experiences waiting to be explored.
            </p>
          </div>
          <Link href="/provinces" className="rounded-xl bg-brand-forest px-6 py-3 text-center font-bold text-white">
            Explore Provinces →
          </Link>
        </div>
      </section>

      <section className="mx-auto max-w-[1800px] px-6 py-8 md:px-20">
        <details className="text-xs text-brand-deep/70">
          <summary className="cursor-pointer font-semibold text-brand-deep">Photo credits</summary>
          <ul className="mt-3 grid gap-1 md:grid-cols-2">
            {heritageEntries
              .filter((entry) => entry.imageCredit)
              .map((entry) => (
                <li key={entry.slug}>
                  {entry.title}: {entry.imageCaption} by{" "}
                  {entry.imageCredit!.sourceUrl ? (
                    <a href={entry.imageCredit!.sourceUrl} target="_blank" rel="noreferrer" className="underline">
                      {entry.imageCredit!.author}
                    </a>
                  ) : (
                    entry.imageCredit!.author
                  )}
                  , {entry.imageCredit!.license}
                  {entry.imageCredit!.sourceUrl?.includes("wikimedia.org") ? " via Wikimedia Commons" : ""}
                </li>
              ))}
          </ul>
        </details>
      </section>
    </main>
  );
}
