"use client";

import Link from "next/link";
import { CheckCircle2, CreditCard, LockKeyhole, Truck } from "lucide-react";
import { useState } from "react";
import { useCartStore } from "@/stores/cartStore";
import { asset } from "@/lib/basePath";

export default function CheckoutPage() {
  const [confirmed, setConfirmed] = useState(false);
  const items = useCartStore((state) => state.items);
  const totalPrice = useCartStore((state) => state.totalPrice());

  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-30" style={{ backgroundImage: `url(${asset("/images/zulubasket.png")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/82 via-brand-deep/78 to-brand-deep/35" />
        <div className="relative mx-auto min-h-[330px] max-w-[1800px] px-6 py-16 text-white md:px-20">
          <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">Checkout</p>
          <h1 className="mt-5 max-w-4xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl">Secure demo checkout flow</h1>
          <p className="mt-5 max-w-2xl text-lg leading-8 text-white/82">
            A polished checkout shell showing order review, fulfilment expectations and payment readiness without live payment processing.
          </p>
        </div>
      </section>

      <section className="mx-auto grid max-w-[1500px] gap-8 px-6 py-12 lg:grid-cols-[minmax(0,1fr)_420px] md:px-20">
        <div className="grid gap-5">
          {[
            ["Customer details", "Visitor profile, delivery address and contact verification will connect through secure account services.", LockKeyhole],
            ["Payment", "Production payment must be tokenized, server-verified and reconciled with stock and vendor fulfilment.", CreditCard],
            ["Delivery", "Shipping options can combine courier delivery, pickup points and cultural hub collection.", Truck]
          ].map(([title, text, Icon]) => (
            <article key={title as string} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
              <Icon className="text-brand-terracotta" size={28} />
              <h2 className="mt-4 font-serif text-3xl font-black text-brand-deep">{title as string}</h2>
              <p className="mt-3 leading-7 text-brand-deep/70">{text as string}</p>
            </article>
          ))}
        </div>

        <aside className="h-fit rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm">
          <h2 className="font-serif text-3xl font-black text-brand-deep">Order summary</h2>
          <div className="mt-5 space-y-3">
            {items.length === 0 ? (
              <p className="rounded-lg bg-brand-ivory p-4 text-brand-deep/70">No cart items yet.</p>
            ) : (
              items.map((item) => (
                <div key={item.id} className="flex justify-between gap-4 rounded-lg bg-brand-ivory p-4">
                  <span>{item.title} x {item.quantity}</span>
                  <strong>R {(item.price * item.quantity).toLocaleString("en-ZA")}</strong>
                </div>
              ))
            )}
          </div>
          <div className="mt-5 flex justify-between border-t border-brand-sage/30 pt-5 text-lg">
            <span>Demo total</span>
            <strong>R {totalPrice.toLocaleString("en-ZA")}</strong>
          </div>
          <button onClick={() => setConfirmed(true)} className="mt-6 w-full rounded-xl bg-brand-forest px-6 py-3 font-bold text-white">
            Create demo order
          </button>
          {confirmed ? (
            <p className="mt-5 flex gap-3 rounded-xl bg-brand-sage/20 p-4 text-sm font-semibold text-brand-deep">
              <CheckCircle2 className="shrink-0 text-brand-forest" size={18} />
              Demo order created. Payment, stock validation and vendor fulfilment are not connected.
            </p>
          ) : null}
          <Link href="/marketplace" className="mt-5 inline-flex font-bold text-brand-forest">Continue shopping -&gt;</Link>
        </aside>
      </section>
    </main>
  );
}
