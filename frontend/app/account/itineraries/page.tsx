import PlaceholderPage from "@/components/PlaceholderPage";

export default function AccountItinerariesPage() {
  return (
    <PlaceholderPage
      eyebrow="Account"
      title="Saved itineraries"
      description="Demo module for saved and shareable heritage routes."
      modules={["Draft trips", "Shared trips", "Editable days", "Museum stops", "Food stops", "Marketplace stops"]}
    />
  );
}
