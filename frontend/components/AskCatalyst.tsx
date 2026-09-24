"use client";

import { MessageCircle, X } from "lucide-react";
import { useEffect, useState } from "react";

const suggestions = [
  "Plan a heritage weekend in Limpopo",
  "Find products from KwaZulu-Natal",
  "Book the Rain Queen experience",
  "Find food experiences"
];

export default function AskCatalyst() {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState([
    {
      role: "assistant",
      content:
        "Ask Catalyst demo is connected to the current app routes. I can point you to heritage, products, bookings, vendors, food and itineraries."
    }
  ]);
  const [input, setInput] = useState("");

  // Lets other pages open the assistant, e.g. "Chat with Ask Catalyst" on Plan Your Visit.
  useEffect(() => {
    const open = () => setIsOpen(true);
    window.addEventListener("open-ask-catalyst", open);
    return () => window.removeEventListener("open-ask-catalyst", open);
  }, []);

  function getDemoResponse(question: string) {
    const query = question.toLowerCase();
    if (query.includes("book") || query.includes("rain queen")) {
      return "Open /bookings/hologram to request a Rain Queen reservation. In demo mode it captures exhibition, date, session, ticket category and guests, but it does not issue confirmed tickets yet.";
    }
    if (query.includes("product") || query.includes("buy") || query.includes("pottery")) {
      return "Browse /marketplace for the Traditional Zulu Hat and Zulu Ikhamba Clay Vessel. Both have 3D/AR model previews and can be added to the demo cart.";
    }
    if (query.includes("food")) {
      return "Open /food for demo food discovery. Ratings and opening hours are intentionally not fabricated; verified venue data will connect later.";
    }
    if (query.includes("vendor") || query.includes("near")) {
      return "Open /explore/map for the demo national vendor map, or /vendors for public vendor profiles with approval status.";
    }
    if (query.includes("plan") || query.includes("itinerary")) {
      return "Open /plan-your-visit to generate a demo itinerary by province, days and interest. Suggestions are not confirmed reservations.";
    }
    return "Try the heritage library at /heritage, province discovery at /provinces, Hologram Hub at /hologram-hub, or marketplace at /marketplace.";
  }

  function sendMessage(question: string) {
    if (!question.trim()) return;
    setMessages((current) => [
      ...current,
      { role: "user", content: question },
      { role: "assistant", content: getDemoResponse(question) }
    ]);
    setInput("");
  }

  return (
    <div className="fixed bottom-4 right-4 z-50 flex flex-col items-end md:bottom-6 md:right-6">
      {isOpen ? (
        <section className="mb-3 w-[min(calc(100vw-2rem),430px)] overflow-hidden rounded-[1.6rem] border border-brand-sage/40 bg-white shadow-2xl">
          <header className="flex items-center justify-between bg-brand-forest px-5 py-4 text-white">
            <div>
              <h2 className="font-black">Ask Catalyst</h2>
              <p className="text-xs text-white/80">Your AI Heritage & Travel Guide</p>
            </div>
            <button
              type="button"
              aria-label="Close Ask Catalyst"
              onClick={() => setIsOpen(false)}
              className="rounded-full bg-white/10 p-2"
            >
              <X size={18} />
            </button>
          </header>
          <div className="space-y-4 p-5">
            <div className="max-h-72 space-y-3 overflow-y-auto pr-1">
              {messages.map((message, index) => (
                <p
                  key={`${message.role}-${index}`}
                  className={[
                    "rounded-2xl p-4 text-sm leading-6",
                    message.role === "assistant"
                      ? "bg-brand-ivory text-brand-deep"
                      : "bg-brand-forest text-white"
                  ].join(" ")}
                >
                  {message.content}
                </p>
              ))}
            </div>
            <div className="grid gap-2">
              {suggestions.map((suggestion) => (
                <button
                  key={suggestion}
                  type="button"
                  onClick={() => sendMessage(suggestion)}
                  className="rounded-full border border-brand-sage/50 px-4 py-2 text-left text-sm font-semibold text-brand-deep hover:border-brand-terracotta"
                >
                  {suggestion}
                </button>
              ))}
            </div>
            <form
              onSubmit={(event) => {
                event.preventDefault();
                sendMessage(input);
              }}
              className="flex gap-2"
            >
              <input
                value={input}
                onChange={(event) => setInput(event.target.value)}
                placeholder="Ask about heritage, trips, products..."
                className="min-w-0 flex-1 rounded-full border border-brand-sage/50 px-4 py-2 text-sm outline-none focus:border-brand-terracotta"
              />
              <button className="rounded-full bg-brand-forest px-4 py-2 text-sm font-bold text-white">
                Send
              </button>
            </form>
          </div>
        </section>
      ) : null}

      <button
        type="button"
        aria-label={isOpen ? "Close Ask Catalyst" : "Open Ask Catalyst"}
        aria-expanded={isOpen}
        onClick={() => setIsOpen((value) => !value)}
        className="inline-flex items-center gap-2 rounded-full bg-brand-forest p-4 font-black text-white shadow-xl shadow-brand-forest/30 transition hover:bg-brand-deep sm:px-5 sm:py-3"
      >
        {isOpen ? <X size={20} /> : <MessageCircle size={20} />}
        <span className="hidden sm:inline">Ask Catalyst</span>
      </button>
    </div>
  );
}
