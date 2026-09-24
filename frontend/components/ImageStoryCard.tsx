import Image from "next/image";
import Link from "next/link";
import { ArrowRight, MapPin } from "lucide-react";

// Branded stand-in for heritage entries still awaiting a verified, credited photograph.
export function HeritagePlaceholder() {
  return (
    <div
      aria-hidden="true"
      className="absolute inset-0 bg-brand-forest bg-[repeating-linear-gradient(45deg,rgba(217,183,123,0.18)_0_2px,transparent_2px_22px),repeating-linear-gradient(-45deg,rgba(200,117,75,0.2)_0_2px,transparent_2px_22px)]"
    />
  );
}

type ImageStoryCardProps = {
  title: string;
  subtitle: string;
  href: string;
  image?: string;
  alt?: string;
  imagePosition?: string;
  location?: string;
  tags?: string[];
};

export default function ImageStoryCard({
  title,
  subtitle,
  href,
  image,
  alt,
  imagePosition,
  location,
  tags = []
}: ImageStoryCardProps) {
  return (
    <Link
      href={href}
      className="group relative flex min-h-[210px] flex-col justify-end overflow-hidden rounded-xl shadow-lg"
    >
      {image ? (
        <Image src={image} alt={alt ?? title} fill sizes="(min-width: 1280px) 22vw, (min-width: 768px) 30vw, 100vw" style={imagePosition ? { objectPosition: imagePosition } : undefined} className="object-cover transition group-hover:scale-105" />
      ) : (
        <HeritagePlaceholder />
      )}
      <div className="absolute inset-0 bg-gradient-to-t from-black via-black/30 to-transparent" />
      <div className="relative p-4 pt-16 text-white">
        <div className="flex items-end justify-between gap-3">
          <span>
            <strong className="block font-serif text-2xl leading-none">{title}</strong>
            <span className="text-sm">{subtitle}</span>
            {location ? (
              <span className="mt-2 flex items-center gap-1 text-xs">
                <MapPin size={13} /> {location}
              </span>
            ) : null}
          </span>
          <span className="grid h-10 w-10 shrink-0 place-items-center rounded-full border border-white">
            <ArrowRight size={18} />
          </span>
        </div>
        {tags.length > 0 ? (
          <div className="mt-3 flex flex-wrap gap-2">
            {tags.map((tag) => (
              <span key={tag} className="rounded-full bg-brand-forest/80 px-3 py-1 text-xs">
                {tag}
              </span>
            ))}
          </div>
        ) : null}
      </div>
    </Link>
  );
}
