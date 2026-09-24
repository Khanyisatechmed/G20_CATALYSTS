// Ask Catalyst: a site guide that answers from Catalystic Wanders' own content.
// Runs entirely in the browser (the site is a static export), so it only knows what the site knows.
import { heritageEntries, exhibitions, provinces, type HeritageEntry } from "@/lib/content";
import { demoEvents, demoFood, demoVendors } from "@/lib/demoData";
import { sampleItineraryStops } from "@/lib/itinerary";
import { mapPlaces, type MapPlace } from "@/lib/mapPlaces";
import { marketplaceProducts, type MarketplaceProduct } from "@/lib/products";

export type ChatLink = { label: string; href: string };
export type ChatCard = { title: string; subtitle: string; href: string; image?: string };
export type ChatAction = { kind: "add-to-cart"; productId: string; label: string };
export type ChatReply = {
  text: string[];
  cards?: ChatCard[];
  links?: ChatLink[];
  actions?: ChatAction[];
  suggestions?: string[];
};
export type ChatContext = { heritage?: string; province?: string; product?: string; place?: string };
export type CartSummary = { count: number; total: number; titles: string[] };

// Keep in step with the prices on app/bookings/hologram/page.tsx.
const hologramTicketPrices = [
  ["Adult", 320],
  ["Child", 160],
  ["Student", 220],
  ["Family or group (per person)", 250]
] as const;
const hologramSessions = ["09:30", "11:00", "13:30", "15:00", "17:30"];

const heritageAliases: Record<string, string[]> = {
  "zulu-heritage": ["zulu", "amazulu", "isizulu", "shaka", "emakhosini"],
  xhosa: ["xhosa", "amaxhosa", "isixhosa", "mpondo", "thembu"],
  ndebele: ["ndebele", "amandebele", "isindebele", "esther mahlangu"],
  swati: ["swati", "swazi", "emaswati", "siswati"],
  basotho: ["sotho", "basotho", "sesotho", "mosotho", "moshoeshoe", "southern sotho"],
  bapedi: ["pedi", "bapedi", "sepedi", "northern sotho", "sekhukhune", "sekhukhuneland"],
  balobedu: ["balobedu", "lobedu", "rain queen", "modjadji", "khilobedu"],
  batswana: ["tswana", "batswana", "setswana", "bafokeng", "barolong"],
  vatsonga: ["tsonga", "vatsonga", "xitsonga", "chatsonga", "shangaan", "shangana", "xibelani"],
  vhavenda: ["venda", "vhavenda", "tshivenda", "fundudzi", "domba"],
  "khoi-san-heritage": ["khoi", "san", "khoisan", "khoikhoi", "khoekhoe", "rock art", "first peoples", "khomani"],
  nama: ["nama", "matjieshuis", "matjieshuise"],
  griqua: ["griqua", "griquatown", "griekwastad", "adam kok", "kokstad"],
  "cape-malay": ["cape malay", "malay", "bo kaap", "bokaap"],
  "indian-south-africans": ["indian", "indians", "bunny chow", "diwali", "gandhi"],
  afrikaner: ["afrikaner", "afrikaners", "taalmonument", "boer", "boerekos"],
  "coloured-communities": ["coloured", "klopse", "minstrel", "minstrels", "kaaps", "ghoema"],
  mapungubwe: ["mapungubwe", "golden rhino"]
};

const provinceAliases: Record<string, string[]> = {
  "eastern-cape": ["eastern cape", "gqeberha", "port elizabeth", "east london", "mthatha", "qunu"],
  "free-state": ["free state", "bloemfontein", "clarens", "qwaqwa", "golden gate"],
  gauteng: ["gauteng", "johannesburg", "joburg", "jozi", "pretoria", "tshwane", "soweto"],
  "kwazulu-natal": ["kwazulu natal", "kwazulu", "kzn", "natal", "durban", "pietermaritzburg", "ulundi"],
  limpopo: ["limpopo", "polokwane", "tzaneen", "thohoyandou", "musina", "giyani"],
  mpumalanga: ["mpumalanga", "mbombela", "nelspruit", "hazyview", "graskop", "bushbuckridge"],
  "northern-cape": ["northern cape", "kimberley", "upington", "kalahari", "namaqualand"],
  "north-west": ["north west", "northwest", "mahikeng", "mafikeng", "rustenburg", "taung"],
  "western-cape": ["western cape", "cape town", "stellenbosch", "paarl", "franschhoek"]
};

