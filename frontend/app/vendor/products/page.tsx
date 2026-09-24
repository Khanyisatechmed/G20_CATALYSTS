import PlaceholderPage from "@/components/PlaceholderPage";

export default function VendorProductsPage() {
  return (
    <PlaceholderPage
      eyebrow="Vendor"
      title="Product management"
      description="Demo vendor product workflow for creation, imagery, model upload, inventory and moderation status."
      modules={["Create product", "Upload images", "Attach 3D model", "Inventory", "Moderation", "Cultural notes"]}
    />
  );
}
