"use client";

import Link from "next/link";
import { Minus, Plus, ShieldCheck } from "lucide-react";
import { useEffect, useState } from "react";
import { hologramSessions, hologramTicketPrices, type HologramTicketCategory } from "@/lib/hologramTickets";

const rand = (value: number) => `R${value.toLocaleString("en-ZA")}`;

function isoDate(date: Date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
}

export default function HologramBookingWidget() {
  const [date, setDate] = useState("");
  const [minDate, setMinDate] = useState<string>();
  const [session, setSession] = useState(hologramSessions[1]);
  const [counts, setCounts] = useState<Record<HologramTicketCategory, number>>({
    Adult: 2,
    Child: 0,
    Student: 0,
    "Family or Group": 0
  });
  const [requested, setRequested] = useState<string | null>(null);

  // Today's date is only known in the browser, so set it after hydration.
  useEffect(() => setMinDate(isoDate(new Date())), []);

  const guests = Object.values(counts).reduce((sum, count) => sum + count, 0);
  const total = hologramTicketPrices.reduce((sum, ticket) => sum + ticket.price * counts[ticket.category], 0);
  const canReserve = Boolean(date) && guests > 0;

  function change(category: HologramTicketCategory, delta: number) {
    setCounts((current) => ({ ...current, [category]: Math.min(20, Math.max(0, current[category] + delta)) }));
    setRequested(null);
  }

  function reserve() {
    if (!canReserve) return;
    const when = new Date(`${date}T00:00:00`).toLocaleDateString("en-ZA", { weekday: "short", day: "numeric", month: "long", year: "numeric" });
    const tickets = hologramTicketPrices
      .filter((ticket) => counts[ticket.category] > 0)
      .map((ticket) => `${counts[ticket.category]} ${ticket.label}`)
      .join(", ");
    setRequested(`Reservation request noted: ${tickets} on ${when} at ${session}, ${rand(total)} in total.`);
  }

  return (
    <aside className="rounded-xl border border-brand-sage/25 bg-white p-5 shadow-sm sm:p-6" aria-labelledby="hub-booking-title">
      <h3 id="hub-booking-title" className="font-serif text-3xl font-black text-brand-deep">
        Book Your Visit
      </h3>
      <p className="mt-1 text-brand-deep/80">Experience the Hologram Hub</p>

      <div className="mt-5 grid gap-3">
        <label className="grid gap-1 text-sm font-semibold text-brand-deep">
          Experience
          <select id="hub-booking-experience" className="w-full min-w-0 rounded-xl border border-brand-sage/40 bg-white px-4 py-3 font-normal">
            <option>Modjadji Rain Queen Experience</option>
          </select>
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="grid min-w-0 gap-1 text-sm font-semibold text-brand-deep">
            Date
            <input
              id="hub-booking-date"
              type="date"
              value={date}
              min={minDate}
              onChange={(event) => {
                setDate(event.target.value);
                setRequested(null);
              }}
              className="w-full min-w-0 rounded-xl border border-brand-sage/40 bg-white px-3 py-3 font-normal"
            />
          </label>
          <label className="grid min-w-0 gap-1 text-sm font-semibold text-brand-deep">
            Session
            <select
              id="hub-booking-session"
              value={session}
              onChange={(event) => {
                setSession(event.target.value);
                setRequested(null);
              }}
              className="w-full min-w-0 rounded-xl border border-brand-sage/40 bg-white px-3 py-3 font-normal"
            >
              {hologramSessions.map((slot) => (
                <option key={slot} value={slot}>
                  {slot}
                </option>
              ))}
            </select>
          </label>
        </div>

        <ul className="mt-1 grid">
          {hologramTicketPrices.map((ticket) => (
            <li key={ticket.category} className="grid grid-cols-[minmax(0,1fr)_auto_auto] items-center gap-3 border-b border-brand-sage/25 py-2.5 text-sm">
              <span className="min-w-0 font-semibold text-brand-deep">{ticket.label}</span>
              <span className="tabular-nums text-brand-deep/80">{rand(ticket.price)}</span>
              <span className="flex items-center gap-1 rounded-lg bg-brand-ivory p-1">
                <button
                  type="button"
                  onClick={() => change(ticket.category, -1)}
                  disabled={counts[ticket.category] === 0}
                  aria-label={`Remove one ${ticket.label} ticket`}
                  className="grid h-7 w-7 place-items-center rounded-md text-brand-deep hover:bg-white disabled:opacity-40"
                >
                  <Minus size={14} />
                </button>
                <span className="w-6 text-center font-bold tabular-nums" aria-live="polite">
                  {counts[ticket.category]}
                </span>
                <button
                  type="button"
                  onClick={() => change(ticket.category, 1)}
                  aria-label={`Add one ${ticket.label} ticket`}
                  className="grid h-7 w-7 place-items-center rounded-md text-brand-deep hover:bg-white"
                >
                  <Plus size={14} />
                </button>
              </span>
            </li>
          ))}
        </ul>

        <div className="flex items-baseline justify-between rounded-lg bg-brand-sage/30 px-4 py-3 text-brand-deep">
          <span className="text-xl font-black">Total</span>
          <span className="text-right">
            <span className="block text-xl font-black tabular-nums">{rand(total)}</span>
            <span className="text-xs">
              {guests} {guests === 1 ? "guest" : "guests"}
            </span>
          </span>
        </div>

        <button
          type="button"
          onClick={reserve}
          disabled={!canReserve}
          className="rounded-xl bg-brand-forest px-5 py-3 text-center font-bold text-white transition hover:bg-brand-deep disabled:cursor-not-allowed disabled:bg-brand-sage disabled:text-brand-deep/70"
        >
          Reserve Your Tickets →
        </button>
        {!canReserve ? (
          <p className="text-center text-xs text-brand-deep/80">{date ? "Add at least one ticket." : "Choose a date to reserve."}</p>
        ) : null}

        {requested ? (
          <div role="status" className="rounded-xl border border-brand-forest/25 bg-brand-sage/20 p-4 text-sm text-brand-deep">
            <p className="font-semibold">{requested}</p>
            <p className="mt-1">This is a request, not a confirmed ticket. Confirmation and payment aren&apos;t connected yet.</p>
            <Link href="/bookings/hologram/" className="mt-2 inline-block font-bold text-brand-forest underline">
              Open the full booking page
            </Link>
          </div>
        ) : (
          <p className="flex items-center justify-center gap-2 text-xs text-brand-deep/80">
            <ShieldCheck size={14} /> Reservation requests only. Confirmed tickets are coming soon.
          </p>
        )}
      </div>
    </aside>
  );
}