const placeAliases: Record<string, string[]> = {
  "robben-island": ["robben island"],
  blyde: ["blyde", "three rondavels", "panorama route"],
  drakensberg: ["drakensberg", "ukhahlamba", "giants castle"],
  cradle: ["cradle of humankind", "maropeng", "sterkfontein"],
  "big-hole": ["big hole"],
  taung: ["taung child", "taung skull"],
  wonderwerk: ["wonderwerk"],
  addo: ["addo", "elephant park"],
  "golden-gate": ["golden gate"],
  "hector-pieterson": ["hector pieterson", "june 16", "1976 uprising"],
  "apartheid-museum": ["apartheid museum"],
  "constitution-hill": ["constitution hill"],
  "district-six": ["district six"],
  "victoria-market": ["victoria street market", "victoria street"],
  makapansgat: ["makapan", "makapansgat"],
  fundudzi: ["fundudzi"],
  richtersveld: ["richtersveld"],
  "mahikeng-museum": ["mahikeng museum"],
  botshabelo: ["botshabelo"],
  shangana: ["shangana cultural village", "shangana village"],
  "mandela-museum": ["mandela museum", "nelson mandela museum"],
  "basotho-village": ["basotho cultural village"],
  "bo-kaap": ["bo kaap", "bokaap"],
  taalmonument: ["taalmonument", "language monument"]
};

const productAliases: Record<string, string[]> = {
  "zulu-hat": ["hat", "hats", "headdress", "isicholo", "beaded hat"],
  "zulu-ikhamba": ["ikhamba", "vessel", "pot", "pots", "pottery", "clay"]
};

const intents: Record<string, string[]> = {
  greet: ["hi", "hello", "hey", "sawubona", "dumela", "molo", "howzit", "good morning", "good afternoon", "good evening", "avuxeni"],
  thanks: ["thanks", "thank you", "ngiyabonga", "enkosi", "ke a leboga", "cheers"],
  help: ["help", "what can you do", "how does this work", "options"],
  about: ["who are you", "what is catalystic", "about catalystic", "about you", "what is this site"],
  hologram: ["hologram", "hub", "museum", "exhibition", "ticket", "tickets", "book", "booking", "reserve", "reservation", "session", "sessions"],
  shop: ["buy", "shop", "shopping", "marketplace", "product", "products", "craft", "crafts", "souvenir", "souvenirs", "gift", "gifts", "purchase", "sell me"],
  cart: ["cart", "basket", "checkout", "my order", "my items"],
  map: ["map", "where", "near", "nearby", "location", "directions", "around", "see it", "visit it", "places to visit", "sites"],
  plan: ["plan", "itinerary", "trip", "weekend", "route", "holiday", "vacation", "schedule", "days", "road trip"],
  food: ["food", "eat", "eating", "cuisine", "restaurant", "restaurants", "dish", "dishes", "curry", "bobotie", "hungry", "taste", "cook"],
  events: ["event", "events", "festival", "festivals", "happening", "whats on", "celebration", "celebrations"],
  vendors: ["vendor", "vendors", "artisan", "artisans", "maker", "makers", "stall", "stalls", "local business"],
  language: ["language", "languages", "speak", "spoken", "how do they say"],
  heritage: ["culture", "cultures", "heritage", "tribe", "tribes", "people", "peoples", "communities", "community", "history", "traditions", "tradition", "kingdom"],
  price: ["price", "prices", "cost", "costs", "how much", "expensive", "cheap"]
};

const followUpWords = ["it", "there", "them", "they", "their", "that", "this", "those", "more", "else"];

function normalise(text: string) {
  return ` ${text
    .toLowerCase()
    .replace(/[’']/g, "")
    .replace(/[^a-z0-9]+/g, " ")
    .trim()} `;
}

