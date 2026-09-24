export type HeritageType = "Historical kingdom" | "Cultural community" | "Indigenous heritage" | "Heritage destination";

export type ImageCredit = {
  author: string;
  license: string;
  licenseUrl?: string;
  // Omitted for images supplied directly by the rights holder rather than sourced online.
  sourceUrl?: string;
};

export type HeritageEntry = {
  slug: string;
  title: string;
  subtitle: string;
  type: HeritageType;
  provinces: string[];
  language: string;
  knownFor: string[];
  image?: string;
  imageAlt: string;
  imageCaption?: string;
  // CSS object-position focal point for photos that need a custom crop (e.g. portrait shots).
  imagePosition?: string;
  imageCredit?: ImageCredit;
  summary: string;
  reviewStatus: "development-review" | "approved";
};

export type ProvinceEntry = {
  slug: string;
  name: string;
  image: string;
  summary: string;
  highlights: string[];
};

// Cultural communities are listed with the provinces where they are most rooted today.
// Many South Africans of every heritage live throughout the country, especially in Gauteng.
export const heritageEntries: HeritageEntry[] = [
  {
    slug: "zulu-heritage",
    title: "amaZulu",
    subtitle: "People of the Heavens",
    type: "Cultural community",
    provinces: ["KwaZulu-Natal", "Gauteng", "Mpumalanga"],
    language: "isiZulu",
    knownFor: ["Umkhosi woMhlanga (Reed Dance)", "Beadwork and basketry", "The Zulu Kingdom and Emakhosini valley"],
    image: "/images/heritage/emakhosini.png",
    imageAlt: "A traditional Zulu beehive dwelling (iqhugwane) woven from grass",
    summary:
      "isiZulu is South Africa's most widely spoken home language. The Zulu Kingdom rose to prominence under King Shaka in the early nineteenth century, and its royal heritage, beadwork, basketry, music and ceremonies such as Umkhosi woMhlanga remain central to life in KwaZulu-Natal.",
    reviewStatus: "development-review"
  },
  {
    slug: "xhosa",
    title: "amaXhosa",
    subtitle: "Culture and Resilience",
    type: "Cultural community",
    provinces: ["Eastern Cape", "Western Cape"],
    language: "isiXhosa",
    knownFor: ["Beadwork and ochre-dyed dress", "Iintsomi storytelling and praise poetry", "Ulwaluko initiation"],
    image: "/images/heritage/xhosa.jpg",
    imageAlt: "An elder woman in a mustard-yellow traditional garment and orange headwrap adjusts long strands of blue beadwork on a young man in a white beaded Xhosa outfit and beaded headband, outside a rural homestead in the Eastern Cape",
    imageCaption: "Xhosa beadwork and traditional dress, Eastern Cape",
    imageCredit: { author: "South African Tourism", license: "CC BY 2.0", licenseUrl: "https://creativecommons.org/licenses/by/2.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Xhosa_people,_Eastern_Cape,_South_Africa_(20518645211).jpg" },
    summary:
      "isiXhosa, with its distinctive click consonants, is spoken by the amaXhosa and related Xhosa-speaking peoples such as abaThembu and amaMpondo. Rooted in the Eastern Cape, Xhosa heritage is carried through beadwork, oral storytelling, praise poetry and rites of passage.",
    reviewStatus: "development-review"
  },
  {
    slug: "ndebele",
    title: "amaNdebele",
    subtitle: "Art, Identity and Expression",
    type: "Cultural community",
    provinces: ["Mpumalanga", "Limpopo", "Gauteng"],
    language: "isiNdebele",
    knownFor: ["Geometric house painting", "Beadwork and neck rings", "Artists such as Esther Mahlangu"],
    image: "/images/heritage/ndebele.jpg",
    imageAlt: "Ndebele homestead walls and facade painted in bold geometric patterns outlined in black, in blue, red, yellow, pink and ochre",
    imageCaption: "Ndebele painted homestead, Lesedi Cultural Village",
    imageCredit: { author: "Angela Abel", license: "CC BY 4.0", licenseUrl: "https://creativecommons.org/licenses/by/4.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Ndebele_Architecture.jpg" },
    summary:
      "The Southern Ndebele of Mpumalanga are celebrated worldwide for bold geometric wall painting and intricate beadwork, traditions largely kept by women and passed between generations. Northern Ndebele communities live mainly in Limpopo.",
    reviewStatus: "development-review"
  },
  {
    slug: "swati",
    title: "emaSwati",
    subtitle: "Heritage and Pride",
    type: "Cultural community",
    provinces: ["Mpumalanga"],
    language: "siSwati",
    knownFor: ["Umhlanga (Reed Dance)", "Royal ceremonies shared with Eswatini", "Grass weaving and crafts"],
    image: "/images/heritage/swati.jpg",
    imageAlt: "A smiling man in a black, white and red emahiya cloth and a beaded necklace at the Umhlanga Reed Dance, with women in red emahiya and tall reeds behind him",
    imageCaption: "Umhlanga Reed Dance, Eswatini (2006)",
    imageCredit: { author: "Amada44", license: "Public domain", licenseUrl: "https://commons.wikimedia.org/wiki/Template:PD-self", sourceUrl: "https://commons.wikimedia.org/wiki/File:Reed_Dance_Festival_2006-008.jpg" },
    summary:
      "siSwati-speaking South Africans live mainly in Mpumalanga, along the border with the Kingdom of Eswatini, with which they share language, clan names and royal ceremonial traditions such as Umhlanga.",
    reviewStatus: "development-review"
  },
  {
    slug: "basotho",
    title: "Basotho",
    subtitle: "Mountains and Majesty",
    type: "Cultural community",
    provinces: ["Free State", "Gauteng"],
    language: "Sesotho",
    knownFor: ["The Basotho blanket and mokorotlo hat", "Litema wall decoration", "Heritage founded under King Moshoeshoe I"],
    image: "/images/heritage/basotho.jpg",
    imageAlt: "A Mosotho horseman wrapped in a patterned yellow and green Basotho blanket rides a dark horse along a dirt road below green mountain slopes",
    imageCaption: "Basotho horseman in a traditional blanket, Lesotho",
    imageCredit: { author: "Martina Buchmann Schärli", license: "CC BY-SA 3.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/3.0/", sourceUrl: "https://commons.wikimedia.org/wiki/File:Basotho_blanket_lesotho.jpg" },
    summary:
      "Sesotho-speaking Basotho trace their nation to King Moshoeshoe I in the nineteenth century. In South Africa their heritage is strongest in the Free State, including QwaQwa and the Golden Gate highlands, where blankets, litema murals and mountain traditions endure.",
    reviewStatus: "development-review"
  },
  {
    slug: "bapedi",
    title: "Bapedi",
    subtitle: "Heritage of Sekhukhune",
    type: "Cultural community",
    provinces: ["Limpopo", "Mpumalanga", "Gauteng"],
    language: "Sepedi (Sesotho sa Leboa)",
    knownFor: ["Kiba reed-pipe music", "The Maroteng kingdom and King Sekhukhune I", "Sekhukhuneland heritage"],
    image: "/images/heritage/bapedi.jpg",
    imageAlt: "Women carrying clay pots on their heads in a Bapedi homestead courtyard with thatched rondavels and low walls painted with brown, black and white designs",
    imageCaption: "Bapedi homestead, Pedi Living Culture Route, Limpopo",
    imageCredit: { author: "South African Tourism", license: "CC BY 2.0", licenseUrl: "https://creativecommons.org/licenses/by/2.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Pedi_Living_Culture_Route,_Limpopo,_South_Africa_(2417712111).jpg" },
    summary:
      "The Bapedi of Sekhukhuneland, which spans Limpopo and Mpumalanga, are known for the Maroteng kingdom, whose King Sekhukhune I resisted colonial conquest in the 1870s. Kiba reed-pipe music and dance remain a proud expression of Pedi identity.",
    reviewStatus: "development-review"
  },
  {
    slug: "balobedu",
    title: "Balobedu",
    subtitle: "The Legacy of Modjadji",
    type: "Historical kingdom",
    provinces: ["Limpopo"],
    language: "Khilobedu",
    knownFor: ["The Modjadji Rain Queen", "Queenship passed through the female line", "The Modjadji cycad forest"],
    image: "/images/heritage/balobedu.jpg",
    imageAlt: "A stand of tall Modjadji cycads with feathery green fronds growing beside a lawn at the Modjadji Royal Kraal, under a clear sky",
    imageCaption: "Modjadji cycads at the Modjadji Royal Kraal, Limpopo",
    imageCredit: { author: "South African Tourism from South Africa", license: "CC BY 2.0", licenseUrl: "https://creativecommons.org/licenses/by/2.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Modjadji_Royal_Kraal,_Limpopo,_South_Africa_(5613276882).jpg" },
    summary:
      "The Balobedu of Bolobedu in Limpopo are led by the Modjadji, the Rain Queen, revered for her role in bringing rain. Their queenship, passed through the female line, is unique in southern Africa, and the ancient cycad forest near Modjadjiskloof is closely linked to her legacy.",
    reviewStatus: "development-review"
  },
  {
    slug: "batswana",
    title: "Batswana",
    subtitle: "Tradition and Progress",
    type: "Cultural community",
    provinces: ["North West", "Northern Cape", "Free State", "Gauteng"],
    language: "Setswana",
    knownFor: ["Communities such as the Bafokeng and Barolong", "Choral music and traditional dance", "Stone-walled settlements such as Kaditshwene"],
    image: "/images/heritage/batswana.jpg",
    imageAlt: "A troupe of Tswana dancers in traditional fringed skirts, headbands and ankle rattles performing on stage",
    imageCaption: "Tswana dancers performing, South Africa",
    imageCredit: { author: "Andrew Hall", license: "CC BY-SA 4.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/4.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Tswana_Dancers_3.jpg" },
    summary:
      "Setswana-speaking Batswana are rooted in the North West, with communities such as the Bafokeng of Phokeng and the Barolong of Mahikeng, and extend into the Northern Cape around Kuruman and into Thaba Nchu in the Free State. They share language and history with Botswana.",
    reviewStatus: "development-review"
  },
  {
    slug: "vatsonga",
    title: "Vatsonga",
    subtitle: "People of the Land",
    type: "Cultural community",
    provinces: ["Limpopo", "Mpumalanga", "Gauteng"],
    language: "Xitsonga",
    knownFor: ["Xibelani dance skirts", "Tinsimu songs and drumming", "Communities of Giyani and Bushbuckridge"],
    image: "/images/heritage/vatsonga-region-studio.jpg",
    imageAlt: "Close-up of a woman's traditional Tsonga attire: a striped orange and blue skirt trimmed with ribbons, layered bead belts and beaded bangles on both wrists",
    imageCaption: "Traditional Xitsonga attire and beadwork",
    imagePosition: "center 35%",
    imageCredit: { author: "Region Studio", license: "All rights reserved" },
    summary:
      "Xitsonga-speaking Vatsonga, including Shangaan communities, live mainly in Limpopo around Giyani and in Mpumalanga around Bushbuckridge. Their heritage is famous for the swaying xibelani skirt dance, vibrant cloth, music and strong ties to Mozambique.",
    reviewStatus: "development-review"
  },
  {
    slug: "vhavenda",
    title: "Vhavenda",
    subtitle: "Culture and Creativity",
    type: "Cultural community",
    provinces: ["Limpopo"],
    language: "Tshivenda",
    knownFor: ["Lake Fundudzi, a sacred lake", "The domba dance", "Pottery and woodcarving"],
    image: "/images/heritage/vhavenda.jpg",
    imageAlt: "Thatched Venda rondavels and a flat-roofed house in a green hillside village near Thohoyandou",
    imageCaption: "Venda traditional homestead near Thohoyandou, Limpopo",
    imageCredit: { author: "Azwi", license: "CC BY-SA 3.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/3.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Venda_Traditional_household_-_panoramio.jpg" },
    summary:
      "The Vhavenda live among the Soutpansberg mountains of far northern Limpopo. Sacred sites such as Lake Fundudzi, the domba dance, and celebrated pottery and woodcarving make Venda one of South Africa's richest cultural landscapes.",
    reviewStatus: "development-review"
  },
  {
    slug: "khoi-san-heritage",
    title: "Khoikhoi and San",
    subtitle: "First Peoples of Southern Africa",
    type: "Indigenous heritage",
    provinces: ["Northern Cape", "Western Cape", "Eastern Cape"],
    language: "Khoe and San languages, including N|uu",
    knownFor: ["Ancient rock art", "Deep knowledge of land and plants", "Communities such as the ≠Khomani San"],
    image: "/images/heritage/khoi-san-heritage.jpg",
    imageAlt: "San rock paintings of a line of elephants and small human figures in red ochre on a sandstone overhang in the Cederberg",
    imageCaption: "San rock art near Stadsaal Caves, Cederberg, Western Cape",
    imageCredit: { author: "Nina R from Africa", license: "CC BY 2.0", licenseUrl: "https://creativecommons.org/licenses/by/2.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Cederberg,_Western_Cape_(52072307997).jpg" },
    summary:
      "The San, hunter-gatherers, and the Khoikhoi, herders, are the first peoples of southern Africa. Their rock art is found across the country, and communities such as the ≠Khomani San of the Kalahari continue to protect their languages and knowledge of the land.",
    reviewStatus: "development-review"
  },
  {
    slug: "nama",
    title: "Nama",
    subtitle: "Keepers of the Richtersveld",
    type: "Indigenous heritage",
    provinces: ["Northern Cape"],
    language: "Khoekhoegowab (Nama)",
    knownFor: ["Matjieshuise, portable reed-mat homes", "Seasonal herding in the Richtersveld", "The Richtersveld World Heritage Site"],
    image: "/images/heritage/nama.jpg",
    imageAlt: "Two dome-shaped Nama matjieshuise (reed-mat houses) on green grass among trees at Leliefontein in the Kamiesberg",
    imageCaption: "Nama matjieshuise at Leliefontein, Kamiesberg, Namaqualand",
    imageCredit: { author: "LBM1948", license: "CC BY-SA 4.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/4.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Sur%C3%A1frica,_Kamiesberg_6.jpg" },
    summary:
      "The Nama are Khoekhoe-speaking herders of the Northern Cape. In the Richtersveld Cultural and Botanical Landscape, a UNESCO World Heritage Site, they continue seasonal grazing and build matjieshuise, portable homes of reed mats.",
    reviewStatus: "development-review"
  },
  {
    slug: "griqua",
    title: "Griqua",
    subtitle: "A Journeying People",
    type: "Indigenous heritage",
    provinces: ["Northern Cape", "Free State", "KwaZulu-Natal", "Western Cape"],
    language: "Afrikaans",
    knownFor: ["Griquatown, Philippolis and Kokstad", "Leaders such as Adam Kok III", "Hymns and church heritage"],
    image: "/images/heritage/griqua.jpg",
    imageAlt: "The thatched, stone-walled Old Mission House in Griekwastad, now the Mary Moffat Museum, under a clear blue sky",
    imageCaption: "Mary Moffat Museum (Old Mission House), Griekwastad",
    imageCredit: { author: "Andrew Hall", license: "CC BY-SA 3.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/3.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Mary_Moffat_Museum_(Old_Mission_House),_Griquastad.jpg" },
    summary:
      "The Griqua emerged from Khoekhoe and mixed-descent communities of the Cape and established settlements at Griquatown, Philippolis and, after a long trek led by Adam Kok III, at Kokstad in Griqualand East.",
    reviewStatus: "development-review"
  },
  {
    slug: "cape-malay",
    title: "Cape Malay",
    subtitle: "Spice, Faith and Song",
    type: "Cultural community",
    provinces: ["Western Cape"],
    language: "Afrikaans and English",
    knownFor: ["The Bo-Kaap and Auwal Mosque", "Cape Malay cuisine", "Malay choirs"],
    image: "/images/heritage/cape-malay.jpg",
    imageAlt: "A row of brightly painted pink, green, lilac and blue terraced houses on a sloping street in the Bo-Kaap, Cape Town",
    imageCaption: "Bo-Kaap, Cape Town",
    imageCredit: { author: "South African Tourism", license: "CC BY 2.0", licenseUrl: "https://creativecommons.org/licenses/by/2.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Bo-Kaap_-_Cape_Town,_South_Africa_(3883775540).jpg" },
    summary:
      "Cape Malay heritage began with enslaved people and political exiles brought to the Cape from Southeast Asia by the Dutch East India Company. Centred on Cape Town's Bo-Kaap, it gave South Africa the Auwal Mosque, founded in 1794, and a much-loved cuisine.",
    reviewStatus: "development-review"
  },
  {
    slug: "indian-south-africans",
    title: "Indian South Africans",
    subtitle: "Heritage Across Oceans",
    type: "Cultural community",
    provinces: ["KwaZulu-Natal", "Gauteng"],
    language: "English, with Tamil, Hindi, Gujarati, Telugu and Urdu heritage",
    knownFor: ["Temples and mosques of Durban", "Durban curry and bunny chow", "Diwali and Kavadi festivals"],
    image: "/images/heritage/indian-south-africans.jpg",
    imageAlt: "The white and pale-blue Narainsamy Hindu Temple in Newlands, Durban, with its carved tower and decorated entrance, at dusk",
    imageCaption: "Narainsamy Temple, Newlands, Durban",
    imageCredit: { author: "Janek Szymanowski", license: "CC BY-SA 3.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/3.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:9_2_412_0009-Narainsamy_Temple-Newlands-Durban-s.jpg" },
    summary:
      "Indian South Africans descend largely from indentured workers who arrived in Natal from 1860 and from traders who followed. Durban is the heart of the community, with temples, mosques, markets and a cuisine that is now part of national identity.",
    reviewStatus: "development-review"
  },
  {
    slug: "afrikaner",
    title: "Afrikaners",
    subtitle: "Language of the Land",
    type: "Cultural community",
    provinces: ["Western Cape", "Free State", "North West", "Gauteng", "Northern Cape"],
    language: "Afrikaans",
    knownFor: ["The Afrikaans Language Monument, Paarl", "Cape Dutch architecture", "Boerekos and braai traditions"],
    image: "/images/heritage/afrikaner.jpg",
    imageAlt: "The tall concrete spires of the Afrikaans Language Monument rising above trees and lawns against a blue sky in Paarl",
    imageCaption: "Afrikaans Language Monument (Taalmonument), Paarl",
    imageCredit: { author: "Missysimons", license: "CC BY-SA 3.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/3.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Afrikaans_Taalmonument.jpg" },
    summary:
      "Afrikaners descend mainly from Dutch, German and French Huguenot settlers at the Cape. Afrikaans, which developed at the Cape with influences from Malay, Khoekhoe and other languages, is shared with many other South Africans.",
    reviewStatus: "development-review"
  },
  {
    slug: "coloured-communities",
    title: "Coloured Communities",
    subtitle: "Many Roots, One Rhythm",
    type: "Cultural community",
    provinces: ["Western Cape", "Northern Cape", "Eastern Cape"],
    language: "Afrikaans (including Kaaps) and English",
    knownFor: ["The Cape Town Minstrel Carnival", "District Six memory and heritage", "Ghoema music"],
    image: "/images/heritage/coloured-communities.jpg",
    imageAlt: "A minstrel troupe in matching red and white satin suits and red hats marching with tambourines through Cape Town, with Table Mountain behind",
    imageCaption: "Cape Town Minstrel Carnival (Kaapse Klopse)",
    imageCredit: { author: "South African Tourism", license: "CC BY 2.0", licenseUrl: "https://creativecommons.org/licenses/by/2.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Minstrels_-_South_Africa_(3610757472).jpg" },
    summary:
      "South Africa's Coloured communities have roots in Khoekhoe, enslaved Asian and African, and European ancestry. Their heritage lives in Kaaps, ghoema music, the Tweede Nuwe Jaar Minstrel Carnival and the memory of places such as District Six.",
    reviewStatus: "development-review"
  },
  {
    slug: "mapungubwe",
    title: "Mapungubwe",
    subtitle: "An Ancient African Kingdom",
    type: "Heritage destination",
    provinces: ["Limpopo"],
    language: "Heritage site",
    knownFor: ["The Golden Rhino", "UNESCO World Heritage Site", "Limpopo and Shashe confluence"],
    image: "/images/heritage/mapungubwe.jpg",
    imageAlt: "The sandstone plateau of Mapungubwe Hill lit by evening sun beneath fiery red clouds, with grassland in the foreground",
    imageCaption: "Mapungubwe Hill, Mapungubwe Cultural Landscape, Limpopo",
    imageCredit: { author: "Marius Loots", license: "CC BY-SA 3.0", licenseUrl: "https://creativecommons.org/licenses/by-sa/3.0", sourceUrl: "https://commons.wikimedia.org/wiki/File:Mapungubwe_hill_limpopo.jpg" },
    summary:
      "Mapungubwe was the capital of southern Africa's first known kingdom, which flourished from about 1220 to 1290. Its archaeological finds, including the famous golden rhino, are protected in the Mapungubwe Cultural Landscape World Heritage Site.",
    reviewStatus: "development-review"
  }
];

