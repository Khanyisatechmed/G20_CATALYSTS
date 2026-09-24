import Image from "next/image";
import Link from "next/link";
import { ArrowRight, Play } from "lucide-react";

type MockupHeroProps = {
  eyebrow: string;
  title: string;
  subtitle: string;
  image: string;
  note?: string;
  primary?: { label: string; href: string };
  secondary?: { label: string; href: string };
};

export default function MockupHero({
  eyebrow,
  title,
  subtitle,
  image,
  note,
  primary,
  secondary
}: MockupHeroProps) {
  return (
    <section className="relative -mt-6 min-h-[430px] overflow-hidden">
      <Image src={image} alt={title} fill priority className="object-cover" />
      <div className="absolute inset-0 bg-gradient-to-r from-black/80 via-black/40 to-black/10" />
      {/* On phones the text spans the full width, so darken the whole image for contrast. */}
      <div className="absolute inset-0 bg-black/45 md:hidden" />
      <div className="absolute inset-y-0 left-0 w-32 bg-[linear-gradient(135deg,rgba(248,245,236,0.16)_25%,transparent_25%,transparent_50%,rgba(248,245,236,0.16)_50%,rgba(248,245,236,0.16)_75%,transparent_75%)] bg-[length:38px_38px] opacity-35" />
      <div className="relative mx-auto grid min-h-[430px] max-w-[1800px] items-center gap-8 px-6 py-16 md:grid-cols-[1fr_0.62fr] md:px-20">
        <div>
          <p className="text-xs font-black uppercase tracking-[0.3em] text-white/90 sm:text-sm md:tracking-[0.48em]">
            {eyebrow}
          </p>
          <h1 className="mt-4 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] text-white sm:text-6xl md:text-7xl md:leading-[0.9]">
            {title}
          </h1>
          <p className="mt-6 max-w-2xl text-lg leading-8 text-white/90">
            {subtitle}
          </p>
          {(primary || secondary) ? (
            <div className="mt-8 flex flex-wrap gap-4">
              {primary ? (
                <Link
                  href={primary.href}
                  className="inline-flex items-center gap-3 rounded-xl bg-brand-forest px-7 py-3 font-bold text-white"
                >
                  {primary.label} <ArrowRight size={18} />
                </Link>
              ) : null}
              {secondary ? (
                <Link
                  href={secondary.href}
                  className="inline-flex items-center gap-3 rounded-xl border border-white/80 bg-black/20 px-7 py-3 font-bold text-white backdrop-blur"
                >
                  <span className="grid h-8 w-8 place-items-center rounded-full bg-white text-brand-deep">
                    <Play size={16} fill="currentColor" />
                  </span>
                  {secondary.label}
                </Link>
              ) : null}
            </div>
          ) : null}
        </div>

        {note ? (
          <p className="hidden -rotate-6 justify-self-end whitespace-pre-line pr-8 text-right font-serif text-3xl italic leading-tight text-white drop-shadow-xl md:block md:text-4xl">
            {note}
          </p>
        ) : null}
      </div>
    </section>
  );
}
