import { demoVendors } from "@/lib/demoData";

export const mapCategories = [
  "Heritage Sites",
  "Museums",
  "Nature & Landscapes",
  "Cultural Experiences",
  "Markets & Food",
  "Artisans & Vendors"
] as const;

export type MapCategory = (typeof mapCategories)[number];

export type MapPlace = {
  id: string;
  name: string;
  category: MapCategory;
  province: string;
  town: string;
  lat: number;
  lng: number;
  description: string;
  href?: string;
  isSample?: boolean;
};

// Well-known public heritage places. Coordinates are approximate (to roughly 1 km)
// and should be verified before production use.
const heritagePlaces: MapPlace[] = [
  // Limpopo
  { id: "mapungubwe", name: "Mapungubwe Cultural Landscape", category: "Heritage Sites", province: "Limpopo", town: "Musina", lat: -22.1936, lng: 29.2389, description: "UNESCO World Heritage Site and capital of southern Africa's first known kingdom.", href: "/heritage/mapungubwe" },
  { id: "modjadji", name: "Modjadji Nature Reserve", category: "Nature & Landscapes", province: "Limpopo", town: "Modjadjiskloof", lat: -23.6272, lng: 30.3364, description: "Ancient cycad forest closely linked to the legacy of the Balobedu Rain Queen.", href: "/heritage/balobedu" },
  { id: "makapansgat", name: "Makapan's Valley (Makapansgat)", category: "Heritage Sites", province: "Limpopo", town: "Mokopane", lat: -24.162, lng: 29.183, description: "Fossil caves forming part of the Cradle of Humankind World Heritage Site." },
  { id: "fundudzi", name: "Lake Fundudzi", category: "Nature & Landscapes", province: "Limpopo", town: "Thohoyandou", lat: -22.8458, lng: 30.3083, description: "Sacred lake of the Vhavenda in the Soutpansberg mountains.", href: "/heritage/vhavenda" },
  // Mpumalanga
  { id: "botshabelo", name: "Botshabelo Historical Village", category: "Cultural Experiences", province: "Mpumalanga", town: "Middelburg", lat: -25.715, lng: 29.43, description: "Historic mission settlement with Ndebele painted homesteads.", href: "/heritage/ndebele" },
  { id: "blyde", name: "Blyde River Canyon", category: "Nature & Landscapes", province: "Mpumalanga", town: "Graskop", lat: -24.5772, lng: 30.8123, description: "One of the largest canyons on Earth, with the Three Rondavels viewpoint." },
  { id: "shangana", name: "Shangana Cultural Village", category: "Cultural Experiences", province: "Mpumalanga", town: "Hazyview", lat: -24.9895, lng: 31.1167, description: "Cultural village sharing Shangaan-Tsonga food, music and dance.", href: "/heritage/vatsonga" },
  // Gauteng
  { id: "cradle", name: "Cradle of Humankind (Maropeng)", category: "Museums", province: "Gauteng", town: "Mogale City", lat: -25.9667, lng: 27.6622, description: "World Heritage Site with some of the world's most important early human fossils." },
  { id: "apartheid-museum", name: "Apartheid Museum", category: "Museums", province: "Gauteng", town: "Johannesburg", lat: -26.2372, lng: 28.0104, description: "Museum tracing the rise and fall of apartheid." },
  { id: "hector-pieterson", name: "Hector Pieterson Memorial", category: "Museums", province: "Gauteng", town: "Soweto", lat: -26.2385, lng: 27.9086, description: "Memorial and museum honouring the youth of the 1976 Soweto Uprising." },
  { id: "constitution-hill", name: "Constitution Hill", category: "Heritage Sites", province: "Gauteng", town: "Johannesburg", lat: -26.1893, lng: 28.0425, description: "Former prison complex, now home to the Constitutional Court." },
  // KwaZulu-Natal
  { id: "drakensberg", name: "uKhahlamba-Drakensberg Park", category: "Nature & Landscapes", province: "KwaZulu-Natal", town: "Giant's Castle", lat: -29.2667, lng: 29.5167, description: "World Heritage Site with mountain landscapes and thousands of San rock paintings.", href: "/heritage/khoi-san-heritage" },
  { id: "emakhosini", name: "Emakhosini Valley of the Kings", category: "Heritage Sites", province: "KwaZulu-Natal", town: "Ulundi", lat: -28.3667, lng: 31.3333, description: "Burial valley of early Zulu kings, marked by the Spirit of eMakhosini monument.", href: "/heritage/zulu-heritage" },
  { id: "victoria-market", name: "Victoria Street Market", category: "Markets & Food", province: "KwaZulu-Natal", town: "Durban", lat: -29.8574, lng: 31.0177, description: "Durban market known for spices, crafts and Indian South African heritage.", href: "/heritage/indian-south-africans" },
  // Eastern Cape
  { id: "mandela-museum", name: "Nelson Mandela Museum", category: "Museums", province: "Eastern Cape", town: "Mthatha", lat: -31.5889, lng: 28.7844, description: "Museum dedicated to Mandela's life, with a heritage site at nearby Qunu.", href: "/heritage/xhosa" },
  { id: "addo", name: "Addo Elephant National Park", category: "Nature & Landscapes", province: "Eastern Cape", town: "Addo", lat: -33.4833, lng: 25.75, description: "Malaria-free national park famous for its elephant herds." },
  // Free State
  { id: "basotho-village", name: "Basotho Cultural Village", category: "Cultural Experiences", province: "Free State", town: "Golden Gate", lat: -28.5405, lng: 28.7045, description: "Living museum of Basotho architecture, crafts and traditions.", href: "/heritage/basotho" },
  { id: "golden-gate", name: "Golden Gate Highlands National Park", category: "Nature & Landscapes", province: "Free State", town: "Clarens", lat: -28.5089, lng: 28.6164, description: "Sandstone cliffs and grasslands of the eastern Free State." },
  // Northern Cape
  { id: "richtersveld", name: "Richtersveld Cultural and Botanical Landscape", category: "Heritage Sites", province: "Northern Cape", town: "Kuboes", lat: -28.4467, lng: 16.9922, description: "UNESCO World Heritage Site where Nama herders keep seasonal traditions.", href: "/heritage/nama" },
  { id: "griekwastad", name: "Mary Moffat Museum", category: "Museums", province: "Northern Cape", town: "Griekwastad", lat: -28.8517, lng: 23.2567, description: "Old mission house in the historic Griqua capital.", href: "/heritage/griqua" },
  { id: "big-hole", name: "The Big Hole", category: "Museums", province: "Northern Cape", town: "Kimberley", lat: -28.7382, lng: 24.7586, description: "Hand-dug diamond mine and museum at the heart of Kimberley's history." },
  { id: "wonderwerk", name: "Wonderwerk Cave", category: "Heritage Sites", province: "Northern Cape", town: "Kuruman", lat: -27.845, lng: 23.555, description: "Cave with evidence of human activity stretching back around two million years." },
  // North West
  { id: "taung", name: "Taung Skull Fossil Site", category: "Heritage Sites", province: "North West", town: "Taung", lat: -27.6167, lng: 24.7667, description: "Where the famous Taung Child fossil was found in 1924." },
  { id: "mahikeng-museum", name: "Mahikeng Museum", category: "Museums", province: "North West", town: "Mahikeng", lat: -25.8655, lng: 25.6442, description: "Museum of the town's Barolong and colonial-era history.", href: "/heritage/batswana" },
  // Western Cape
  { id: "robben-island", name: "Robben Island", category: "Heritage Sites", province: "Western Cape", town: "Cape Town", lat: -33.8076, lng: 18.3712, description: "World Heritage Site where Nelson Mandela was imprisoned for 18 years." },
  { id: "bo-kaap", name: "Bo-Kaap", category: "Cultural Experiences", province: "Western Cape", town: "Cape Town", lat: -33.9206, lng: 18.4155, description: "Historic Cape Malay neighbourhood of colourful houses and mosques.", href: "/heritage/cape-malay" },
  { id: "district-six", name: "District Six Museum", category: "Museums", province: "Western Cape", town: "Cape Town", lat: -33.9285, lng: 18.4232, description: "Museum preserving the memory of a community destroyed by forced removals.", href: "/heritage/coloured-communities" },
  { id: "taalmonument", name: "Afrikaans Language Monument", category: "Heritage Sites", province: "Western Cape", town: "Paarl", lat: -33.7666, lng: 18.9446, description: "Monument to the Afrikaans language on Paarl Mountain.", href: "/heritage/afrikaner" }
];

