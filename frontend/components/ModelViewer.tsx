"use client";

import { useEffect } from "react";
import { asset } from "@/lib/basePath";

type ModelViewerProps = {
  src: string;
  alt: string;
  poster?: string;
  className?: string;
};

export default function ModelViewer({
  src,
  alt,
  poster,
  className = ""
}: ModelViewerProps) {
  useEffect(() => {
    void import("@google/model-viewer");
  }, []);

  return (
    <section
      className={[
        "relative overflow-hidden rounded-xl border border-brand-sage/30",
        "bg-[radial-gradient(circle_at_50%_0%,rgba(71,215,255,0.18),transparent_28%),linear-gradient(145deg,#f8f5ec,#d9b77b_48%,#315d42)]",
        "shadow-xl shadow-brand-sage/25",
        className
      ].join(" ")}
    >
      <model-viewer
        src={asset(src)}
        alt={alt}
        poster={poster ? asset(poster) : undefined}
        ar
        ar-modes="webxr scene-viewer quick-look"
        camera-controls
        auto-rotate
        rotation-per-second="22deg"
        shadow-intensity="1.2"
        exposure="1.08"
        environment-image="neutral"
        camera-orbit="35deg 67deg 3m"
        min-camera-orbit="auto auto 1.6m"
        max-camera-orbit="auto auto 5m"
        field-of-view="31deg"
        touch-action="pan-y"
        loading="lazy"
        reveal="auto"
        className="h-[420px] w-full md:h-[640px]"
      />

      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-32 bg-gradient-to-t from-brand-deep/72 to-transparent" />
      <div className="absolute bottom-5 left-5 rounded-full border border-white/35 bg-brand-deep/70 px-4 py-2 text-xs font-bold uppercase tracking-[0.22em] text-white backdrop-blur-md">
        Rotate / Zoom / AR
      </div>
    </section>
  );
}
