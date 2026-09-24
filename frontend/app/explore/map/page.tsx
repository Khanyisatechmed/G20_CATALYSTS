import Link from "next/link";
import ImageStoryCard from "@/components/ImageStoryCard";
import MockupHero from "@/components/MockupHero";
import ExploreMap from "@/components/ExploreMap";

const popularDestinations = [
  { title: "Blyde River Canyon", location: "Mpumalanga", image: "/images/provinces/mpumalanga.png" },
  { title: "Mapungubwe", location: "Limpopo", image: "/images/heritage/mapungubwe.jpg" },
  { title: "Drakensberg", location: "KwaZulu-Natal", image: "/images/heritage/emakhosini.png" },
  { title: "Addo Elephant National Park", location: "Eastern Cape", image: "/images/hero/south-africa-heritage.jpg" },
  { title: "Cape Winelands", location: "Western Cape", image: "/images/provinces/western-cape.png" }
];

export default function ExploreMapPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <MockupHero
        eyebrow="Explore Nearby"
        title="Discover Hidden Gems Across South Africa"
        subtitle="Find local artisans, cultural experiences, traditional food, heritage sites and markets wherever you are."
        image="/images/hero/south-africa-heritage.jpg"
        note={"Local People.\nAuthentic Experiences.\nReal Stories."}
      />

      <ExploreMap />

      <section className="mx-auto max-w-[1800px] px-6 pb-12 md:px-20">
        <div className="flex items-center justify-between">
          <h2 className="font-serif text-3xl font-black text-brand-deep">Popular Nearby Destinations</h2>
          <Link href="/provinces" className="hidden font-bold text-brand-deep md:inline">View All Destinations -&gt;</Link>
        </div>
        <div className="mt-5 grid gap-4 md:grid-cols-5">
          {popularDestinations.map((destination) => (
            <ImageStoryCard
              key={destination.title}
              title={destination.title}
              subtitle={destination.location}
              href="/provinces"
              image={destination.image}
            />
          ))}
        </div>
      </section>
    </main>
  );
}
