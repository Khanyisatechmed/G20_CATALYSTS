import PlaceholderPage from "@/components/PlaceholderPage";

export default function VendorProfilePage() {
  return (
    <PlaceholderPage
      eyebrow="Vendor"
      title="Business profile"
      description="Demo profile editor for public business information, approved location and operating hours."
      modules={["Business details", "Operating hours", "Public location", "Contact options", "Images", "Verification"]}
    />
  );
}
