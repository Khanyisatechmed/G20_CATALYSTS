"use client";

import Link from "next/link";
import { Menu, Search, ShoppingBag, UserRound, X } from "lucide-react";
import { usePathname } from "next/navigation";
import { useState } from "react";
import BrandLogo from "@/components/BrandLogo";
import { primaryNavigation } from "@/lib/navigation";
import { useCartStore } from "@/stores/cartStore";

export default function SiteHeader() {
  const [isOpen, setIsOpen] = useState(false);
  const pathname = usePathname();
  const totalItems = useCartStore((state) => state.totalItems());

  return (
    <header className="sticky top-0 z-40 rounded-b-[2rem] border-b border-brand-sage/20 bg-brand-ivory shadow-lg shadow-black/10">
      <div className="mx-auto flex max-w-[1800px] items-center justify-between gap-4 px-5 py-3 md:px-10">
        <div className="shrink-0 xl:max-w-[180px] 2xl:max-w-none">
          <BrandLogo />
        </div>

        <nav aria-label="Primary navigation" className="hidden items-center gap-5 xl:flex 2xl:gap-6">
          {primaryNavigation.map((item) => {
            const isActive = item.href === "/" ? pathname === "/" : pathname.startsWith(item.href);

            return (
              <Link
                key={item.href}
                href={item.href}
                className={[
                  "whitespace-nowrap border-b-2 py-2 text-sm font-bold transition",
                  isActive
                    ? "border-brand-forest text-brand-deep"
                    : "border-transparent text-black hover:text-brand-terracotta"
                ].join(" ")}
              >
                {item.label}
              </Link>
            );
          })}
        </nav>

        <div className="flex shrink-0 items-center gap-2">
          <Link
            href="/explore/map"
            aria-label="Open search"
            className="hidden rounded-full border border-brand-sage/50 p-2 text-brand-deep transition hover:border-brand-terracotta md:inline-flex xl:hidden 2xl:inline-flex"
          >
            <Search size={18} />
          </Link>
          <Link
            href="/cart"
            aria-label="View cart"
            className="relative rounded-full border border-brand-sage/50 p-2 text-brand-deep transition hover:border-brand-terracotta"
          >
            <ShoppingBag size={18} />
            {totalItems > 0 ? (
              <span className="absolute -right-1 -top-1 grid h-5 min-w-5 place-items-center rounded-full bg-brand-terracotta px-1 text-xs font-black text-white">
                {totalItems}
              </span>
            ) : null}
          </Link>
          <Link
            href="/account"
            aria-label="Account"
            className="hidden rounded-full border border-brand-sage/50 p-2 text-brand-deep transition hover:border-brand-terracotta md:inline-flex"
          >
            <UserRound size={18} />
          </Link>
          <Link
            href="/bookings/hologram"
            className="hidden whitespace-nowrap rounded-full bg-brand-forest px-7 py-3 text-sm font-bold text-white shadow-sm transition hover:bg-brand-deep lg:inline-flex xl:hidden 2xl:inline-flex"
          >
            Book Your Visit -&gt;
          </Link>
          <button
            type="button"
            aria-label={isOpen ? "Close menu" : "Open menu"}
            onClick={() => setIsOpen((value) => !value)}
            className="rounded-full border border-brand-sage/50 p-2 text-brand-deep xl:hidden"
          >
            {isOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>
      </div>

      {isOpen ? (
        <div className="border-t border-brand-sage/30 bg-brand-ivory px-4 py-4 xl:hidden">
          <nav className="grid gap-2" aria-label="Mobile navigation">
            {primaryNavigation.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setIsOpen(false)}
                className="rounded-xl px-4 py-3 font-semibold text-brand-deep hover:bg-brand-sage/20"
              >
                {item.label}
              </Link>
            ))}
            <Link
              href="/bookings/hologram"
              onClick={() => setIsOpen(false)}
              className="rounded-xl bg-brand-forest px-4 py-3 text-center font-bold text-white"
            >
              Book Your Visit -&gt;
            </Link>
          </nav>
        </div>
      ) : null}
    </header>
  );
}
