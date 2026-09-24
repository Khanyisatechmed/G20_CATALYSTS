import PlaceholderPage from "@/components/PlaceholderPage";

export default function AdminBookingsPage() {
  return <PlaceholderPage eyebrow="Admin" title="Booking management" description="Demo booking oversight for reservations, capacity and ticketing." modules={["Reservations", "Capacity", "Payment status", "QR tickets", "Check-in", "Cancellations"]} />;
}