// Sample vendors from the demo data, placed at the centre of their towns.
const townCentres: Record<string, [number, number]> = {
  Nongoma: [-27.8983, 31.6453],
  Tzaneen: [-23.8332, 30.1635],
  Johannesburg: [-26.2041, 28.0473]
};

const vendorPlaces: MapPlace[] = demoVendors.flatMap((vendor) => {
  const centre = townCentres[vendor.town];
  if (!centre) return [];
  return [
    {
      id: `vendor-${vendor.slug}`,
      name: vendor.businessName,
      category: "Artisans & Vendors" as const,
      province: vendor.province,
      town: vendor.town,
      lat: centre[0],
      lng: centre[1],
      description: `${vendor.category} · ${vendor.locationLabel}`,
      href: `/vendors/${vendor.slug}`,
      isSample: true
    }
  ];
});

export const mapPlaces: MapPlace[] = [...heritagePlaces, ...vendorPlaces];

export function distanceKm(from: { lat: number; lng: number }, to: { lat: number; lng: number }) {
  const toRad = (deg: number) => (deg * Math.PI) / 180;
  const dLat = toRad(to.lat - from.lat);
  const dLng = toRad(to.lng - from.lng);
  const a = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(from.lat)) * Math.cos(toRad(to.lat)) * Math.sin(dLng / 2) ** 2;
  return 6371 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}
