export type MarketplaceProduct = {
  id: string;
  title: string;
  artisan: string;
  price: number;
  currency: "ZAR";
  modelUrl: string;
  imageUrl: string;
  region: string;
  materials: string[];
  description: string;
  culturalSignificance: string;
};

export const marketplaceProducts: MarketplaceProduct[] = [
  {
    id: "zulu-hat",
    title: "Traditional Zulu Hat",
    artisan: "Sipho Dlamini",
    price: 280,
    currency: "ZAR",
    modelUrl: "/models/ZuluHat.glb",
    imageUrl: "/images/marketplace/zulu-hat.png",
    region: "KwaZulu-Natal",
    materials: ["woven fibre", "glass beads", "cotton thread"],
    description:
      "A ceremonial Zulu-inspired hat with layered beadwork, woven texture, and a silhouette made for heritage display and modern styling.",
    culturalSignificance:
      "The piece references protection, ceremony, and regional identity while supporting artisan-led craft preservation."
  },
  {
    id: "zulu-ikhamba",
    title: "Zulu Ikhamba Clay Vessel",
    artisan: "Mandla Mthembu",
    price: 350,
    currency: "ZAR",
    modelUrl: "/models/ZuluIkhamba.glb",
    imageUrl: "/images/marketplace/zulu-ikhamba.png",
    region: "Drakensberg Foothills",
    materials: ["local clay", "natural pigment", "burnished finish"],
    description:
      "A hand-shaped clay vessel inspired by traditional utility pottery, designed as both a cultural artifact and a sculptural home object.",
    culturalSignificance:
      "Ikhamba forms connect everyday gathering, hospitality, and earth materials with the living memory of domestic craft."
  }
];

export function getProductById(id: string) {
  return marketplaceProducts.find((product) => product.id === id);
}
