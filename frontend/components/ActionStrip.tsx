import Link from "next/link";
import type { LucideIcon } from "lucide-react";

type ActionStripItem = {
  title: string;
  subtitle: string;
  href: string;
  icon: LucideIcon;
};

export default function ActionStrip({ items }: { items: ActionStripItem[] }) {
  return (
    <section className="border-b border-brand-sage/25 bg-brand-ivory shadow-sm">
      <div className="mx-auto grid max-w-[1800px] divide-y divide-brand-sage/35 px-6 md:grid-cols-5 md:divide-x md:divide-y-0 md:px-16">
        {items.map((item) => {
          const Icon = item.icon;
          return (
            <Link
              key={item.title}
              href={item.href}
              className="flex items-center gap-5 py-5 transition hover:bg-white/60 md:px-5"
            >
              <Icon className="shrink-0 text-brand-terracotta" size={42} strokeWidth={1.7} />
              <span>
                <strong className="block text-base text-black">{item.title}</strong>
                <span className="text-sm text-black/60">{item.subtitle}</span>
              </span>
            </Link>
          );
        })}
      </div>
    </section>
  );
}
