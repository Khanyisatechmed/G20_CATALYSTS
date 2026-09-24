import PlaceholderPage from "@/components/PlaceholderPage";

export default function AccountFavouritesPage() {
  return (
    <PlaceholderPage
      eyebrow="Account"
      title="Saved favourites"
      description="Demo module for saved destinations, products, vendors and itineraries."
      modules={["Products", "Heritage pages", "Vendors", "Food venues", "Events", "Itineraries"]}
    />
  );
}