function has(norm: string, phrase: string) {
  return norm.includes(` ${phrase} `);
}

function findByAliases(norm: string, aliases: Record<string, string[]>) {
  let best: { key: string; length: number } | null = null;
  for (const [key, list] of Object.entries(aliases)) {
    for (const alias of list) {
      if (has(norm, alias) && (!best || alias.length > best.length)) best = { key, length: alias.length };
    }
  }
  return best?.key;
}

function scoreIntents(norm: string) {
  const scores: Record<string, number> = {};
  for (const [intent, words] of Object.entries(intents)) {
    scores[intent] = words.filter((word) => has(norm, word)).length;
  }
  return scores;
}

const heritageBySlug = (slug?: string) => heritageEntries.find((entry) => entry.slug === slug);
const provinceBySlug = (slug?: string) => provinces.find((province) => province.slug === slug);
const provinceByName = (name?: string) => provinces.find((province) => province.name === name);
const placeById = (id?: string) => mapPlaces.find((place) => place.id === id);
const productById = (id?: string) => marketplaceProducts.find((product) => product.id === id);
const rand = (value: number) => `R${value.toLocaleString("en-ZA")}`;
const listJoin = (items: string[]) =>
  items.length <= 1 ? items.join("") : `${items.slice(0, -1).join(", ")} and ${items[items.length - 1]}`;

function mapHref(province?: string, place?: string) {
  const params = new URLSearchParams();
  if (province) params.set("province", province);
  if (place) params.set("place", place);
  const query = params.toString();
  return query ? `/explore/map/?${query}` : "/explore/map/";
}

function heritageCard(entry: HeritageEntry): ChatCard {
  return { title: entry.title, subtitle: entry.provinces.join(" · "), href: `/heritage/${entry.slug}/`, image: entry.image };
}

function productCard(product: MarketplaceProduct): ChatCard {
  return { title: product.title, subtitle: `${rand(product.price)} · by ${product.artisan}`, href: `/marketplace/${product.id}/`, image: product.imageUrl };
}

function featuredPlaceFor(entry: HeritageEntry) {
  return mapPlaces.find((place) => place.href === `/heritage/${entry.slug}`);
}

// ---------- replies ----------

function heritageReply(entry: HeritageEntry, scores: Record<string, number>): ChatReply {
  const place = featuredPlaceFor(entry);
  const homeProvince = provinceByName(place?.province ?? entry.provinces[0]);
  const text: string[] = [];

  // Answer the specific question when there is one; otherwise give the overview.
  if (scores.language > 0) {
    text.push(
      entry.slug === "mapungubwe"
        ? "Mapungubwe is an archaeological heritage site rather than a living community."
        : `The ${entry.title} speak ${entry.language}. They live mainly in ${listJoin(entry.provinces)}.`
    );
  } else if (scores.map > 0 && place) {
    text.push(`A good place to experience ${entry.title} heritage is ${place.name} in ${place.town}, ${place.province}.`, place.description);
    if (entry.slug === "balobedu") text.push("You can also meet the Rain Queen as a hologram at our Hologram Hub in Limpopo.");
  } else {
    text.push(entry.summary, `Known for: ${listJoin(entry.knownFor)}.`);
    if (entry.slug === "balobedu") text.push("The Rain Queen is also the inaugural experience at our Hologram Hub in Limpopo.");
  }

  const links: ChatLink[] = [{ label: `Read the ${entry.title} profile`, href: `/heritage/${entry.slug}/` }];
  if (place) links.push({ label: `See ${place.name} on the map`, href: mapHref(homeProvince?.slug, place.id) });
  if (entry.slug === "balobedu") links.push({ label: "Book the Rain Queen experience", href: "/bookings/hologram/" });

  return {
    text,
    cards: [heritageCard(entry)],
    links,
    suggestions: [
      scores.language > 0 ? `Where can I experience ${entry.title} culture?` : `What language do the ${entry.title} speak?`,
      `What else is in ${homeProvince?.name ?? entry.provinces[0]}?`,
      "Plan a heritage trip"
    ]
  };
}

