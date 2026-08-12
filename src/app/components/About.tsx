import { Heart, Zap, Globe } from "lucide-react";

const values = [
  {
    icon: Heart,
    title: "Equity First",
    body: "We believe zip code shouldn't determine a child's future in tech. All programs are 100% free for participants.",
    color: "#ff6b35",
    bg: "#fff3ee",
  },
  {
    icon: Zap,
    title: "Real Skills",
    body: "From Python to machine learning, our curriculum mirrors what professional engineers use every day.",
    color: "#1e3fce",
    bg: "#eef1ff",
  },
  {
    icon: Globe,
    title: "Global Community",
    body: "Students join a network of 4,200+ peers, mentors, and alumni spanning 38 cities worldwide.",
    color: "#00c9a7",
    bg: "#e6faf7",
  },
];

export function About() {
  return (
    <section id="about" style={{ background: "#f8f7f4", padding: "100px 0" }}>
      <div className="max-w-7xl mx-auto px-6">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          {/* Left — image */}
          <div className="relative">
            <div
              className="rounded-3xl overflow-hidden"
              style={{
                background: "#eeede8",
                aspectRatio: "4/3",
              }}
            >
              <img
                src="https://images.unsplash.com/photo-1761208662734-fb46f1398551?w=800&h=600&fit=crop&auto=format"
                alt="Instructor teaching children to code at classroom desks"
                className="w-full h-full object-cover"
              />
            </div>

            {/* Floating card */}
            <div
              className="absolute -bottom-8 -right-6 lg:-right-10 p-5 rounded-2xl shadow-xl max-w-xs"
              style={{ background: "#fff" }}
            >
              <p
                className="text-sm text-gray-500 mb-1"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                Student Story
              </p>
              <p
                className="font-semibold text-sm leading-snug"
                style={{
                  fontFamily: "'Plus Jakarta Sans', sans-serif",
                  color: "#0d0d2b",
                }}
              >
                "I built my first app at 13. Now I'm studying CS at MIT."
              </p>
              <p
                className="text-xs text-gray-400 mt-2"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                — Amara, C4Y Class of 2021
              </p>
            </div>

            {/* Accent dot grid */}
            <div
              className="absolute -top-6 -left-6 w-20 h-20 rounded-full opacity-60"
              style={{
                background:
                  "radial-gradient(circle, #ffd23f 1.5px, transparent 1.5px)",
                backgroundSize: "8px 8px",
              }}
            />
          </div>

          {/* Right — text */}
          <div>
            <p
              className="font-semibold text-sm tracking-widest mb-4 uppercase"
              style={{
                fontFamily: "'Outfit', sans-serif",
                color: "#ff6b35",
              }}
            >
              Our Mission
            </p>
            <h2
              className="mb-6"
              style={{
                fontFamily: "'Plus Jakarta Sans', sans-serif",
                fontSize: "clamp(2rem, 4vw, 3rem)",
                fontWeight: 800,
                color: "#0d0d2b",
                lineHeight: 1.1,
                letterSpacing: "-0.02em",
              }}
            >
              Closing the Tech
              <br />
              Opportunity Gap
            </h2>
            <p
              className="mb-10 leading-relaxed"
              style={{
                fontFamily: "'Outfit', sans-serif",
                fontSize: "1.05rem",
                color: "#4a4a6a",
              }}
            >
              Founded in 2017, Code for Youth was born from a simple observation:
              the future belongs to those who can build it. Yet millions of talented
              young people never get the chance to learn how. We're changing that —
              one student, one community, one line of code at a time.
            </p>

            <div className="flex flex-col gap-6">
              {values.map((v) => (
                <div key={v.title} className="flex gap-5 items-start">
                  <div
                    className="w-11 h-11 rounded-xl flex items-center justify-center shrink-0"
                    style={{ background: v.bg }}
                  >
                    <v.icon className="w-5 h-5" style={{ color: v.color }} />
                  </div>
                  <div>
                    <p
                      className="font-bold mb-1"
                      style={{
                        fontFamily: "'Plus Jakarta Sans', sans-serif",
                        color: "#0d0d2b",
                      }}
                    >
                      {v.title}
                    </p>
                    <p
                      className="text-sm leading-relaxed"
                      style={{
                        fontFamily: "'Outfit', sans-serif",
                        color: "#6b6b80",
                      }}
                    >
                      {v.body}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
