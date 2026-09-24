"use client";

import Image from "next/image";
import Link from "next/link";
import { ArrowRight, PackageCheck, ShoppingBasket, Trash2 } from "lucide-react";
import { useCartStore } from "@/stores/cartStore";
import { asset } from "@/lib/basePath";

export default function CartPage() {
  const items = useCartStore((state) => state.items);
  const updateQuantity = useCartStore((state) => state.updateQuantity);
  const removeItem = useCartStore((state) => state.removeItem);
  const clearCart = useCartStore((state) => state.clearCart);
  const totalPrice = useCartStore((state) => state.totalPrice());

  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-30" style={{ backgroundImage: `url(${asset("/images/zulubasket.png")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-brand-deep/78 to-brand-deep/35" />
        <div className="relative mx-auto min-h-[340px] max-w-[1800px] px-6 py-16 text-white md:px-20">
          <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">Cart</p>
          <h1 className="mt-5 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl">Your marketplace basket</h1>
          <p className="mt-5 max-w-2xl text-lg leading-8 text-white/82">
            Review selected craft products before moving into the demo checkout flow.
          </p>
        </div>
      </section>

      <section className="mx-auto max-w-[1400px] px-6 py-12 md:px-20">
        {items.length === 0 ? (
          <div className="rounded-xl border border-brand-sage/30 bg-white p-10 text-center shadow-sm">
            <ShoppingBasket className="mx-auto text-brand-terracotta" size={42} />
            <h2 className="mt-5 font-serif text-4xl font-black text-brand-deep">Your cart is empty.</h2>
            <p className="mx-auto mt-3 max-w-xl leading-7 text-brand-deep/70">
              Add a 3D-enabled craft item from the marketplace to preview the cart and checkout journey.
            </p>
            <Link href="/marketplace" className="mt-7 inline-flex items-center gap-3 rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
              Browse marketplace <ArrowRight size={17} />
            </Link>
          </div>
        ) : (
          <div className="grid gap-8 md:grid-cols-[1fr_380px]">
            <div className="space-y-4">
              {items.map((item) => (
                <article key={item.id} className="grid gap-4 rounded-xl border border-brand-sage/25 bg-white p-4 shadow-sm sm:grid-cols-[150px_1fr]">
                  {item.imageUrl ? (
                    <Image src={item.imageUrl} alt={item.title} width={320} height={320} className="h-40 w-full rounded-lg object-cover" />
                  ) : null}
                  <div className="flex flex-col justify-between gap-5">
                    <div>
                      <h2 className="font-serif text-3xl font-black text-brand-deep">{item.title}</h2>
                      <p className="mt-1 font-semibold text-brand-forest">{item.artisan}</p>
                      <p className="mt-2 text-brand-deep/70">R {item.price.toLocaleString("en-ZA")} each</p>
                    </div>
                    <div className="flex flex-wrap items-center gap-3">
                      <input
                        type="number"
                        min={1}
                        value={item.quantity}
                        onChange={(event) => updateQuantity(item.id, Number(event.target.value))}
                        className="w-24 rounded-xl border border-brand-sage/50 px-4 py-2"
                        aria-label={`Quantity for ${item.title}`}
                      />
                      <button type="button" onClick={() => removeItem(item.id)} className="flex items-center gap-2 font-bold text-brand-terracotta">
                        <Trash2 size={16} /> Remove
                      </button>
                    </div>
                  </div>
                </article>
              ))}
            </div>

            <aside className="h-fit rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm">
              <PackageCheck className="text-brand-terracotta" size={32} />
              <h2 className="mt-4 font-serif text-3xl font-black text-brand-deep">Order summary</h2>
              <div className="mt-6 flex justify-between border-t border-brand-sage/30 pt-5 text-lg">
                <span>Demo total</span>
                <strong>R {totalPrice.toLocaleString("en-ZA")}</strong>
              </div>
              <p className="mt-4 text-sm leading-6 text-brand-deep/60">
                Frontend cart totals are for demo only. Production checkout must validate stock, vendor fulfilment and payment server-side.
              </p>
              <Link href="/checkout" className="mt-6 flex items-center justify-center gap-2 rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
                Continue to checkout <ArrowRight size={17} />
              </Link>
              <button type="button" onClick={clearCart} className="mt-4 w-full font-bold text-brand-terracotta">
                Clear cart
              </button>
            </aside>
          </div>
        )}
      </section>
    </main>
  );
}
