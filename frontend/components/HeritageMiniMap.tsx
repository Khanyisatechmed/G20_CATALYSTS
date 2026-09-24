"use client";

import dynamic from "next/dynamic";
import { useState } from "react";
import type { MapPlace } from "@/lib/mapPlaces";

// Reuses the Explore map so pins, colours and popups match; Leaflet only renders in the browser.
const LeafletMap = dynamic(() => import("@/components/LeafletMap"), {
  ssr: false,
  loading: () => (
    <div className="grid h-full place-items-center bg-[#dce8d3] text-sm font-semibold text-brand-deep/80">Loading map…</div>
  )
});

export default function HeritageMiniMap({ places, initialSelectedId }: { places: MapPlace[]; initialSelectedId: string | null }) {
  const [selectedId, setSelectedId] = useState(initialSelectedId);

  return (
    <div className="relative isolate h-56 overflow-hidden rounded-xl border border-brand-sage/30">
      <LeafletMap places={places} selectedId={selectedId} onSelect={setSelectedId} userLocation={null} />
    </div>
  );
}
