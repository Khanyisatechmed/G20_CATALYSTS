import type { Metadata } from "next";
import AppShell from "@/components/AppShell";
import "./globals.css";

export const metadata: Metadata = {
  title: "Catalystic Wanders",
  description:
    "South African heritage tourism, immersive museum experiences, and cultural commerce.",
  openGraph: {
    title: "Catalystic Wanders",
    description:
      "Discover South Africa's living heritage through immersive experiences, local artisans and innovation.",
    type: "website"
  }
};

export default function RootLayout({
  children
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        <AppShell>{children}</AppShell>
      </body>
    </html>
  );
}
