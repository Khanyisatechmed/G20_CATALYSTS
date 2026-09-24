"use client";

import { demoRoles } from "@/lib/demoData";
import { useDemoSessionStore } from "@/stores/demoSessionStore";

export default function DemoLoginPanel() {
  const role = useDemoSessionStore((state) => state.role);
  const name = useDemoSessionStore((state) => state.name);
  const setRole = useDemoSessionStore((state) => state.setRole);
  const setName = useDemoSessionStore((state) => state.setName);
  const logout = useDemoSessionStore((state) => state.logout);

  return (
    <section className="rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm">
      <p className="text-sm font-black uppercase tracking-[0.24em] text-brand-terracotta">
        Demo session
      </p>
      <h2 className="mt-3 font-serif text-3xl font-black text-brand-deep">
        Signed in as {role}
      </h2>
      <p className="mt-3 leading-7 text-brand-deep/70">
        This is a client-side demo role switcher. Production auth still needs
        secure sessions and server-side authorization.
      </p>

      <label className="mt-6 block">
        <span className="text-sm font-bold text-brand-deep/70">Display name</span>
        <input
          value={name}
          onChange={(event) => setName(event.target.value)}
          className="mt-2 w-full rounded-xl border border-brand-sage/50 px-4 py-3"
        />
      </label>

      <label className="mt-4 block">
        <span className="text-sm font-bold text-brand-deep/70">Role</span>
        <select
          value={role}
          onChange={(event) => setRole(event.target.value)}
          className="mt-2 w-full rounded-xl border border-brand-sage/50 bg-white px-4 py-3"
        >
          {demoRoles.map((demoRole) => (
            <option key={demoRole}>{demoRole}</option>
          ))}
        </select>
      </label>

      <button
        type="button"
        onClick={logout}
        className="mt-6 rounded-xl border border-brand-terracotta px-5 py-3 font-bold text-brand-terracotta"
      >
        Reset demo session
      </button>
    </section>
  );
}
