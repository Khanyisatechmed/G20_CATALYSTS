import Link from "next/link";
import BrandLogo from "@/components/BrandLogo";
import { primaryNavigation } from "@/lib/navigation";

export default function SiteFooter() {
  return (
    <footer className="border-t border-brand-sage/30 bg-[#eef0e3]">
      <div className="mx-auto grid max-w-[1800px] gap-10 px-6 pb-28 pt-12 md:grid-cols-[1.2fr_1fr_1fr] md:px-20">
        <div>
          <BrandLogo />
          <p className="mt-5 max-w-md leading-7 text-brand-deep/80">
            Catalystic Wanders is being built as a national South African
            heritage tourism, immersive museum, and cultural commerce platform.
          </p>
          <p className="mt-4 text-sm font-semibold uppercase tracking-[0.22em] text-brand-terracotta">
            One country. Many cultures. Countless stories.
          </p>
        </div>

        <div>
          <h2 className="text-sm font-black uppercase tracking-[0.2em] text-brand-deep">
            Explore
          </h2>
          <div className="mt-4 grid gap-2">
            {primaryNavigation.slice(1, 7).map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="text-sm font-semibold text-brand-deep/75 hover:text-brand-terracotta"
              >
                {item.label}
              </Link>
            ))}
          </div>
        </div>

        <div>
          <h2 className="text-sm font-black uppercase tracking-[0.2em] text-brand-deep">
            Information
          </h2>
          <div className="mt-4 grid gap-2 text-sm font-semibold text-brand-deep/75">
            <Link href="/privacy" className="hover:text-brand-terracotta">
              Privacy
            </Link>
            <Link href="/terms" className="hover:text-brand-terracotta">
              Terms
            </Link>
            <p>Contact details will be added when officially approved.</p>
          </div>
        </div>
      </div>
    </footer>
  );
}
