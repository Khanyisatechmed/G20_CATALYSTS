"use client";

import Image from "next/image";
import Link from "next/link";
import { Box, Move3d, ShoppingBag, Smartphone, ZoomIn } from "lucide-react";
import { useState } from "react";
import ModelViewer from "@/components/ModelViewer";
import { marketplaceProducts } from "@/lib/products";
import { useCartStore } from "@/stores/cartStore";

const rand = (value: number) => `R${value.toLocaleString("en-ZA")}`;

// Live 3D/AR preview of the marketplace products that have models, with a product switcher.
export default function Marketplace3DShowcase({ className = "" }: { className?: string }) {
  const [selectedId, setSelectedId] = useState(marketplaceProducts[0].id);
  const [added, setAdded] = useState<string | null>(null);
  const addItem = useCartStore((state) => state.addItem);
  const product = marketplaceProducts.find((item) => item.id === selectedId) ?? marketplaceProducts[0];

  function addToCart() {
    addItem({
      id: product.id,
      title: product.title,
      artisan: product.artisan,
      price: product.price,
      currency: product.currency,
      imageUrl: product.imageUrl,
      modelUrl: product.modelUrl
    });
    setAdded(product.id);
  }

  return (
    <aside className={`rounded-xl border border-brand-sage/25 bg-white p-5 shadow-sm sm:p-6 ${className}`} aria-labelledby="showcase-title">
      <div className="grid gap-6 md:grid-cols-[minmax(0,1.15fr)_minmax(0,1fr)] md:items-center 2xl:grid-cols-1">
        <div className="min-w-0 md:order-1 2xl:order-2">
          {/* key remounts the viewer so the new model loads cleanly when switching products */}
          <ModelViewer
            key={product.id}
            src={product.modelUrl}
            alt={`3D model of the ${product.title}`}
            poster={product.imageUrl}
            viewerClassName="h-[340px] w-full md:h-[440px] 2xl:h-[320px]"
          />
        </div>

        <div className="min-w-0 md:order-2 2xl:order-1">
          <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">Interactive Experience</p>
          <h2 id="showcase-title" className="mt-3 font-serif text-3xl font-black leading-tight text-brand-deep sm:text-4xl">
            View in 3D and Augmented Reality
          </h2>
          <p className="mt-3 leading-7 text-brand-deep/80">
            Drag to turn each piece, pinch or scroll to zoom, and place it in your own space with AR on a supported phone.
          </p>

          <div role="group" aria-label="Choose a product" className="mt-5 grid grid-cols-2 gap-3">
            {marketplaceProducts.map((item) => (
              <button
                key={item.id}
                type="button"
                onClick={() => {
                  setSelectedId(item.id);
                  setAdded(null);
                }}
                aria-pressed={item.id === selectedId}
                className={[
                  "flex items-center gap-3 rounded-xl border p-2 text-left transition",
                  item.id === selectedId ? "border-brand-forest bg-brand-forest/5 ring-2 ring-brand-forest/25" : "border-brand-sage/40 hover:border-brand-terracotta"
                ].join(" ")}
              >
                <span className="relative h-12 w-12 shrink-0 overflow-hidden rounded-lg bg-brand-ivory">
                  <Image src={item.imageUrl} alt="" fill sizes="48px" className="object-cover" />
                </span>
                <span className="min-w-0">
                  <span className="block text-sm font-bold leading-5 text-brand-deep">{item.title}</span>
                  <span className="text-xs text-brand-deep/80">{rand(item.price)}</span>
                </span>
              </button>
            ))}
          </div>

          <div className="mt-5 rounded-xl bg-brand-ivory p-4">
            <p className="font-serif text-xl font-black text-brand-deep">{product.title}</p>
            <p className="text-sm text-brand-deep/80">
              By {product.artisan} · {product.region} · <span className="font-bold text-brand-forest">{rand(product.price)}</span>
            </p>
            <p className="mt-2 text-sm leading-6 text-brand-deep/80">{product.culturalSignificance}</p>
          </div>

          <div className="mt-4 grid gap-3 sm:grid-cols-2">
            <button
              type="button"
              onClick={addToCart}
              className="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-forest px-5 py-3 font-bold text-white transition hover:bg-brand-deep"
            >
              <ShoppingBag size={18} /> {added === product.id ? "Added to cart" : "Add to cart"}
            </button>
            <Link
              href={`/marketplace/${product.id}/`}
              className="inline-flex items-center justify-center gap-2 rounded-xl border border-brand-forest/40 px-5 py-3 font-bold text-brand-deep transition hover:border-brand-terracotta"
            >
              <Box size={18} /> Full product page
            </Link>
          </div>
          {added === product.id ? (
            <p role="status" className="mt-2 text-sm text-brand-deep/80">
              The {product.title} is in your cart.{" "}
              <Link href="/cart/" className="font-bold text-brand-forest underline">
                View cart
              </Link>
            </p>
          ) : null}

          <ul className="mt-5 grid grid-cols-3 gap-2 text-center text-xs font-semibold text-brand-deep/80">
            <li className="grid justify-items-center gap-1">
              <Move3d size={18} className="text-brand-terracotta" /> Rotate 360°
            </li>
            <li className="grid justify-items-center gap-1">
              <ZoomIn size={18} className="text-brand-terracotta" /> Zoom in and out
            </li>
            <li className="grid justify-items-center gap-1">
              <Smartphone size={18} className="text-brand-terracotta" /> View in AR
            </li>
          </ul>
        </div>
      </div>
    </aside>
  );
}