function provinceReply(slug: string, scores: Record<string, number>): ChatReply {
  const province = provinceBySlug(slug)!;
  if (scores.food > 0) return foodReply(province.name);
  if (scores.events > 0) return eventsReply(province.name);

  const communities = heritageEntries.filter((entry) => entry.provinces.includes(province.name) && entry.type !== "Heritage destination");
  const places = mapPlaces.filter((place) => place.province === province.name && !place.isSample);
  const text = [
    `${province.name}: ${province.summary}`,
    communities.length
      ? `Cultures rooted here include ${listJoin(communities.map((entry) => entry.title))}.`
      : "Our heritage library doesn't list a community for this province yet.",
    places.length ? `On the map: ${listJoin(places.slice(0, 5).map((place) => place.name))}${places.length > 5 ? ` and ${places.length - 5} more` : ""}.` : ""
  ].filter(Boolean);

  return {
    text,
    cards: communities.slice(0, 4).map(heritageCard),
    links: [
      { label: `Explore ${province.name} on the map`, href: mapHref(province.slug) },
      { label: `Heritage of ${province.name}`, href: `/heritage/?province=${province.slug}#explore` },
      { label: `${province.name} guide`, href: `/provinces/${province.slug}/` }
    ],
    suggestions: [
      communities[0] ? `Tell me about the ${communities[0].title}` : "Show me all cultures",
      `Food in ${province.name}`,
      "Plan a heritage trip"
    ]
  };
}

function placeReply(place: MapPlace): ChatReply {
  const province = provinceByName(place.province);
  const links: ChatLink[] = [{ label: "Show it on the map", href: mapHref(province?.slug, place.id) }];
  if (place.href) links.push({ label: place.href.startsWith("/heritage") ? "Read the heritage profile" : "Learn more", href: `${place.href}/` });
  return {
    text: [`${place.name} is in ${place.town}, ${place.province}.`, place.description],
    links,
    suggestions: [`What else is in ${place.province}?`, "Plan a heritage trip", "What can I buy?"]
  };
}

function productReply(product: MarketplaceProduct): ChatReply {
  return {
    text: [
      `The ${product.title} is ${rand(product.price)}, made by ${product.artisan} (${product.region}).`,
      product.description,
      `Materials: ${listJoin(product.materials)}. You can view it in 3D and AR on its page.`
    ],
    cards: [productCard(product)],
    actions: [{ kind: "add-to-cart", productId: product.id, label: `Add ${product.title} to cart` }],
    links: [{ label: "View in 3D", href: `/marketplace/${product.id}/` }],
    suggestions: ["What else can I buy?", "What's in my cart?", "Who are the artisans?"]
  };
}

function shopReply(): ChatReply {
  return {
    text: [
      `The marketplace has ${marketplaceProducts.length} handmade pieces you can view in 3D and augmented reality:`,
      ...marketplaceProducts.map((product) => `${product.title}, ${rand(product.price)}, by ${product.artisan}.`)
    ],
    cards: marketplaceProducts.map(productCard),
    actions: marketplaceProducts.map((product) => ({ kind: "add-to-cart" as const, productId: product.id, label: `Add ${product.title}` })),
    links: [{ label: "Browse the marketplace", href: "/marketplace/" }],
    suggestions: ["Tell me about the Zulu hat", "Who are the artisans?", "What's in my cart?"]
  };
}

function cartReply(cart: CartSummary): ChatReply {
  if (cart.count === 0) {
    return {
      text: ["Your cart is empty. Would you like to see what's in the marketplace?"],
      links: [{ label: "Browse the marketplace", href: "/marketplace/" }],
      suggestions: ["What can I buy?", "Tell me about the clay vessel"]
    };
  }
  return {
    text: [`You have ${cart.count} ${cart.count === 1 ? "item" : "items"} in your cart (${listJoin(cart.titles)}), totalling ${rand(cart.total)}.`],
    links: [
      { label: "View cart", href: "/cart/" },
      { label: "Go to checkout", href: "/checkout/" }
    ],
    suggestions: ["What else can I buy?", "Book the Rain Queen experience"]
  };
}

