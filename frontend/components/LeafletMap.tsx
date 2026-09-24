"use client";

import "leaflet/dist/leaflet.css";
import L from "leaflet";
import Link from "next/link";
import { useEffect, useMemo } from "react";
import { CircleMarker, MapContainer, Marker, Popup, TileLayer, useMap } from "react-leaflet";
import { categoryColours } from "@/components/mapColours";
import type { MapPlace } from "@/lib/mapPlaces";

const SOUTH_AFRICA_BOUNDS: L.LatLngBoundsExpression = [
  [-35.2, 16.3],
  [-22.0, 33.0]
];

function pinIcon(colour: string, selected: boolean) {
  const size = selected ? 38 : 30;
  return L.divIcon({
    className: "",
    iconSize: [size, size],
    iconAnchor: [size / 2, size],
    popupAnchor: [0, -size + 4],
    html: `<svg width="${size}" height="${size}" viewBox="0 0 24 24" style="filter:drop-shadow(0 2px 3px rgba(0,0,0,.35))"><path fill="${colour}" stroke="#fff" stroke-width="1.5" d="M12 2a7 7 0 0 0-7 7c0 5.25 7 13 7 13s7-7.75 7-13a7 7 0 0 0-7-7z"/><circle cx="12" cy="9" r="2.6" fill="#fff"/></svg>`
  });
}

function FitToPlaces({ places, selectedId, visible }: { places: MapPlace[]; selectedId: string | null; visible: boolean }) {
  const map = useMap();
  const key = places.map((place) => place.id).join(",");

  // Leaflet measures its container once; re-measure after the map is shown again.
  useEffect(() => {
    if (visible) map.invalidateSize();
  }, [visible, map]);

  useEffect(() => {
    if (places.length === 0) {
      map.fitBounds(SOUTH_AFRICA_BOUNDS);
    } else if (places.length === 1) {
      map.setView([places[0].lat, places[0].lng], 10);
    } else {
      map.fitBounds(L.latLngBounds(places.map((place) => [place.lat, place.lng])), { padding: [40, 40], maxZoom: 11 });
    }
    // Re-fit only when the filtered set changes, not on every render.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [key, map]);

  useEffect(() => {
    const selected = places.find((place) => place.id === selectedId);
    if (selected) map.flyTo([selected.lat, selected.lng], Math.max(map.getZoom(), 9), { duration: 0.8 });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedId, map]);

  return null;
}

export default function LeafletMap({
  places,
  selectedId,
  onSelect,
  userLocation,
  visible = true
}: {
  places: MapPlace[];
  selectedId: string | null;
  onSelect: (id: string) => void;
  userLocation: { lat: number; lng: number } | null;
  visible?: boolean;
}) {
  const icons = useMemo(() => {
    const entries = Object.entries(categoryColours).flatMap(([category, colour]) => [
      [`${category}:0`, pinIcon(colour, false)],
      [`${category}:1`, pinIcon(colour, true)]
    ]);
    return Object.fromEntries(entries) as Record<string, L.DivIcon>;
  }, []);

  return (
    <MapContainer
      bounds={SOUTH_AFRICA_BOUNDS}
      minZoom={4}
      scrollWheelZoom={false}
      className="h-full w-full"
      aria-label="Map of heritage places across South Africa"
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <FitToPlaces places={places} selectedId={selectedId} visible={visible} />
      {places.map((place) => (
        <Marker
          key={place.id}
          position={[place.lat, place.lng]}
          icon={icons[`${place.category}:${place.id === selectedId ? 1 : 0}`]}
          title={place.name}
          eventHandlers={{ click: () => onSelect(place.id) }}
        >
          <Popup>
            <div className="min-w-[200px] font-sans">
              <p className="text-xs font-bold uppercase tracking-wide" style={{ color: categoryColours[place.category] }}>
                {place.category}
                {place.isSample ? " · Sample listing" : ""}
              </p>
              <p className="mt-1 font-serif text-base font-black text-brand-deep">{place.name}</p>
              <p className="text-xs text-brand-deep/70">
                {place.town}, {place.province}
              </p>
              <p className="mt-2 text-sm leading-5 text-brand-deep/80">{place.description}</p>
              {place.href ? (
                <Link href={place.href} className="mt-2 inline-block text-sm font-bold text-brand-forest underline">
                  Learn more →
                </Link>
              ) : null}
            </div>
          </Popup>
        </Marker>
      ))}
      {userLocation ? (
        <CircleMarker
          center={[userLocation.lat, userLocation.lng]}
          radius={9}
          pathOptions={{ color: "#fff", weight: 3, fillColor: "#2563eb", fillOpacity: 1 }}
        >
          <Popup>You are here</Popup>
        </CircleMarker>
      ) : null}
    </MapContainer>
  );
}
