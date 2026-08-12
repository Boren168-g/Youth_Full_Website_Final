import { useState } from "react";
import { ChevronLeft, ChevronRight, Quote } from "lucide-react";

const testimonials = [
  {
    name: "Maya Johnson",
    role: "C4Y Alumni, 2022 — Now studying CS at Stanford",
    body: "Code for Youth changed everything for me. I grew up in a neighborhood where nobody talked about tech careers. My instructor saw something in me and pushed me to build my first Python project. Now I'm on a full scholarship at Stanford. I owe so much to this program.",
    initials: "MJ",
    color: "#ff6b35",
  },
  {
    name: "DeShawn Williams",
    role: "Parent of two C4Y students",
    body: "Both my kids are in the program and the change in their confidence is unbelievable. My 14-year-old already has her first freelance client. The instructors are patient, the curriculum is real-world, and it's free. I tell every parent I know.",
    initials: "DW",
    color: "#1e3fce",
  },
  {
    name: "Priya Nair",
    role: "C4Y Alumni, 2020 — Co-founder, EdTech startup",
    body: "The AI Lab program taught me how to learn, not just what to learn. That mindset shift is what helped me co-found a startup right after high school. We raised our first round at 19. None of that happens without Code for Youth.",
    initials: "PN",
    color: "#00c9a7",
  },
  {
    name: "Tomás Rivera",
    role: "C4Y Volunteer Instructor",
    body: "Teaching here is the most rewarding thing I've done in my 12 years as a software engineer. These kids are sharp, hungry, and creative. All they needed was an open door. Code for Youth is that door.",
    initials: "TR",
    color: "#ffd23f",
  },
];

export function Testimonials() {
  const [idx, setIdx] = useState(0);
  const t = testimonials[idx];

  const prev = () => setIdx((i) => (i - 1 + testimonials.length) % testimonials.length);
  const next = () => setIdx((i) => (i + 1) % testimonials.length);

  return (
    <section style={{ background: "#0d0d2b", padding: "100px 0" }}>
      <div className="max-w-4xl mx-auto px-6 text-center">
        <p
          className="font-semibold text-sm tracking-widest mb-4 uppercase"
          style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}
        >
          Stories
        </p>
        <h2
          className="mb-16 text-white"
          style={{
            fontFamily: "'Plus Jakarta Sans', sans-serif",
            fontSize: "clamp(2rem, 4vw, 3rem)",
            fontWeight: 800,
            letterSpacing: "-0.02em",
            lineHeight: 1.1,
          }}
        >
          The Real Impact
        </h2>

        <div
          className="rounded-3xl p-10 lg:p-14 relative"
          style={{
            background: "#111130",
            border: "1px solid rgba(255,255,255,0.06)",
          }}
        >
          <Quote
            className="w-10 h-10 mb-8 mx-auto opacity-30"
            style={{ color: t.color }}
          />

          <p
            className="text-white/80 leading-relaxed mb-10"
            style={{
              fontFamily: "'Outfit', sans-serif",
              fontSize: "clamp(1rem, 2vw, 1.2rem)",
            }}
          >
            "{t.body}"
          </p>

          <div className="flex items-center justify-center gap-4">
            <div
              className="w-12 h-12 rounded-full flex items-center justify-center font-bold text-sm"
              style={{
                background: t.color,
                color: "#fff",
                fontFamily: "'Plus Jakarta Sans', sans-serif",
              }}
            >
              {t.initials}
            </div>
            <div className="text-left">
              <p
                className="font-bold text-white"
                style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}
              >
                {t.name}
              </p>
              <p
                className="text-sm text-white/50"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                {t.role}
              </p>
            </div>
          </div>
        </div>

        {/* Controls */}
        <div className="flex items-center justify-center gap-4 mt-8">
          <button
            onClick={prev}
            className="w-10 h-10 rounded-full flex items-center justify-center border border-white/20 text-white hover:border-white/50 transition-colors"
          >
            <ChevronLeft className="w-4 h-4" />
          </button>

          <div className="flex gap-2">
            {testimonials.map((_, i) => (
              <button
                key={i}
                onClick={() => setIdx(i)}
                className="rounded-full transition-all"
                style={{
                  width: i === idx ? 24 : 8,
                  height: 8,
                  background: i === idx ? t.color : "rgba(255,255,255,0.2)",
                }}
              />
            ))}
          </div>

          <button
            onClick={next}
            className="w-10 h-10 rounded-full flex items-center justify-center border border-white/20 text-white hover:border-white/50 transition-colors"
          >
            <ChevronRight className="w-4 h-4" />
          </button>
        </div>
      </div>
    </section>
  );
}
