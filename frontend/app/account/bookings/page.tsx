import PlaceholderPage from "@/components/PlaceholderPage";

export default function AccountBookingsPage() {
  return (
    <PlaceholderPage
      eyebrow="Account"
      title="Booking history and ticket management"
      description="Demo module for booking history, cancellation, rescheduling and QR ticket access."
      modules={["Upcoming bookings", "Past visits", "QR tickets", "Reschedule", "Cancel policy", "Payment status"]}
    />
  );
}
