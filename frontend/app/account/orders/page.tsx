import PlaceholderPage from "@/components/PlaceholderPage";

export default function AccountOrdersPage() {
  return (
    <PlaceholderPage
      eyebrow="Account"
      title="Order history"
      description="Demo module for marketplace order history, payment status and fulfilment tracking."
      modules={["Draft orders", "Paid orders", "Vendor fulfilment", "Delivery status", "Refund status", "Reviews"]}
    />
  );
}
