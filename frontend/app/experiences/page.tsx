import Link from "next/link";
import { ArrowRight, BookOpen, GraduationCap, Mountain, PlayCircle, Users } from "lucide-react";
import ImageStoryCard from "@/components/ImageStoryCard";
import MockupHero from "@/components/MockupHero";

const featured = [
  { title: "Rain Queen Hologram", subtitle: "Immersive storytelling", href: "/hologram-hub", image: "/images/hologram-hub/hologram-hub.png" },
  { title: "Cultural Village Tour", subtitle: "Living traditions", href: "/heritage/balobedu", image: "/images/heritage/emakhosini.png" },
  { title: "Nature Heritage Trail", subtitle: "Sacred landscapes", href: "/explore/map", image: "/images/provinces/mpumalanga.png" },
  { title: "Craft Workshop", subtitle: "Hands-on learning", href: "/marketplace", image: "/images/zulunecklace.png" }
];

const types = [
  { label: "Museum Experiences", Icon: PlayCircle },
  { label: "Community Visits", Icon: Users },
  { label: "School Programmes", Icon: GraduationCap },
  { label: "Nature & Heritage", Icon: Mountain },
  { label: "Story Archives", Icon: BookOpen }
];

export default function ExperiencesPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Experiences"
        title="Stories You Can Step Into"
        subtitle="Browse immersive museum moments, community-hosted visits, cultural workshops and nature-linked heritage routes across South Africa."
        image="/images/hologram-hub/hologram-hub.png"
        note={"Immersive.\nEducational.\nUnforgettable."}
        primary={{ label: "Book Hologram Hub", href: "/bookings/hologram" }}
        secondary={{ label: "Watch Preview", href: "/hologram-hub" }}
      />

      <section className="border-b border-brand-sage/25 bg-[#f3efe3]">
        <div className="mx-auto grid max-w-[1800px] gap-3 px-6 py-5 md:grid-cols-5 md:px-20">
          {types.map(({ label, Icon }) => (
            <button key={label} className="flex items-center gap-3 rounded-xl bg-white px-5 py-4 text-left font-bold text-brand-deep shadow-sm">
              <Icon className="text-brand-terracotta" size={24} /> {label}
            </button>
          ))}
        </div>
      </section>

      <section className="mx-auto max-w-[1800px] px-6 py-12 md:px-20">
        <div className="flex items-end justify-between gap-4">
          <div>
            <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Featured</p>
            <h1 className="mt-2 font-serif text-5xl font-black text-brand-deep">Cultural experiences</h1>
          </div>
          <Link href="/plan-your-visit" className="hidden items-center gap-2 font-bold text-brand-deep md:flex">
            Add to itinerary <ArrowRight size={17} />
          </Link>
        </div>
        <div className="mt-8 grid gap-5 md:grid-cols-4">
          {featured.map((item) => <ImageStoryCard key={item.title} {...item} />)}
        </div>
      </section>
    </main>
  );
}
