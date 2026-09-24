import Link from "next/link";
import { ArrowRight, Heart, Map, ShoppingBasket } from "lucide-react";
import DemoLoginPanel from "@/components/DemoLoginPanel";
import { asset } from "@/lib/basePath";

export default function RegisterPage() {
  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-35" style={{ backgroundImage: `url(${asset("/images/hologram-hub/hologram-hub.png")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-brand-deep/78 to-brand-deep/35" />
        <div className="relative mx-auto grid min-h-[520px] max-w-[1800px] items-center gap-10 px-6 py-16 lg:grid-cols-[minmax(0,1fr)_430px] md:px-20">
          <div className="text-white">
            <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">Register</p>
            <h1 className="mt-5 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl">Create a demo visitor profile.</h1>
            <p className="mt-6 max-w-2xl text-lg leading-8 text-white/82">
              Registration is represented by the demo role switcher until secure auth, email verification and profile storage are connected.
            </p>
            <Link href="/plan-your-visit" className="mt-8 inline-flex items-center gap-3 rounded-xl bg-brand-sand px-6 py-3 font-bold text-brand-deep">
              Start planning <ArrowRight size={18} />
            </Link>
          </div>
          <DemoLoginPanel />
        </div>
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-5 px-6 py-10 md:grid-cols-3 md:px-20">
        {[
          ["Save favourites", "Keep products, destinations and vendors together.", Heart],
          ["Build itineraries", "Turn interests into a demo travel plan.", Map],
          ["Shop crafts", "Use the cart flow with selected marketplace items.", ShoppingBasket]
        ].map(([title, text, Icon]) => (
          <article key={title as string} className="rounded-xl bg-white p-6 shadow-sm">
            <Icon className="text-brand-terracotta" size={26} />
            <h2 className="mt-4 font-serif text-2xl font-black text-brand-deep">{title as string}</h2>
            <p className="mt-2 leading-7 text-brand-deep/70">{text as string}</p>
          </article>
        ))}
      </section>
    </main>
  );
}
