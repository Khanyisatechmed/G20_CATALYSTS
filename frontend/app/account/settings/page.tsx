import PlaceholderPage from "@/components/PlaceholderPage";

export default function AccountSettingsPage() {
  return (
    <PlaceholderPage
      eyebrow="Account"
      title="Settings and preferences"
      description="Demo module for profile, language, accessibility and notification preferences."
      modules={["Profile", "Language", "Accessibility", "Notifications", "Privacy", "Security"]}
    />
  );
}
