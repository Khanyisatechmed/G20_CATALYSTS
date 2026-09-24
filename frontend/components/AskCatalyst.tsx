"use client";

import Image from "next/image";
import Link from "next/link";
import { ArrowRight, MessageCircle, RotateCcw, Send, ShoppingBag, X } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { answer, defaultSuggestions, welcomeReply, type ChatContext, type ChatReply } from "@/lib/catalyst";
import { getProductById } from "@/lib/products";
import { useCartStore } from "@/stores/cartStore";

type NewMessage = { role: "user"; text: string } | { role: "assistant"; reply: ChatReply };
type Message = NewMessage & { id: number };

const storageKey = "ask-catalyst-chat";
const initialMessages: Message[] = [{ id: 0, role: "assistant", reply: welcomeReply }];

export default function AskCatalyst() {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState<Message[]>(initialMessages);
  const [context, setContext] = useState<ChatContext>({});
  const [input, setInput] = useState("");
  const [isThinking, setIsThinking] = useState(false);
  const logRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const nextId = useRef(1);
  // Don't save until the saved chat has been restored, or the empty chat would overwrite it.
  const [restored, setRestored] = useState(false);

  const items = useCartStore((state) => state.items);
  const addItem = useCartStore((state) => state.addItem);

  // Keep the conversation for this browser tab, so it carries on across pages.
  useEffect(() => {
    try {
      const saved = sessionStorage.getItem(storageKey);
      if (saved) {
        const parsed = JSON.parse(saved) as { messages: Message[]; context: ChatContext };
        if (Array.isArray(parsed.messages) && parsed.messages.length > 0) {
          setMessages(parsed.messages);
          setContext(parsed.context ?? {});
          nextId.current = Math.max(...parsed.messages.map((message) => message.id)) + 1;
        }
      }
    } catch {
      // Storage can be unavailable (private mode); the chat still works without it.
    }
    setRestored(true);
  }, []);

  useEffect(() => {
    if (!restored) return;
    try {
      sessionStorage.setItem(storageKey, JSON.stringify({ messages: messages.slice(-40), context }));
    } catch {
      // Ignore storage errors.
    }
  }, [messages, context, restored]);

  // Lets other pages open the assistant, optionally with a question, e.g. "Chat with Ask Catalyst".
  useEffect(() => {
    const open = (event: Event) => {
      setIsOpen(true);
      const question = (event as CustomEvent<{ question?: string }>).detail?.question;
      if (question) send(question);
    };
    window.addEventListener("open-ask-catalyst", open);
    return () => window.removeEventListener("open-ask-catalyst", open);
  });

  useEffect(() => {
    if (!isOpen) return;
    inputRef.current?.focus();
    const onKey = (event: KeyboardEvent) => {
      if (event.key === "Escape") setIsOpen(false);
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [isOpen]);

  useEffect(() => {
    logRef.current?.scrollTo({ top: logRef.current.scrollHeight, behavior: "smooth" });
  }, [messages, isThinking, isOpen]);

  function push(message: NewMessage) {
    const id = nextId.current++;
    setMessages((current) => [...current, { ...message, id }]);
  }

  function send(question: string) {
    const trimmed = question.trim();
    if (!trimmed || isThinking) return;
    push({ role: "user", text: trimmed });
    setInput("");
    setIsThinking(true);

    const cart = {
      count: items.reduce((total, item) => total + item.quantity, 0),
      total: items.reduce((total, item) => total + item.price * item.quantity, 0),
      titles: items.map((item) => (item.quantity > 1 ? `${item.quantity} × ${item.title}` : item.title))
    };
    // A short pause so the reply reads as a response rather than an instant swap.
    window.setTimeout(() => {
      const result = answer(trimmed, context, cart);
      setContext(result.context);
      push({ role: "assistant", reply: result.reply });
      setIsThinking(false);
    }, 350);
  }

  function addToCart(productId: string) {
    const product = getProductById(productId);
    if (!product) return;
    addItem({
      id: product.id,
      title: product.title,
      artisan: product.artisan,
      price: product.price,
      currency: product.currency,
      imageUrl: product.imageUrl,
      modelUrl: product.modelUrl
    });
    const count = items.reduce((total, item) => total + item.quantity, 0) + 1;
    push({
      role: "assistant",
      reply: {
        text: [`Added the ${product.title} to your cart. You now have ${count} ${count === 1 ? "item" : "items"}.`],
        links: [
          { label: "View cart", href: "/cart/" },
          { label: "Go to checkout", href: "/checkout/" }
        ],
        suggestions: ["What else can I buy?", "What's in my cart?"]
      }
    });
  }

  function reset() {
    setMessages(initialMessages);
    setContext({});
    nextId.current = 1;
  }

  const lastReply = [...messages].reverse().find((message) => message.role === "assistant");
  const suggestions = (lastReply?.role === "assistant" ? lastReply.reply.suggestions : undefined) ?? defaultSuggestions;

  return (
    <div className="fixed bottom-4 right-4 z-50 flex flex-col items-end md:bottom-6 md:right-6">
      {isOpen ? (
        <section
          aria-label="Ask Catalyst"
          className="mb-3 flex max-h-[min(78vh,680px)] w-[min(calc(100vw-2rem),420px)] flex-col overflow-hidden rounded-[1.6rem] border border-brand-sage/40 bg-white shadow-2xl"
        >
          <header className="flex shrink-0 items-center justify-between gap-3 bg-brand-forest px-5 py-4 text-white">
            <div>
              <h2 className="font-black">Ask Catalyst</h2>
              <p className="text-xs text-white/80">Your heritage and travel guide</p>
            </div>
            <div className="flex gap-2">
              <button type="button" onClick={reset} aria-label="Start a new chat" title="Start a new chat" className="rounded-full bg-white/10 p-2 hover:bg-white/20">
                <RotateCcw size={16} />
              </button>
              <button type="button" onClick={() => setIsOpen(false)} aria-label="Close Ask Catalyst" className="rounded-full bg-white/10 p-2 hover:bg-white/20">
                <X size={18} />
              </button>
            </div>
          </header>

          <div
            ref={logRef}
            role="log"
            aria-live="polite"
            className="min-h-0 flex-1 space-y-3 overflow-y-auto overflow-x-hidden px-4 py-4 [overflow-wrap:anywhere]"
          >
            {messages.map((message) =>
              message.role === "user" ? (
                <p key={message.id} className="ml-auto w-fit max-w-[85%] rounded-2xl rounded-br-md bg-brand-forest px-4 py-2.5 text-sm leading-6 text-white">
                  {message.text}
                </p>
              ) : (
                <AssistantMessage key={message.id} reply={message.reply} onAddToCart={addToCart} />
              )
            )}
            {isThinking ? (
              <p className="w-fit rounded-2xl bg-brand-ivory px-4 py-2.5 text-sm text-brand-deep/80" aria-label="Ask Catalyst is typing">
                <span className="animate-pulse">Thinking…</span>
              </p>
            ) : null}
          </div>

          <div className="shrink-0 space-y-3 border-t border-brand-sage/25 px-4 py-3">
            <div className="flex flex-wrap gap-2">
              {suggestions.slice(0, 3).map((suggestion) => (
                <button
                  key={suggestion}
                  type="button"
                  onClick={() => send(suggestion)}
                  className="rounded-full border border-brand-sage/50 px-3 py-1.5 text-left text-xs font-semibold text-brand-deep hover:border-brand-terracotta"
                >
                  {suggestion}
                </button>
              ))}
            </div>
            <form
              onSubmit={(event) => {
                event.preventDefault();
                send(input);
              }}
              className="flex gap-2"
            >
              <label htmlFor="ask-catalyst-input" className="sr-only">
                Ask a question
              </label>
              <input
                id="ask-catalyst-input"
                ref={inputRef}
                value={input}
                onChange={(event) => setInput(event.target.value)}
                placeholder="Ask about cultures, places, trips…"
                autoComplete="off"
                className="min-w-0 flex-1 rounded-full border border-brand-sage/50 px-4 py-2 text-sm outline-none focus:border-brand-terracotta"
              />
              <button
                type="submit"
                disabled={!input.trim() || isThinking}
                aria-label="Send"
                className="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-brand-forest text-white disabled:opacity-50"
              >
                <Send size={17} />
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

function AssistantMessage({ reply, onAddToCart }: { reply: ChatReply; onAddToCart: (productId: string) => void }) {
  return (
    <div className="min-w-0 max-w-[92%] space-y-2.5 rounded-2xl rounded-bl-md bg-brand-ivory px-4 py-3 text-sm leading-6 text-brand-deep">
      {reply.text.map((paragraph) => (
        <p key={paragraph}>{paragraph}</p>
      ))}

      {reply.cards?.length ? (
        <div className="grid gap-2">
          {reply.cards.map((card) => (
            <Link key={card.href} href={card.href} className="flex items-center gap-3 rounded-xl bg-white p-2 pr-3 shadow-sm hover:ring-1 hover:ring-brand-terracotta">
              <span className="relative h-12 w-12 shrink-0 overflow-hidden rounded-lg bg-brand-sage/30">
                {card.image ? <Image src={card.image} alt="" fill sizes="48px" className="object-cover" /> : null}
              </span>
              <span className="min-w-0">
                <strong className="block truncate font-serif text-brand-deep">{card.title}</strong>
                <span className="block truncate text-xs text-brand-deep/80">{card.subtitle}</span>
              </span>
            </Link>
          ))}
        </div>
      ) : null}

      {reply.actions?.length ? (
        <div className="flex flex-wrap gap-2">
          {reply.actions.map((action) => (
            <button
              key={action.productId}
              type="button"
              onClick={() => onAddToCart(action.productId)}
              className="inline-flex items-center gap-1.5 rounded-full bg-brand-forest px-3 py-1.5 text-xs font-bold text-white hover:bg-brand-deep"
            >
              <ShoppingBag size={14} /> {action.label}
            </button>
          ))}
        </div>
      ) : null}

      {reply.links?.length ? (
        <div className="flex flex-col gap-1.5">
          {reply.links.map((link) => (
            <Link key={link.href + link.label} href={link.href} className="inline-flex items-center gap-1.5 font-bold text-brand-forest underline-offset-2 hover:underline">
              {link.label} <ArrowRight size={14} />
            </Link>
          ))}
        </div>
      ) : null}
    </div>
  );
}
