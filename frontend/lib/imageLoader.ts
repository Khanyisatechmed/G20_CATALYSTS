// next/image loader for the static export: serves files from /public as-is (no optimisation
// server on GitHub Pages) and adds the base path. The width query keeps Next's loader contract.
import { asset } from "./basePath";

export default function imageLoader({ src, width }: { src: string; width: number; quality?: number }) {
  if (/^(https?:|data:)/.test(src)) return src;
  return `${asset(src)}?w=${width}`;
}
