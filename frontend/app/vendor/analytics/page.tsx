import PlaceholderPage from "@/components/PlaceholderPage";

export default function VendorAnalyticsPage() {
  return (
    <PlaceholderPage
      eyebrow="Vendor"
      title="Sales analytics"
      description="Demo analytics overview. Production analytics must use real order data only."
      modules={["Sales", "Inventory", "Popular products", "Province reach", "Fulfilment", "Reviews"]}
    />
  );
}
