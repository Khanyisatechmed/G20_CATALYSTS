import type { NextConfig } from "next";

// Set in the GitHub Pages workflow (e.g. "/G20_CATALYSTS"); empty for local development.
const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? "";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  // Static HTML export for GitHub Pages.
  output: "export",
  basePath,
  // Emit /about/index.html so GitHub Pages serves /about/ without a server.
  trailingSlash: true,
  images: {
    loader: "custom",
    loaderFile: "./lib/imageLoader.ts"
  }
};

export default nextConfig;
