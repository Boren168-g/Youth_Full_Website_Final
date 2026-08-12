import { ArrowRight, Play } from "lucide-react";
import { useState } from "react";

const codeSnippet = `# Your future starts here
def change_the_world():
    skills = ["Python", "Web Dev",
              "AI", "Robotics"]
    for skill in skills:
        learn(skill)
        build(something_amazing)
    return confidence + opportunity

change_the_world() ✨`;

export function Hero() {
  const [videoOpen, setVideoOpen] = useState(false);

  const scrollTo = (href: string) => {
    const el = document.querySelector(href);
    if (el) el.scrollIntoView({ behavior: "smooth" });
  };

  return (
    <section
      className="relative min-h-screen flex items-center overflow-hidden"
      style={{ background: "#0d0d2b" }}
    >
      {/* Background geometric shapes */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div
          className="absolute -top-32 -right-32 w-96 h-96 rounded-full opacity-20"
          style={{ background: "#1e3fce" }}
        />
        <div
          className="absolute top-1/3 -left-20 w-64 h-64 rounded-full opacity-10"
          style={{ background: "#ff6b35" }}
        />
        <div
          className="absolute bottom-20 right-1/4 w-48 h-48 rounded-full opacity-10"
          style={{ background: "#ffd23f" }}
        />
        {/* Grid lines */}
        <div
          className="absolute inset-0 opacity-5"
          style={{
            backgroundImage:
              "linear-gradient(rgba(255,255,255,0.3) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.3) 1px, transparent 1px)",
            backgroundSize: "60px 60px",
          }}
        />
      </div>

      <div className="relative max-w-7xl mx-auto px-6 pt-24 pb-16 w-full">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          {/* Left */}
          <div>
            <div
              className="inline-flex items-center gap-2 px-4 py-2 rounded-full text-sm font-semibold mb-8"
              style={{
                background: "rgba(255,107,53,0.15)",
                color: "#ff6b35",
                border: "1px solid rgba(255,107,53,0.3)",
                fontFamily: "'Outfit', sans-serif",
              }}
            >
              <span className="w-2 h-2 rounded-full bg-current animate-pulse" />
              Applications Open — Summer 2025
            </div>

            <h1
              className="text-white leading-[1.05] mb-6"
              style={{
                fontFamily: "'Plus Jakarta Sans', sans-serif",
                fontSize: "clamp(2.8rem, 6vw, 5rem)",
                fontWeight: 800,
                letterSpacing: "-0.02em",
              }}
            >
              Every Kid
              <br />
              <span style={{ color: "#ff6b35" }}>Deserves to</span>
              <br />
              Code.
            </h1>

            <p
              className="text-white/60 mb-10 max-w-md leading-relaxed"
              style={{
                fontFamily: "'Outfit', sans-serif",
                fontSize: "1.15rem",
                fontWeight: 400,
              }}
            >
              Code for Youth provides free, world-class coding education to
              students aged 10–18 from underserved communities. No experience
              needed — just curiosity.
            </p>

            <div className="flex flex-wrap gap-4">
              <button
                onClick={() => scrollTo("#programs")}
                className="flex items-center gap-2 px-7 py-3.5 rounded-full font-semibold transition-all hover:scale-105 active:scale-95"
                style={{
                  background: "#ff6b35",
                  color: "#fff",
                  fontFamily: "'Outfit', sans-serif",
                  fontSize: "1rem",
                }}
              >
                Explore Programs
                <ArrowRight className="w-4 h-4" />
              </button>
              <button
                onClick={() => setVideoOpen(true)}
                className="flex items-center gap-2 px-7 py-3.5 rounded-full font-semibold border border-white/20 text-white hover:border-white/50 transition-all"
                style={{
                  fontFamily: "'Outfit', sans-serif",
                  fontSize: "1rem",
                }}
              >
                <Play className="w-4 h-4" />
                Watch Story
              </button>
            </div>

            {/* Social proof */}
            <div className="mt-12 flex items-center gap-8">
              <div>
                <p
                  className="text-white font-bold"
                  style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", fontSize: "1.6rem" }}
                >
                  4,200+
                </p>
                <p className="text-white/50 text-sm" style={{ fontFamily: "'Outfit', sans-serif" }}>
                  Students Taught
                </p>
              </div>
              <div className="w-px h-10 bg-white/10" />
              <div>
                <p
                  className="text-white font-bold"
                  style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", fontSize: "1.6rem" }}
                >
                  38
                </p>
                <p className="text-white/50 text-sm" style={{ fontFamily: "'Outfit', sans-serif" }}>
                  Cities Reached
                </p>
              </div>
              <div className="w-px h-10 bg-white/10" />
              <div>
                <p
                  className="text-white font-bold"
                  style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", fontSize: "1.6rem" }}
                >
                  100%
                </p>
                <p className="text-white/50 text-sm" style={{ fontFamily: "'Outfit', sans-serif" }}>
                  Free
                </p>
              </div>
            </div>
          </div>

          {/* Right — code card */}
          <div className="relative">
            <div
              className="rounded-2xl overflow-hidden"
              style={{
                background: "#111130",
                border: "1px solid rgba(255,255,255,0.08)",
                boxShadow: "0 40px 80px rgba(0,0,0,0.5)",
              }}
            >
              {/* Window chrome */}
              <div
                className="flex items-center gap-2 px-5 py-3.5"
                style={{ borderBottom: "1px solid rgba(255,255,255,0.06)" }}
              >
                <div className="w-3 h-3 rounded-full bg-red-500/70" />
                <div className="w-3 h-3 rounded-full bg-yellow-500/70" />
                <div className="w-3 h-3 rounded-full bg-green-500/70" />
                <span
                  className="ml-3 text-white/30 text-xs"
                  style={{ fontFamily: "'JetBrains Mono', monospace" }}
                >
                  hello_world.py
                </span>
              </div>

              {/* Code */}
              <pre
                className="p-6 text-sm leading-7 overflow-x-auto"
                style={{
                  fontFamily: "'JetBrains Mono', monospace",
                  color: "#a8b3cf",
                }}
              >
                {codeSnippet.split("\n").map((line, i) => (
                  <div key={i} className="flex gap-4">
                    <span className="select-none text-white/20 w-4 text-right shrink-0">
                      {i + 1}
                    </span>
                    <span
                      style={{
                        color:
                          line.startsWith("#")
                            ? "#00c9a7"
                            : line.includes("def ")
                            ? "#ffd23f"
                            : line.includes('"')
                            ? "#ff6b35"
                            : line.includes("return")
                            ? "#c084fc"
                            : "#a8b3cf",
                      }}
                    >
                      {line}
                    </span>
                  </div>
                ))}
              </pre>

              {/* Typing cursor */}
              <div className="px-6 pb-5 flex items-center gap-2">
                <span
                  className="text-green-400 text-sm"
                  style={{ fontFamily: "'JetBrains Mono', monospace" }}
                >
                  ▶ Running...
                </span>
                <span
                  className="w-2 h-4 bg-green-400 animate-pulse"
                  style={{ animationDuration: "1s" }}
                />
              </div>
            </div>

            {/* Floating badge */}
            <div
              className="absolute -bottom-6 -left-6 px-5 py-3 rounded-2xl shadow-xl"
              style={{ background: "#ffd23f" }}
            >
              <p
                className="font-bold text-sm"
                style={{
                  fontFamily: "'Plus Jakarta Sans', sans-serif",
                  color: "#0d0d2b",
                }}
              >
                🎓 312 graduates in 2024
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Video modal */}
      {videoOpen && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-6"
          style={{ background: "rgba(0,0,0,0.85)" }}
          onClick={() => setVideoOpen(false)}
        >
          <div
            className="w-full max-w-3xl aspect-video rounded-2xl overflow-hidden flex items-center justify-center"
            style={{ background: "#111130" }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="text-center">
              <div
                className="w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4"
                style={{ background: "#ff6b35" }}
              >
                <Play className="w-8 h-8 text-white ml-1" />
              </div>
              <p
                className="text-white/60"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                Video coming soon
              </p>
              <button
                className="mt-4 text-white/40 text-sm hover:text-white/70"
                onClick={() => setVideoOpen(false)}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