function hologramReply(scores: Record<string, number>): ChatReply {
  const rainQueen = exhibitions.find((exhibition) => exhibition.slug === "balobedu-rain-queen");
  const text = [
    "The Hologram Hub is an indoor, two-storey heritage museum in Limpopo. Its inaugural experience is the Balobedu Rain Queen, the Modjadji.",
    `Sessions run at ${listJoin(hologramSessions)}${rainQueen ? ` and last about ${rainQueen.duration}` : ""}.`
  ];
  if (scores.price > 0 || scores.hologram > 0) {
    text.push(`Sample ticket prices: ${hologramTicketPrices.map(([label, price]) => `${label} ${rand(price)}`).join(", ")}.`);
  }
  text.push("Booking sends a reservation request. Confirmed tickets and payment aren't connected yet.");
  return {
    text,
    links: [
      { label: "Book the Rain Queen experience", href: "/bookings/hologram/" },
      { label: "About the Hologram Hub", href: "/hologram-hub/" },
      { label: "Who is the Rain Queen?", href: "/heritage/balobedu/" }
    ],
    suggestions: ["Who is the Rain Queen?", "What else is in Limpopo?", "Plan a trip around the Hub"]
  };
}

function planReply(provinceSlug?: string): ChatReply {
  const province = provinceBySlug(provinceSlug);
  if (province && !["limpopo", "mpumalanga"].includes(province.slug)) {
    const places = mapPlaces.filter((place) => place.province === province.name && !place.isSample).slice(0, 4);
    return {
      text: [
        `For a trip to ${province.name}, these are good heritage stops: ${listJoin(places.map((place) => `${place.name} (${place.town})`))}.`,
        "The trip planner currently has a sample route for Limpopo and Mpumalanga, which you can use as a starting point."
      ],
      links: [
        { label: `Explore ${province.name} on the map`, href: mapHref(province.slug) },
        { label: "Open the trip planner", href: "/plan-your-visit/" }
      ],
      suggestions: [`Cultures in ${province.name}`, `Food in ${province.name}`]
    };
  }
  const days = [...new Set(sampleItineraryStops.map((stop) => stop.day))].map(
    (day) => `Day ${day + 1}: ${listJoin(sampleItineraryStops.filter((stop) => stop.day === day).map((stop) => stop.name))}.`
  );
  return {
    text: ["Here's our sample five-day heritage route through Limpopo and Mpumalanga:", ...days],
    links: [
      { label: "Open the trip planner", href: "/plan-your-visit/" },
      { label: "See the route on the map", href: "/plan-your-visit/#itinerary-map" }
    ],
    suggestions: ["Book the Rain Queen experience", "Food in Limpopo", "Plan a trip in the Western Cape"]
  };
}

function foodReply(provinceName?: string): ChatReply {
  const experiences = demoFood.filter((item) => !provinceName || item.province === provinceName);
  const flavours: string[] = [];
  if (!provinceName || provinceName === "KwaZulu-Natal") flavours.push("Durban is famous for curry and bunny chow, and Victoria Street Market is a good place to start.");
  if (!provinceName || provinceName === "Western Cape") flavours.push("In Cape Town, Bo-Kaap is the home of Cape Malay cooking such as bobotie and bredie.");
  if (!provinceName || ["Free State", "North West", "Western Cape"].includes(provinceName)) flavours.push("Boerekos and the braai are shared traditions across the country.");
  return {
    text: [
      experiences.length
        ? `Food experiences${provinceName ? ` in ${provinceName}` : ""}: ${listJoin(experiences.map((item) => `${item.name} (${item.type.toLowerCase()})`))}.`
        : `We don't list a food experience in ${provinceName} yet.`,
      ...flavours,
      "Venue details, opening hours and ratings are still being verified."
    ],
    links: [{ label: "Food experiences", href: "/food/" }],
    suggestions: ["Tell me about Cape Malay heritage", "Tell me about Indian South Africans", "Plan a heritage trip"]
  };
}

