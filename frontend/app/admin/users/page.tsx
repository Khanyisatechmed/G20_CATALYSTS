import PlaceholderPage from "@/components/PlaceholderPage";

export default function AdminUsersPage() {
  return <PlaceholderPage eyebrow="Admin" title="User management" description="Demo module for role assignment and user oversight." modules={["Users", "Roles", "Profiles", "Status", "Audit log", "Access review"]} />;
}
