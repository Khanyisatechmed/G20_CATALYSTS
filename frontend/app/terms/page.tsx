import PlaceholderPage from "@/components/PlaceholderPage";

export default function TermsPage() {
  return (
    <PlaceholderPage
      eyebrow="Terms"
      title="Terms of service"
      description="Official terms will be added when approved. This route exists so the application shell has complete navigation."
      modules={["Visitor terms", "Vendor terms", "Bookings", "Orders", "Cancellations", "Content policy"]}
    />
  );
}
