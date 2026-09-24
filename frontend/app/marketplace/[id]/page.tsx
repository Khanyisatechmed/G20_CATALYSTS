import ProductDetail from "@/components/ProductDetail";
import { marketplaceProducts } from "@/lib/products";

// Pre-render one page per product for the static GitHub Pages export.
export function generateStaticParams() {
  return marketplaceProducts.map((product) => ({ id: product.id }));
}

export const dynamicParams = false;

export default async function MarketplaceProductPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <ProductDetail id={id} />;
}