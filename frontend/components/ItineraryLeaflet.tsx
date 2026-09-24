"use client";

import "leaflet/dist/leaflet.css";
import L from "leaflet";
import { useEffect, useMemo } from "react";
import { MapContainer, Marker, Polyline, Popup, TileLayer, useMap } from "react-leaflet";
import type { ItineraryStop } from "@/lib/itinerary";

function stopIcon(number: number, active: boolean) {
  const size = active ? 34 : 26;
  const background = active ? "#315D42" : "#A8BDA0";
  return L.divIcon({
    className: "",
    iconSize: [size, size],
    iconAnchor: [size / 2, size / 2],
    popupAnchor: [0, -size / 2],
    html: `<div style="width:${size}px;height:${size}px;border-radius:9999px;background:${background};color:#fff;border:3px solid #fff;box-shadow:0 2px 6px rgba(0,0,0,.35);display:grid;place-items:center;font:700 ${active ? 14 : 12}px/1 system-ui,sans-serif">${number}</div>`
  });
}

function FitToDay({ stops, activeDay }: { stops: ItineraryStop[]; activeDay: number }) {
  const map = useMap();

  useEffect(() => {
    const dayStops = stops.filter((stop) => stop.day === activeDay);
    const target = dayStops.length > 0 ? dayStops : stops;
    if (target.length === 1) {
      map.flyTo([target[0].lat, target[0].lng], 9, { duration: 0.8 });
    } else {
      map.flyToBounds(L.latLngBounds(target.map((stop) => [stop.lat, stop.lng])), { padding: [36, 36], maxZoom: 10, duration: 0.8 });
    }
  }, [activeDay, stops, map]);

  return null;
}

export default function ItineraryLeaflet({ stops, activeDay }: { stops: ItineraryStop[]; activeDay: number }) {
  const route = useMemo(() => stops.map((stop) => [stop.lat, stop.lng] as [number, number]), [stops]);
  const activeRoute = useMemo(() => {
    // Highlight the legs travelled on the active day, including the drive in from the previous stop.
    const first = stops.findIndex((stop) => stop.day === activeDay);
    if (first < 0) return [];
    const last = stops.map((stop) => stop.day).lastIndexOf(activeDay);
    return stops.slice(Math.max(0, first - 1), last + 1).map((stop) => [stop.lat, stop.lng] as [number, number]);
  }, [stops, activeDay]);

  return (
    <MapContainer
      bounds={L.latLngBounds(route)}
      boundsOptions={{ padding: [36, 36] }}
      scrollWheelZoom={false}
      className="h-full w-full"
      aria-label="Map of the itinerary route"
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <FitToDay stops={stops} activeDay={activeDay} />
      <Polyline positions={route} pathOptions={{ color: "#A8BDA0", weight: 4, dashArray: "6 8" }} />
      {activeRoute.length > 1 ? (
        <Polyline positions={activeRoute} pathOptions={{ color: "#C8754B", weight: 5, dashArray: "8 8" }} />
      ) : null}
      {stops.map((stop, index) => (
        <Marker
          key={stop.name}
          position={[stop.lat, stop.lng]}
          icon={stopIcon(index + 1, stop.day === activeDay)}
          title={stop.name}
          zIndexOffset={stop.day === activeDay ? 1000 : 0}
        >
          <Popup>
            <div className="font-sans">
              <p className="text-xs font-bold uppercase tracking-wide text-brand-terracotta">Day {stop.day + 1}</p>
              <p className="font-serif text-base font-black text-brand-deep">{stop.name}</p>
              <p className="text-sm text-brand-deep/80">{stop.note}</p>
            </div>
          </Popup>
        </Marker>
      ))}
    </MapContainer>
  );
}
