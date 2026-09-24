"use client";

import dynamic from "next/dynamic";
import Link from "next/link";
import { useMemo, useState } from "react";
import { List, LocateFixed, Map as MapIcon, MapPin, Search, X } from "lucide-react";
import { categoryColours } from "@/components/mapColours";
import { distanceKm, mapCategories, mapPlaces, type MapCategory } from "@/lib/mapPlaces";
import { provinces } from "@/lib/content";

// Leaflet touches `window`, so the map itself only renders in the browser.
const LeafletMap = dynamic(() => import("@/components/LeafletMap"), {
  ssr: false,
  loading: () => (
    <div className="grid h-full place-items-center bg-[#dce8d3] text-sm font-semibold text-brand-deep/70">
      Loading map…
    </div>
  )
});

type LocationState =
  | { status: "idle" }
  | { status: "locating" }
  | { status: "found"; lat: number; lng: number }
  | { status: "error"; message: string };

export default function ExploreMap() {
  const [query, setQuery] = useState("");
  const [category, setCategory] = useState<MapCategory | "all">("all");
  const [province, setProvince] = useState("all");
  const [view, setView] = useState<"map" | "list">("map");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [location, setLocation] = useState<LocationState>({ status: "idle" });

  const userLocation = useMemo(
    () => (location.status === "found" ? { lat: location.lat, lng: location.lng } : null),
    [location]
  );

  const results = useMemo(() => {
    const term = query.trim().toLowerCase();
    const filtered = mapPlaces.filter(
      (place) =>
        (category === "all" || place.category === category) &&
        (province === "all" || place.province === province) &&
        (!term || [place.name, place.town, place.province, place.description].some((text) => text.toLowerCase().includes(term)))
    );
    const withDistance = filtered.map((place) => ({
      place,
      distance: userLocation ? distanceKm(userLocation, place) : null
    }));
    if (userLocation) withDistance.sort((a, b) => (a.distance ?? 0) - (b.distance ?? 0));
    return withDistance;
  }, [query, category, province, userLocation]);

  const filtersActive = query !== "" || category !== "all" || province !== "all";

  function locate() {
    if (!("geolocation" in navigator)) {
      setLocation({ status: "error", message: "Location isn't available in this browser." });
      return;
    }
    setLocation({ status: "locating" });
    navigator.geolocation.getCurrentPosition(
      (position) => setLocation({ status: "found", lat: position.coords.latitude, lng: position.coords.longitude }),
      () => setLocation({ status: "error", message: "We couldn't get your location. Check your browser's location permission." }),
      { enableHighAccuracy: false, timeout: 10000 }
    );
  }

  function selectPlace(id: string) {
    setSelectedId(id);
    setView("map");
  }

  return (
    <>
      <section className="border-b border-brand-sage/25 bg-brand-ivory py-5">
        <form
          role="search"
          onSubmit={(event) => event.preventDefault()}
          className="mx-auto grid max-w-[1800px] gap-3 px-6 sm:grid-cols-2 lg:grid-cols-[1fr_200px_200px_auto] md:px-20"
        >
          <label className="relative">
            <span className="sr-only">Search places</span>
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-brand-deep/70" size={20} />
            <input
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Search heritage sites, museums, towns or vendors…"
              className="w-full rounded-xl border border-brand-sage/35 bg-white px-12 py-4 shadow-sm outline-none focus:border-brand-terracotta"
            />
          </label>
          <label>
            <span className="sr-only">Category</span>
            <select
              value={category}
              onChange={(event) => setCategory(event.target.value as MapCategory | "all")}
              className="w-full rounded-xl border border-brand-sage/35 bg-white px-5 py-4 shadow-sm"
            >
              <option value="all">All Categories</option>
              {mapCategories.map((item) => (
                <option key={item} value={item}>
                  {item}
                </option>
              ))}
            </select>
          </label>
          <label>
            <span className="sr-only">Province</span>
            <select
              value={province}
              onChange={(event) => setProvince(event.target.value)}
              className="w-full rounded-xl border border-brand-sage/35 bg-white px-5 py-4 shadow-sm"
            >
              <option value="all">All Provinces</option>
              {provinces.map((item) => (
                <option key={item.slug} value={item.name}>
                  {item.name}
                </option>
              ))}
            </select>
          </label>
          <button
            type="button"
            onClick={locate}
            disabled={location.status === "locating"}
            className="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-xl bg-brand-forest px-6 py-4 font-bold text-white disabled:opacity-70"
          >
            <LocateFixed size={18} />
            {location.status === "locating" ? "Locating…" : location.status === "found" ? "Update location" : "Near me"}
          </button>
        </form>
        {location.status === "error" ? (
          <p role="alert" className="mx-auto mt-3 max-w-[1800px] px-6 text-sm font-semibold text-terracotta-700 md:px-20">
            {location.message}
          </p>
        ) : null}
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-8 md:px-20 lg:grid-cols-[220px_minmax(0,1fr)] 2xl:grid-cols-[240px_minmax(0,1fr)_400px]">
        <aside className="hidden lg:block">
          <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Categories</p>
          <div className="mt-4 grid gap-1">
            {(["all", ...mapCategories] as const).map((item) => (
              <button
                key={item}
                type="button"
                onClick={() => setCategory(item)}
                aria-pressed={category === item}
                className={[
                  "flex items-center gap-3 rounded-lg px-4 py-2 text-left text-sm font-semibold",
                  category === item ? "bg-brand-forest text-white" : "text-brand-deep/75 hover:bg-white"
                ].join(" ")}
              >
                <span
                  className="h-3 w-3 shrink-0 rounded-full border border-white/60"
                  style={{ backgroundColor: item === "all" ? "#A8BDA0" : categoryColours[item] }}
                />
                {item === "all" ? "All Categories" : item}
              </button>
            ))}
          </div>
          <p className="mt-8 text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Provinces</p>
          <div className="mt-4 grid gap-1">
            {[{ slug: "all", name: "All Provinces" }, ...provinces].map((item) => {
              const value = item.slug === "all" ? "all" : item.name;
              return (
                <button
                  key={item.slug}
                  type="button"
                  onClick={() => setProvince(value)}
                  aria-pressed={province === value}
                  className={[
                    "rounded-lg px-4 py-2 text-left text-sm font-semibold",
                    province === value ? "bg-brand-forest text-white" : "text-brand-deep/75 hover:bg-white"
                  ].join(" ")}
                >
                  {item.name}
                </button>
              );
            })}
          </div>
        </aside>

        <div>
          <div className="mb-4 flex flex-wrap items-center gap-2">
            <div role="group" aria-label="View" className="flex gap-2">
              {([
                ["map", "Map View", MapIcon],
                ["list", "List View", List]
              ] as const).map(([value, label, Icon]) => (
                <button
                  key={value}
                  type="button"
                  onClick={() => setView(value)}
                  aria-pressed={view === value}
                  className={[
                    "inline-flex items-center gap-2 rounded-xl px-6 py-3 font-bold",
                    view === value ? "bg-brand-forest text-white" : "bg-white text-brand-deep"
                  ].join(" ")}
                >
                  <Icon size={18} /> {label}
                </button>
              ))}
            </div>
            {filtersActive ? (
              <button
                type="button"
                onClick={() => {
                  setQuery("");
                  setCategory("all");
                  setProvince("all");
                }}
                className="inline-flex items-center gap-1 rounded-xl px-4 py-3 text-sm font-bold text-brand-deep hover:bg-white"
              >
                <X size={16} /> Clear filters
              </button>
            ) : null}
          </div>

          <div
            hidden={view !== "map"}
            className="relative isolate h-[480px] overflow-hidden rounded-xl border border-brand-sage/40 shadow-sm md:h-[610px]"
          >
            <LeafletMap places={results.map((result) => result.place)} selectedId={selectedId} onSelect={setSelectedId} userLocation={userLocation} visible={view === "map"} />
          </div>

          {view === "list" ? <ResultList results={results} selectedId={selectedId} onSelect={selectPlace} expanded /> : null}
        </div>

        <aside className={["lg:col-span-2 2xl:col-span-1", view === "list" ? "hidden 2xl:block" : ""].join(" ")}>
          <div className="mb-4 flex items-end justify-between">
            <h2 className="font-serif text-3xl font-black text-brand-deep">{userLocation ? "Nearest to You" : "Places"}</h2>
            <span className="text-sm text-brand-deep/70">
              {results.length} {results.length === 1 ? "result" : "results"}
            </span>
          </div>
          <ResultList results={results} selectedId={selectedId} onSelect={selectPlace} />
        </aside>
      </section>
    </>
  );
}

