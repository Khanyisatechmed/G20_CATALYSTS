"use client";

import { notFound } from "next/navigation";
import ModelViewer from "@/components/ModelViewer";
import { getProductById } from "@/lib/products";
import { useCartStore } from "@/stores/cartStore";

export default function ProductDetail({ id }: { id: string }) {
  const product = getProductById(id);
  const addItem = useCartStore((state) => state.addItem);
  const totalItems = useCartStore((state) => state.totalItems());

  if (!product) {
    notFound();
  }

  return (
    <main className="min-h-screen bg-brand-ivory text-brand-deep">
      <section className="mx-auto grid max-w-[1800px] gap-10 px-6 py-12 md:grid-cols-[1.08fr_0.92fr] md:px-20 md:py-16">
        <ModelViewer src={product.modelUrl} alt={product.title} />

        <aside className="flex flex-col justify-center">
          <p className="text-sm font-bold uppercase tracking-[0.3em] text-brand-terracotta">
            Spatial Artisan Marketplace
          </p>

          <h1 className="mt-5 font-serif text-5xl font-black leading-[0.95] text-brand-deep md:text-7xl">
            {product.title}
          </h1>

          <p className="mt-4 text-lg text-brand-deep/75">
            Crafted by{" "}
            <span className="font-bold text-brand-forest">{product.artisan}</span>
          </p>

          <div className="mt-8 rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm">
            <p className="text-sm font-black uppercase tracking-[0.2em] text-brand-terracotta">
              Development price
            </p>
            <p className="mt-2 text-4xl font-black text-brand-forest">
              R {product.price.toLocaleString("en-ZA")}
            </p>
            <p className="mt-5 leading-8 text-brand-deep/80">
              {product.description}
            </p>
            <p className="mt-4 leading-8 text-brand-deep/65">
              {product.culturalSignificance}
            </p>

            <dl className="mt-7 grid grid-cols-1 gap-3 sm:grid-cols-3">
              <div className="rounded-xl bg-brand-ivory p-4">
                <dt className="text-xs uppercase tracking-[0.2em] text-brand-deep/50">
                  Region
                </dt>
                <dd className="mt-2 font-semibold text-brand-deep">
                  {product.region}
                </dd>
              </div>
              <div className="rounded-xl bg-brand-ivory p-4">
                <dt className="text-xs uppercase tracking-[0.2em] text-brand-deep/50">
                  Materials
                </dt>
                <dd className="mt-2 font-semibold text-brand-deep">
                  {product.materials[0]}
                </dd>
              </div>
              <div className="rounded-xl bg-brand-ivory p-4">
                <dt className="text-xs uppercase tracking-[0.2em] text-brand-deep/50">
                  Mobile AR
                </dt>
                <dd className="mt-2 font-semibold text-brand-forest">Enabled</dd>
              </div>
            </dl>

            <button
              type="button"
              onClick={() =>
                addItem({
                  id: product.id,
                  title: product.title,
                  artisan: product.artisan,
                  price: product.price,
                  currency: product.currency,
                  imageUrl: product.imageUrl,
                  modelUrl: product.modelUrl
                })
              }
              className="mt-8 w-full rounded-xl bg-brand-forest px-6 py-4 text-base font-black text-white transition hover:bg-brand-deep focus:outline-none focus:ring-2 focus:ring-brand-terracotta focus:ring-offset-2"
            >
              Add to Cart
            </button>
            <p className="mt-4 text-center text-sm text-brand-deep/60">
              Cart count: {totalItems}. Checkout is currently a development flow.
            </p>
          </div>
        </aside>
      </section>
    </main>
  );
}
