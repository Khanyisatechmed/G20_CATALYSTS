import PlaceholderPage from "@/components/PlaceholderPage";

export default function PrivacyPage() {
  return (
    <PlaceholderPage
      eyebrow="Privacy"
      title="Privacy and data protection"
      description="Privacy terms will be completed with approved legal guidance and POPIA-aligned data handling."
      modules={["Data minimisation", "Location consent", "Vendor privacy", "Retention", "User controls", "Security"]}
    />
  );
}
