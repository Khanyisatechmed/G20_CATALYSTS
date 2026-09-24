// Sub-path the site is served from, e.g. "/G20_CATALYSTS" on GitHub Pages; empty locally.
export const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? "";

// Prefixes files in /public (videos, 3D models, CSS backgrounds) with the base path.
// next/link and next/image handle this themselves; plain src/href strings do not.
export function asset(path: string) {
  return path.startsWith("/") && !path.startsWith(`${basePath}/`) ? `${basePath}${path}` : path;
}