export const provinces: ProvinceEntry[] = [
  {
    slug: "eastern-cape",
    name: "Eastern Cape",
    image: "/images/hero/south-africa-heritage.jpg",
    summary:
      "Coastal landscapes, heritage routes, cultural communities and educational travel experiences.",
    highlights: ["Coastline", "Heritage routes", "Living traditions"]
  },
  {
    slug: "free-state",
    name: "Free State",
    image: "/images/provinces/free-state.png",
    summary:
      "Sandstone landscapes, mountain heritage, Basotho cultural experiences and historic towns.",
    highlights: ["Sandstone cliffs", "Mountain heritage", "Cultural villages"]
  },
  {
    slug: "gauteng",
    name: "Gauteng",
    image: "/images/hero/south-africa-heritage.jpg",
    summary:
      "Urban heritage, museums, food markets, creative districts and freedom history.",
    highlights: ["Museums", "Urban culture", "Markets"]
  },
  {
    slug: "kwazulu-natal",
    name: "KwaZulu-Natal",
    image: "/images/heritage/emakhosini.png",
    summary:
      "Heritage landscapes, coastal cities, craft traditions, cuisine and cultural tourism routes.",
    highlights: ["Heritage sites", "Craft", "Coast"]
  },
  {
    slug: "limpopo",
    name: "Limpopo",
    image: "/images/hologram-hub/hologram-hub.png",
    summary:
      "Home to the first Catalystic Wanders Hologram Hub and a gateway to layered northern heritage experiences.",
    highlights: ["Hologram Hub", "Balobedu exhibition", "Mapungubwe"]
  },
  {
    slug: "mpumalanga",
    name: "Mpumalanga",
    image: "/images/provinces/mpumalanga.png",
    summary:
      "Dramatic landscapes, wildlife corridors, craft stops and scenic travel experiences.",
    highlights: ["Wildlife", "Scenic routes", "Artisans"]
  },
  {
    slug: "northern-cape",
    name: "Northern Cape",
    image: "/images/heritage/khoi-san.png",
    summary:
      "Wide landscapes, indigenous heritage, stargazing, desert travel and cultural memory.",
    highlights: ["Indigenous heritage", "Desert landscapes", "Rock art"]
  },
  {
    slug: "north-west",
    name: "North West",
    image: "/images/hero/south-africa-heritage.jpg",
    summary:
      "Heritage towns, craft communities, nature reserves and regional food experiences.",
    highlights: ["Craft", "Nature", "Regional food"]
  },
  {
    slug: "western-cape",
    name: "Western Cape",
    image: "/images/provinces/western-cape.png",
    summary:
      "Museums, coastlines, food culture, layered histories and heritage destinations.",
    highlights: ["Museums", "Food", "Coastline"]
  }
];

export const exhibitions = [
  {
    slug: "balobedu-rain-queen",
    title: "Balobedu Rain Queen Hologram Experience",
    focus: "Balobedu heritage",
    duration: "45 minutes",
    languages: ["English", "Sepedi support planned"],
    reviewStatus: "development-review"
  },
  {
    slug: "future-national-heritage",
    title: "Future National Heritage Exhibitions",
    focus: "South African heritage",
    duration: "Configurable",
    languages: ["To be reviewed"],
    reviewStatus: "development-review"
  }
];
