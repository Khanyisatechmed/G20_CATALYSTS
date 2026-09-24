"use client";

import { useEffect } from "react";
import { useCartStore } from "@/stores/cartStore";

// Loads the saved cart from localStorage once the page has hydrated. Doing it during the first
// render would make the header badge and cart page differ from the server HTML.
export default function CartHydrator() {
  useEffect(() => {
    void useCartStore.persist.rehydrate();
  }, []);
  return null;
}
