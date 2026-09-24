import Link from "next/link";
import { ArrowRight, Compass } from "lucide-react";

export default function NotFound() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-brand-ivory px-6 py-20 text-center">
      <section className="max-w-2xl rounded-xl border border-brand-sage/30 bg-white p-10 shadow-sm">
        <Compass className="mx-auto text-brand-terracotta" size={46} />
        <p className="mt-5 text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">
          Not found
        </p>
        <h1 className="mt-4 font-serif text-5xl font-black text-brand-deep">
          This route is not part of the current journey.
        </h1>
        <p className="mt-4 leading-7 text-brand-deep/70">
          Return to the showcase homepage or explore the main heritage, marketplace and planning areas.
        </p>
        <Link href="/" className="mt-8 inline-flex items-center gap-3 rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
          Go home <ArrowRight size={17} />
        </Link>
      </section>
    </main>
  );
}
