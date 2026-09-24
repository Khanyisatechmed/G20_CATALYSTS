import PlaceholderPage from "@/components/PlaceholderPage";

export default function AdminOrdersPage() {
  return <PlaceholderPage eyebrow="Admin" title="Order oversight" description="Demo module for order status, payment verification and fulfilment oversight." modules={["Orders", "Payments", "Vendors", "Shipment", "Refunds", "Disputes"]} />;
}
