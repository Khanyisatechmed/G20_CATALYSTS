"use client";

import { useMemo, useState } from "react";
import { asset } from "@/lib/basePath";

const slots = ["09:30", "11:00", "13:30", "15:00", "17:30"];
const ticketPrices: Record<string, number> = {
  Adult: 320,
  Child: 160,
  Student: 220,
  "Family or Group": 250
};

export default function HologramBookingPage() {
  const [selectedExhibition, setSelectedExhibition] = useState("balobedu-rain-queen");
  const [selectedDate, setSelectedDate] = useState("");
  const [selectedSlot, setSelectedSlot] = useState(slots[1]);
  const [ticketCategory, setTicketCategory] = useState("Adult");
  const [guestCount, setGuestCount] = useState(2);
  const [isBooked, setIsBooked] = useState(false);

  const total = useMemo(
    () => guestCount * ticketPrices[ticketCategory],
    [guestCount, ticketCategory]
  );

  return (
    <main className="min-h-screen bg-brand-ivory text-brand-deep">
      <section className="relative -mt-6 min-h-[560px] overflow-hidden">
        <video
          className="absolute inset-0 h-full w-full object-cover"
          src={asset("/videos/hologram.mp4")}
          autoPlay
          muted
          loop
          playsInline
        />
        <div className="absolute inset-0 bg-gradient-to-r from-black/84 via-brand-deep/70 to-brand-deep/18" />
        <div className="absolute left-0 top-0 h-full w-28 bg-[linear-gradient(135deg,rgba(248,245,236,0.14)_25%,transparent_25%,transparent_50%,rgba(248,245,236,0.14)_50%,rgba(248,245,236,0.14)_75%,transparent_75%)] bg-[length:36px_36px] opacity-40" />
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_75%_35%,rgba(71,215,255,0.22),transparent_22rem)]" />

        <div className="relative z-10 mx-auto flex min-h-[560px] max-w-[1800px] flex-col justify-end px-6 pb-16 pt-28 md:px-20">
          <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">
            Limpopo Hologram Theatre
          </p>
          <h1 className="mt-5 max-w-5xl font-serif text-[2.6rem] font-black leading-[0.95] sm:text-6xl text-white md:text-7xl">
            Balobedu Rain Queen Hologram Experience
          </h1>
          <p className="mt-6 max-w-2xl text-lg leading-8 text-white/86">
            A cinematic cultural encounter honoring the Rain Queen lineage
            through light, sound, oral history, and immersive projection.
            Reservation logic is in development mode until database-backed
            capacity, holds and payments are connected.
          </p>
        </div>
      </section>

      <section className="mx-auto grid max-w-[1500px] gap-8 px-6 py-12 lg:grid-cols-[minmax(0,1fr)_420px] md:px-20">
        <div className="rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm md:p-8">
          <h2 className="font-serif text-4xl font-black text-brand-deep">
            Select your session
          </h2>
          <p className="mt-3 leading-7 text-brand-deep/70">
            Each slot includes the hologram show, guided cultural context, and a
            reflective sound-and-light closing sequence.
          </p>

          <label className="mt-8 block">
            <span className="text-sm font-bold uppercase tracking-[0.2em] text-brand-deep/55">
              Exhibition
            </span>
            <select
              value={selectedExhibition}
              onChange={(event) => {
                setSelectedExhibition(event.target.value);
                setIsBooked(false);
              }}
              className="mt-3 w-full rounded-xl border border-brand-sage/40 bg-brand-ivory px-4 py-4 text-brand-deep outline-none transition focus:border-brand-terracotta"
            >
              <option value="balobedu-rain-queen">Balobedu Rain Queen</option>
              <option value="future-national-heritage" disabled>
                Future national exhibitions
              </option>
            </select>
          </label>

          <label className="mt-8 block">
            <span className="text-sm font-bold uppercase tracking-[0.2em] text-brand-deep/55">
              Date
            </span>
            <input
              type="date"
              value={selectedDate}
              onChange={(event) => {
                setSelectedDate(event.target.value);
                setIsBooked(false);
              }}
              className="mt-3 w-full rounded-xl border border-brand-sage/40 bg-brand-ivory px-4 py-4 text-brand-deep outline-none transition focus:border-brand-terracotta"
            />
          </label>

          <div className="mt-8">
            <p className="text-sm font-bold uppercase tracking-[0.2em] text-brand-deep/55">
              Time
            </p>
            <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-5">
              {slots.map((slot) => (
                <button
                  key={slot}
                  type="button"
                  onClick={() => {
                    setSelectedSlot(slot);
                    setIsBooked(false);
                  }}
                  className={[
                    "rounded-xl border px-4 py-3 font-bold transition",
                    selectedSlot === slot
                      ? "border-brand-forest bg-brand-forest text-white"
                      : "border-brand-sage/40 bg-brand-ivory text-brand-deep hover:border-brand-terracotta"
                  ].join(" ")}
                >
                  {slot}
                </button>
              ))}
            </div>
          </div>

          <label className="mt-8 block">
            <span className="text-sm font-bold uppercase tracking-[0.2em] text-brand-deep/55">
              Ticket category
            </span>
            <select
              value={ticketCategory}
              onChange={(event) => {
                setTicketCategory(event.target.value);
                setIsBooked(false);
              }}
              className="mt-3 w-full rounded-xl border border-brand-sage/40 bg-brand-ivory px-4 py-4 text-brand-deep outline-none transition focus:border-brand-terracotta"
            >
              {Object.keys(ticketPrices).map((category) => (
                <option key={category}>{category}</option>
              ))}
            </select>
          </label>

          <label className="mt-8 block">
            <span className="text-sm font-bold uppercase tracking-[0.2em] text-brand-deep/55">
              Guests
            </span>
            <input
              type="number"
              min={1}
              max={12}
              value={guestCount}
              onChange={(event) => {
                setGuestCount(Number(event.target.value));
                setIsBooked(false);
              }}
              className="mt-3 w-full rounded-xl border border-brand-sage/40 bg-brand-ivory px-4 py-4 text-brand-deep outline-none transition focus:border-brand-terracotta"
            />
          </label>
        </div>

        <aside className="rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm md:p-8">
          <p className="text-sm font-bold uppercase tracking-[0.26em] text-brand-terracotta">
            Booking Summary
          </p>
          <h2 className="mt-4 font-serif text-3xl font-black text-brand-deep">
            Rain Queen Experience
          </h2>

          <dl className="mt-8 space-y-5 text-brand-deep/75">
            <div className="flex justify-between gap-6">
              <dt>Exhibition</dt>
              <dd className="text-right font-bold text-brand-deep">
                {selectedExhibition === "balobedu-rain-queen"
                  ? "Balobedu Rain Queen"
                  : selectedExhibition}
              </dd>
            </div>
            <div className="flex justify-between gap-6">
              <dt>Date</dt>
              <dd className="font-bold text-brand-deep">
                {selectedDate || "Choose date"}
              </dd>
            </div>
            <div className="flex justify-between gap-6">
              <dt>Time</dt>
              <dd className="font-bold text-brand-deep">{selectedSlot}</dd>
            </div>
            <div className="flex justify-between gap-6">
              <dt>Ticket</dt>
              <dd className="font-bold text-brand-deep">{ticketCategory}</dd>
            </div>
            <div className="flex justify-between gap-6">
              <dt>Guests</dt>
              <dd className="font-bold text-brand-deep">{guestCount}</dd>
            </div>
            <div className="border-t border-brand-sage/30 pt-5">
              <div className="flex justify-between gap-6 text-xl">
                <dt>Development total</dt>
                <dd className="font-black text-brand-forest">
                  R {total.toLocaleString("en-ZA")}
                </dd>
              </div>
            </div>
          </dl>

          <button
            type="button"
            disabled={!selectedDate}
            onClick={() => setIsBooked(true)}
            className="mt-8 w-full rounded-xl bg-brand-forest px-6 py-4 font-black text-white transition hover:bg-brand-deep disabled:cursor-not-allowed disabled:bg-brand-sage disabled:text-brand-deep/50"
          >
            Request Reservation
          </button>

          {isBooked ? (
            <p className="mt-5 rounded-xl border border-brand-forest/25 bg-brand-sage/20 p-4 text-sm font-semibold text-brand-deep">
              Reservation request captured for {selectedDate} at {selectedSlot}.
              This is not a confirmed ticket until backend capacity validation,
              booking reference generation, payment status and QR ticketing are
              implemented.
            </p>
          ) : null}
        </aside>
      </section>
    </main>
  );
}