function ResultList({
  results,
  selectedId,
  onSelect,
  expanded = false
}: {
  results: { place: (typeof mapPlaces)[number]; distance: number | null }[];
  selectedId: string | null;
  onSelect: (id: string) => void;
  expanded?: boolean;
}) {
  if (results.length === 0) {
    return <p className="rounded-xl bg-white p-6 text-brand-deep/75">No places match these filters.</p>;
  }

  return (
    <ul className={["grid gap-3 overflow-y-auto pr-1", expanded ? "sm:grid-cols-2" : "max-h-[610px]"].join(" ")}>
      {results.map(({ place, distance }) => (
        <li key={place.id}>
          <article
            className={[
              "rounded-xl border bg-white p-4 shadow-sm transition",
              place.id === selectedId ? "border-brand-terracotta ring-2 ring-brand-terracotta/30" : "border-transparent"
            ].join(" ")}
          >
            <div className="flex items-start justify-between gap-3">
              <span
                className="rounded-full px-3 py-1 text-xs font-bold text-white"
                style={{ backgroundColor: categoryColours[place.category] }}
              >
                {place.category}
              </span>
              {distance !== null ? (
                <span className="whitespace-nowrap text-sm font-semibold text-brand-terracotta">
                  {distance < 10 ? distance.toFixed(1) : Math.round(distance)} km
                </span>
              ) : null}
            </div>
            <h3 className="mt-2 font-serif text-lg font-black text-brand-deep">{place.name}</h3>
            <p className="flex items-center gap-1 text-sm text-brand-deep/70">
              <MapPin size={14} /> {place.town}, {place.province}
              {place.isSample ? <span className="ml-1 text-xs font-semibold">(sample listing)</span> : null}
            </p>
            <p className="mt-2 text-sm leading-6 text-brand-deep/80">{place.description}</p>
            <div className="mt-3 flex flex-wrap gap-4 text-sm font-bold">
              <button type="button" onClick={() => onSelect(place.id)} className="text-brand-forest underline">
                Show on map
              </button>
              {place.href ? (
                <Link href={place.href} className="text-brand-deep hover:text-brand-terracotta">
                  Learn more →
                </Link>
              ) : null}
            </div>
          </article>
        </li>
      ))}
    </ul>
  );
}
