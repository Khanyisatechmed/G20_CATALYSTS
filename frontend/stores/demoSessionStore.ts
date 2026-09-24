"use client";

import { create } from "zustand";
import { persist } from "zustand/middleware";

type DemoSessionState = {
  role: string;
  name: string;
  setRole: (role: string) => void;
  setName: (name: string) => void;
  logout: () => void;
};

export const useDemoSessionStore = create<DemoSessionState>()(
  persist(
    (set) => ({
      role: "Guest",
      name: "Demo Visitor",
      setRole: (role) => set({ role }),
      setName: (name) => set({ name }),
      logout: () => set({ role: "Guest", name: "Demo Visitor" })
    }),
    {
      name: "catalystic-wanders-demo-session"
    }
  )
);
