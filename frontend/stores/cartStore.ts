import { create } from "zustand";
import { persist } from "zustand/middleware";

export type CartProduct = {
  id: string;
  title: string;
  artisan: string;
  price: number;
  currency: "ZAR";
  imageUrl?: string;
  modelUrl?: string;
};

export type CartItem = CartProduct & {
  quantity: number;
};

type CartState = {
  items: CartItem[];
  addItem: (product: CartProduct) => void;
  removeItem: (id: string) => void;
  updateQuantity: (id: string, quantity: number) => void;
  clearCart: () => void;
  totalItems: () => number;
  totalPrice: () => number;
};

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],

      addItem: (product) => {
        const existingItem = get().items.find((item) => item.id === product.id);

        if (existingItem) {
          set({
            items: get().items.map((item) =>
              item.id === product.id
                ? { ...item, quantity: item.quantity + 1 }
                : item
            )
          });
          return;
        }

        set({
          items: [...get().items, { ...product, quantity: 1 }]
        });
      },

      removeItem: (id) => {
        set({
          items: get().items.filter((item) => item.id !== id)
        });
      },

      updateQuantity: (id, quantity) => {
        if (quantity <= 0) {
          get().removeItem(id);
          return;
        }

        set({
          items: get().items.map((item) =>
            item.id === id ? { ...item, quantity } : item
          )
        });
      },

      clearCart: () => set({ items: [] }),

      totalItems: () =>
        get().items.reduce((total, item) => total + item.quantity, 0),

      totalPrice: () =>
        get().items.reduce(
          (total, item) => total + item.price * item.quantity,
          0
        )
    }),
    {
      name: "catalystic-wanders-cart",
      // Restored by <CartHydrator /> after React hydrates, so server and client HTML match.
      skipHydration: true
    }
  )
);