function eventsReply(provinceName?: string): ChatReply {
  const events = demoEvents.filter((event) => !provinceName || event.province === provinceName);
  return {
    text: [
      events.length
        ? `Upcoming events${provinceName ? ` in ${provinceName}` : ""}: ${listJoin(events.map((event) => `${event.title} (${event.province})`))}.`
        : `There are no events listed in ${provinceName} yet.`,
      "Dates are still to be confirmed."
    ],
    links: [{ label: "See all events", href: "/events/" }],
    suggestions: ["Book the Rain Queen experience", "Plan a heritage trip"]
  };
}

function vendorsReply(): ChatReply {
  return {
    text: [
      `Our vendor directory lists ${demoVendors.length} sample artisan listings: ${listJoin(demoVendors.map((vendor) => `${vendor.businessName} (${vendor.town})`))}.`,
      "They also appear on the Explore map under Artisans & Vendors."
    ],
    links: [
      { label: "Find local vendors", href: "/vendors/" },
      { label: "Artisans on the map", href: "/explore/map/" }
    ],
    suggestions: ["What can I buy?", "Tell me about the clay vessel"]
  };
}

function heritageOverviewReply(): ChatReply {
  const communities = heritageEntries.filter((entry) => entry.type !== "Heritage destination");
  return {
    text: [
      `Our heritage library covers ${communities.length} communities across all nine provinces: ${listJoin(communities.map((entry) => entry.title))}.`,
      "Ask me about any of them, or about a province."
    ],
    links: [{ label: "Browse the heritage library", href: "/heritage/" }],
    suggestions: ["Tell me about the Vhavenda", "Which cultures live in the Northern Cape?", "Who is the Rain Queen?"]
  };
}

function mapReply(): ChatReply {
  return {
    text: [
      `The Explore map shows ${mapPlaces.filter((place) => !place.isSample).length} heritage sites, museums and cultural experiences across South Africa.`,
      "You can filter by province or category, or press Near me to sort places by distance from you."
    ],
    links: [{ label: "Open the Explore map", href: "/explore/map/" }],
    suggestions: ["Heritage sites in Gauteng", "Where is Mapungubwe?", "Museums in the Western Cape"]
  };
}

function aboutReply(): ChatReply {
  return {
    text: [
      "I'm Ask Catalyst, the Catalystic Wanders guide. I answer from the site's own heritage profiles, maps, marketplace and trip planner.",
      "Catalystic Wanders celebrates heritage in all nine provinces. Our first physical Hologram Hub is in Limpopo."
    ],
    links: [{ label: "About Catalystic Wanders", href: "/about/" }],
    suggestions: defaultSuggestions
  };
}

export const defaultSuggestions = ["Who is the Rain Queen?", "Which cultures live in Limpopo?", "What can I buy?", "Plan a heritage trip"];

export const welcomeReply: ChatReply = {
  text: [
    "Hi, I'm Ask Catalyst. I can tell you about South Africa's cultures and heritage sites, find places on the map, help you plan a trip, book the Hologram Hub or shop the marketplace."
  ],
  suggestions: defaultSuggestions
};

function helpReply(): ChatReply {
  return {
    text: [
      "Here's what I can help with:",
      "Cultures and languages, for example the Vatsonga or the Cape Malay community.",
      "Provinces and places, for example what to see in the Northern Cape.",
      "The Hologram Hub, sessions and booking.",
      "The marketplace and your cart, trip planning, food and events."
    ],
    suggestions: defaultSuggestions
  };
}

