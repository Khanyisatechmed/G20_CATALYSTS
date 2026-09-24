import type { MapCategory } from "@/lib/mapPlaces";

// Kept separate from LeafletMap so server-rendered UI can use the colours without importing Leaflet.
export const categoryColours: Record<MapCategory, string> = {
  "Heritage Sites": "#315D42",
  Museums: "#254D38",
  "Nature & Landscapes": "#6F8F62",
  "Cultural Experiences": "#C8754B",
  "Markets & Food": "#B8893B",
  "Artisans & Vendors": "#7F3B25"
};
