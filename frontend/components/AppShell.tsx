import AskCatalyst from "@/components/AskCatalyst";
import CartHydrator from "@/components/CartHydrator";
import SiteFooter from "@/components/SiteFooter";
import SiteHeader from "@/components/SiteHeader";

export default function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <>
      <CartHydrator />
      <SiteHeader />
      {children}
      <SiteFooter />
      <AskCatalyst />
    </>
  );
}
