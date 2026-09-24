import PlaceholderPage from "@/components/PlaceholderPage";

export default function VendorOrdersPage() {
  return (
    <PlaceholderPage
      eyebrow="Vendor"
      title="Order fulfilment"
      description="Demo fulfilment queue for vendor-specific orders."
      modules={["New orders", "Pack items", "Fulfilment updates", "Customer privacy", "Refund status", "Analytics"]}
    />
  );
}