// Last resort: find the best keyword overlap across everything the site knows.
function searchReply(norm: string): { reply: ChatReply; context: ChatContext } | null {
  const words = norm.trim().split(" ").filter((word) => word.length >= 4);
  if (words.length === 0) return null;
  // Whole-word matches only, against names and key facts; matching every word of a summary
  // made unrelated questions ("the capital of France") land on Mapungubwe.
  const score = (text: string) => words.filter((word) => has(normalise(text), word)).length;

  const candidates = [
    ...heritageEntries.map((entry) => ({ score: score(`${entry.title} ${entry.subtitle} ${entry.knownFor.join(" ")}`), kind: "heritage" as const, id: entry.slug })),
    ...mapPlaces.filter((place) => !place.isSample).map((place) => ({ score: score(`${place.name} ${place.town}`), kind: "place" as const, id: place.id }))
  ].sort((a, b) => b.score - a.score);

  const best = candidates[0];
  if (!best || best.score === 0) return null;
  if (best.kind === "heritage") {
    const entry = heritageBySlug(best.id)!;
    return { reply: heritageReply(entry, {}), context: { heritage: entry.slug } };
  }
  const place = placeById(best.id)!;
  return { reply: placeReply(place), context: { place: place.id, province: provinceByName(place.province)?.slug } };
}

export function answer(question: string, previous: ChatContext, cart: CartSummary): { reply: ChatReply; context: ChatContext } {
  const norm = normalise(question);
  const scores = scoreIntents(norm);

  let heritage = findByAliases(norm, heritageAliases);
  let province = findByAliases(norm, provinceAliases);
  let place = findByAliases(norm, placeAliases);
  let product = findByAliases(norm, productAliases);

  // Follow-ups such as "where can I see it?" reuse what we were just talking about.
  const isFollowUp = followUpWords.some((word) => has(norm, word));
  if (!heritage && !province && !place && !product && isFollowUp) {
    heritage = previous.heritage;
    place = previous.place;
    product = previous.product;
    province = previous.province;
  }
  // "What else is in Limpopo?" should talk about the province, not the last culture.
  if (province && has(norm, "else")) heritage = undefined;

  const context: ChatContext = { heritage, province, place, product };
  const remember = (reply: ChatReply, extra: ChatContext = {}) => ({ reply, context: { ...previous, ...context, ...extra } });

  if (scores.cart > 0 && !product) return remember(cartReply(cart));
  if (product) return remember(productReply(productById(product)!), { product });
  if (scores.shop > 0 && !heritage && !province) return remember(shopReply());

  // Booking always means the Hologram Hub ("book the Rain Queen experience"); a plain
  // "Who is the Rain Queen?" falls through to the Balobedu profile instead.
  const bookingWords = ["book", "booking", "ticket", "tickets", "reserve", "reservation", "session", "sessions"].some((word) => has(norm, word));
  const hubWords = has(norm, "hologram") || has(norm, "hub") || has(norm, "exhibition") || (has(norm, "museum") && !province && !place);
  if (bookingWords) return remember(hologramReply(scores));
  if (scores.plan > 0) return remember(planReply(province));
  if (hubWords) return remember(hologramReply(scores));
  if (scores.food > 0 && !heritage) return remember(foodReply(provinceBySlug(province)?.name));
  if (scores.events > 0 && !heritage) return remember(eventsReply(provinceBySlug(province)?.name));

  if (heritage) return remember(heritageReply(heritageBySlug(heritage)!, scores), { heritage, place: undefined });
  if (place) return remember(placeReply(placeById(place)!), { place });
  if (province) return remember(provinceReply(province, scores), { province, heritage: undefined });

  if (scores.vendors > 0) return remember(vendorsReply());
  if (scores.map > 0) return remember(mapReply());
  if (scores.heritage > 0 || scores.language > 0) return remember(heritageOverviewReply());
  if (scores.about > 0) return remember(aboutReply());
  if (scores.help > 0) return remember(helpReply());
  if (scores.thanks > 0) return remember({ text: ["You're welcome. Is there anything else you'd like to explore?"], suggestions: defaultSuggestions });
  if (scores.greet > 0) return remember(welcomeReply);
  if (scores.price > 0) return remember(shopReply());

  const found = searchReply(norm);
  if (found) return { reply: found.reply, context: { ...previous, ...found.context } };

  return remember({
    text: [
      "I'm not sure about that one yet. I answer from Catalystic Wanders' own guides, so I know about South African cultures, heritage places, the Hologram Hub, the marketplace and trip planning."
    ],
    suggestions: defaultSuggestions
  });
}
