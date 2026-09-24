import Image from "next/image";
import Link from "next/link";

type BrandLogoProps = {
  variant?: "nav" | "hero";
};

export default function BrandLogo({ variant = "nav" }: BrandLogoProps) {
  const isHero = variant === "hero";

  return (
    <Link
      href="/"
      aria-label="Catalystic Wanders home"
      className={[
        "inline-flex w-fit items-center rounded-xl outline-none transition focus:ring-2 focus:ring-brand-terracotta focus:ring-offset-2 focus:ring-offset-brand-ivory",
        isHero ? "max-w-[720px]" : "max-w-[190px] md:max-w-[230px]"
      ].join(" ")}
    >
      <Image
        src="/branding/logo.png"
        alt="Catalystic Wanders"
        width={2067}
        height={761}
        priority={isHero}
        className={[
          "h-auto w-full object-contain",
          isHero
            ? "drop-shadow-[0_28px_70px_rgba(0,0,0,0.58)]"
            : "drop-shadow-[0_10px_20px_rgba(0,0,0,0.16)]"
        ].join(" ")}
      />
    </Link>
  );
}
