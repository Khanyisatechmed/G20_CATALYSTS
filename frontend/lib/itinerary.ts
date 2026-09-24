// Sample five-day route for the trip planner. Coordinates are approximate.
export type ItineraryStop = {
  day: number; // 0-based index matching the planner's day tabs
  name: string;
  note: string;
  lat: number;
  lng: number;
};

export const sampleItineraryStops: ItineraryStop[] = [
  { day: 0, name: "Polokwane International Airport", note: "Arrive and collect your rental car.", lat: -23.8453, lng: 29.4586 },
  { day: 0, name: "Modjadji Nature Reserve", note: "Balobedu heritage and the Rain Queen's cycad forest.", lat: -23.6272, lng: 30.3364 },
  { day: 1, name: "Magoebaskloof", note: "Forest trails, waterfalls and the Haenertsburg area.", lat: -23.9, lng: 29.97 },
  { day: 1, name: "Tzaneen", note: "Local artisans and a traditional lunch.", lat: -23.8332, lng: 30.1635 },
  { day: 2, name: "Blyde River Canyon", note: "The Three Rondavels viewpoint on the Panorama Route.", lat: -24.5772, lng: 30.8123 },
  { day: 3, name: "Kruger National Park (Phabeni Gate)", note: "Safari day in the southern Kruger.", lat: -25.0269, lng: 31.2395 },
  { day: 3, name: "Shangana Cultural Village", note: "Shangaan-Tsonga food, music and dance near Hazyview.", lat: -24.9895, lng: 31.1167 },
  { day: 4, name: "Kruger Mpumalanga International Airport", note: "Fly home from Mbombela.", lat: -25.3832, lng: 31.1056 }
];
