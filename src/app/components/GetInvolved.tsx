import { ArrowRight, Code2, Heart, Users, BookOpen } from "lucide-react";

const ways = [
  {
    icon: BookOpen,
    title: "Enroll Your Child",
    desc: "Our programs are free for students aged 10–18. Apply online and we'll match them to the right track.",
    cta: "Apply Now",
    color: "#ff6b35",
    bg: "#fff3ee",
  },
  {
    icon: Code2,
    title: "Volunteer",
    desc: "Got a tech background? Become a mentor, guest speaker, or curriculum reviewer. 2–5 hrs/week.",
    cta: "Volunteer",
    color: "#1e3fce",
    bg: "#eef1ff",
  },
  {
    icon: Heart,
    title: "Donate",
    desc: "$50 covers one student's materials. $500 funds a full scholarship. Every dollar goes directly to programs.",
    cta: "Give Now",
    color: "#00c9a7",
    bg: "#e6faf7",
  },
  {
    icon: Users,
    title: "Partner With Us",
    desc: "Companies can sponsor cohorts, offer internships, and build pipelines of diverse early-career talent.",
    cta: "Partner",
    color: "#ffd23f",
    bg: "#fffbe6",
  },
];

export function GetInvolved() {
  return (
    <section
      style={{
        background: "linear-gradient(135deg, #0d0d2b 0%, #1a1a4e 100%)",
        padding: "100px 0",
      }}
    >
      <div className="max-w-7xl mx-auto px-6">
        <div className="text-center mb-14">
          <p
            className="font-semibold text-sm tracking-widest mb-4 uppercase"
            style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}
          >
            Get Involved
          </p>
          <h2
            className="text-white mb-4"
            style={{
              fontFamily: "'Plus Jakarta Sans', sans-serif",
              fontSize: "clamp(2rem, 4vw, 3rem)",
              fontWeight: 800,
              letterSpacing: "-0.02em",
              lineHeight: 1.1,
            }}
          >
            Four Ways to Help
          </h2>
          <p
            className="text-white/50 max-w-xl mx-auto"
            style={{ fontFamily: "'Outfit', sans-serif", fontSize: "1.05rem" }}
          >
            Whether you're a parent, engineer, donor, or company — there's a meaningful way for you to be part of this.
          </p>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-5">
          {ways.map((w) => (
            <div
              key={w.title}
              className="p-7 rounded-2xl group hover:-translate-y-1 transition-all cursor-pointer"
              style={{
                background: "rgba(255,255,255,0.04)",
                border: "1px solid rgba(255,255,255,0.08)",
              }}
            >
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center mb-5"
                style={{ background: w.bg }}
              >
                <w.icon className="w-5 h-5" style={{ color: w.color }} />
              </div>

              <h3
                className="text-white font-bold mb-3"
                style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", fontSize: "1.1rem" }}
              >
                {w.title}
              </h3>
              <p
                className="text-white/50 text-sm leading-relaxed mb-6"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                {w.desc}
              </p>

              <button
                className="flex items-center gap-1.5 text-sm font-semibold group-hover:gap-2.5 transition-all"
                style={{ color: w.color, fontFamily: "'Outfit', sans-serif" }}
              >
                {w.cta}
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
