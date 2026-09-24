import Link from "next/link";
import { asset } from "@/lib/basePath";
import {
  ArrowRight,
  CheckCircle2,
  CircleDot,
  Layers3,
  ShieldCheck,
  Sparkles
} from "lucide-react";

type PlaceholderPageProps = {
  eyebrow: string;
  title: string;
  description: string;
  modules: string[];
};

export default function PlaceholderPage({
  eyebrow,
  title,
  description,
  modules
}: PlaceholderPageProps) {
  const metrics = [
    { label: "Demo State", value: "Prototype", detail: "Frontend showcase" },
    { label: "Workflow", value: `${modules.length} modules`, detail: "Ready for API wiring" },
    { label: "Governance", value: "Review", detail: "Verification required" }
  ];

  return (
    <main className="min-h-screen bg-brand-ivory">
      <section className="relative -mt-6 overflow-hidden bg-brand-deep">
        <div className="absolute inset-0 bg-cover bg-center opacity-35" style={{ backgroundImage: `url(${asset("/images/hero/south-africa-heritage.jpg")})` }} />
        <div className="absolute inset-0 bg-gradient-to-r from-black/80 via-brand-deep/82 to-brand-deep/38" />
        <div className="absolute left-0 top-0 h-full w-28 bg-[linear-gradient(135deg,rgba(248,245,236,0.14)_25%,transparent_25%,transparent_50%,rgba(248,245,236,0.14)_50%,rgba(248,245,236,0.14)_75%,transparent_75%)] bg-[length:36px_36px] opacity-40" />
        <div className="relative mx-auto grid min-h-[390px] max-w-[1800px] items-center gap-10 px-6 py-16 md:grid-cols-[1fr_420px] md:px-20">
          <div>
            <p className="text-sm font-black uppercase tracking-[0.46em] text-brand-sand">
              {eyebrow}
            </p>
            <h1 className="mt-5 max-w-5xl font-serif text-5xl font-black leading-[0.95] text-white md:text-7xl">
              {title}
            </h1>
            <p className="mt-6 max-w-3xl text-lg leading-8 text-white/84">
              {description}
            </p>
          </div>

          <aside className="rounded-xl border border-white/20 bg-white/10 p-5 text-white backdrop-blur-md">
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-full bg-brand-sand text-brand-deep">
                <Sparkles size={22} />
              </div>
              <div>
                <p className="text-sm uppercase tracking-[0.18em] text-white/65">Showcase Readiness</p>
                <p className="text-2xl font-black">Styled demo module</p>
              </div>
            </div>
            <div className="mt-5 grid gap-3">
              {["Consistent visual system", "Clear demo-data disclaimer", "Ready for backend integration"].map((item) => (
                <p key={item} className="flex items-center gap-3 rounded-lg bg-white/10 px-4 py-3 text-sm font-semibold">
                  <CheckCircle2 size={17} className="text-brand-sand" /> {item}
                </p>
              ))}
            </div>
          </aside>
        </div>
      </section>

      <section className="border-b border-brand-sage/25 bg-[#f3efe3]">
        <div className="mx-auto grid max-w-[1800px] gap-4 px-6 py-5 md:grid-cols-3 md:px-20">
          {metrics.map((metric) => (
            <article key={metric.label} className="rounded-xl bg-white p-5 shadow-sm">
              <p className="text-xs font-black uppercase tracking-[0.22em] text-brand-terracotta">{metric.label}</p>
              <p className="mt-2 font-serif text-3xl font-black text-brand-deep">{metric.value}</p>
              <p className="mt-1 text-sm text-brand-deep/65">{metric.detail}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="mx-auto grid max-w-[1800px] gap-8 px-6 py-12 md:grid-cols-[1fr_360px] md:px-20">
        <div>
          <div className="flex items-end justify-between gap-4">
            <div>
              <p className="text-sm font-black uppercase tracking-[0.3em] text-brand-terracotta">
                Module Map
              </p>
              <h2 className="mt-2 font-serif text-4xl font-black text-brand-deep">
                What this area will manage
              </h2>
            </div>
            <Link href="/" className="hidden items-center gap-2 font-bold text-brand-deep md:flex">
              Back home <ArrowRight size={17} />
            </Link>
          </div>

          <div className="mt-8 grid gap-5 md:grid-cols-3">
            {modules.map((module, index) => (
              <article key={module} className="rounded-xl border border-brand-sage/25 bg-white p-6 shadow-sm">
                <div className="flex items-center justify-between">
                  <div className="grid h-11 w-11 place-items-center rounded-lg bg-brand-ivory text-brand-terracotta">
                    {index % 3 === 0 ? <Layers3 size={21} /> : index % 3 === 1 ? <ShieldCheck size={21} /> : <CircleDot size={21} />}
                  </div>
                  <span className="rounded-full bg-brand-sage/20 px-3 py-1 text-xs font-black text-brand-deep">
                    {String(index + 1).padStart(2, "0")}
                  </span>
                </div>
                <h3 className="mt-5 font-serif text-2xl font-black text-brand-deep">{module}</h3>
                <p className="mt-3 leading-7 text-brand-deep/70">
                  Frontend-ready workflow surface prepared for verified data, permissions, audit trails and production APIs.
                </p>
              </article>
            ))}
          </div>
        </div>

        <aside className="grid content-start gap-5">
          <article className="rounded-xl bg-brand-deep p-6 text-white">
            <p className="text-sm font-black uppercase tracking-[0.24em] text-brand-sand">Integration Note</p>
            <h2 className="mt-3 font-serif text-3xl font-black">Demo-safe by design</h2>
            <p className="mt-4 leading-7 text-white/78">
              This page intentionally presents sample workflows without claiming live payments, confirmed bookings, verified event data or official records.
            </p>
          </article>

          <article className="rounded-xl border border-brand-sage/30 bg-white p-6 shadow-sm">
            <p className="text-sm font-black uppercase tracking-[0.24em] text-brand-terracotta">Next Steps</p>
            <div className="mt-4 grid gap-3 text-sm font-semibold text-brand-deep/75">
              <p>Connect role-based APIs and server authorization.</p>
              <p>Add verified source records and review approvals.</p>
              <p>Replace sample metrics with consented production analytics.</p>
            </div>
          </article>
        </aside>
      </section>
    </main>
  );
}
