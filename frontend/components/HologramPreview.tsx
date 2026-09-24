"use client";

import Image from "next/image";
import { useRef } from "react";
import { asset } from "@/lib/basePath";
import { rainQueenPoster, rainQueenVideo } from "@/lib/hologramMedia";

const chapters = [
  { time: 1.6, image: "/images/hologram-hub/rain-queen-frame-1.jpg", label: "Museum entrance hall" },
  { time: 5.6, image: "/images/hologram-hub/rain-queen-frame-2.jpg", label: "Hologram stage and galleries" },
  { time: 9.6, image: "/images/hologram-hub/rain-queen-frame-3.jpg", label: "Two-storey atrium" },
  { time: 13.6, image: "/images/hologram-hub/rain-queen-frame-4.jpg", label: "The Rain Queen appears" },
  { time: 17.6, image: "/images/hologram-hub/rain-queen-frame-5.jpg", label: "Storytelling with visitors" }
];

export default function HologramPreview() {
  const videoRef = useRef<HTMLVideoElement>(null);

  function playFrom(time: number) {
    const video = videoRef.current;
    if (!video) return;
    video.currentTime = time;
    void video.play().catch(() => {});
  }

  return (
    <>
      <div className="overflow-hidden rounded-xl bg-black shadow-xl">
        <video
          ref={videoRef}
          src={asset(rainQueenVideo)}
          poster={asset(rainQueenPoster)}
          controls
          playsInline
          preload="metadata"
          className="aspect-video w-full object-cover"
        />
      </div>
      <div className="mt-3 grid grid-cols-5 gap-2">
        {chapters.map((chapter) => (
          <button
            key={chapter.image}
            type="button"
            onClick={() => playFrom(chapter.time)}
            aria-label={`Play from: ${chapter.label}`}
            title={chapter.label}
            className="relative h-20 overflow-hidden rounded-lg outline-none ring-brand-terracotta transition hover:opacity-85 focus-visible:ring-2"
          >
            <Image src={chapter.image} alt="" fill sizes="10vw" className="object-cover" />
          </button>
        ))}
      </div>
    </>
  );
}
