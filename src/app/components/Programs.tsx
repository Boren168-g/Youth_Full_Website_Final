import { useState } from "react";
import { ArrowRight, Clock, Users, Star } from "lucide-react";

const programs = [
  {
    tag: "Beginner",
    tagColor: "#00c9a7",
    tagBg: "#e6faf7",
    title: "CodeStarter",
    subtitle: "Ages 10–13",
    desc: "An engaging introduction to computational thinking using Scratch, block-based coding, and beginner Python. Students build games, animations, and simple apps.",
    duration: "12 weeks",
    seats: "20 per cohort",
    rating: "4.9",
    topics: ["Scratch", "Python Basics", "Game Dev", "Logic & Loops"],
    accent: "#00c9a7",
    img: "https://images.unsplash.com/photo-1761208662734-fb46f1398551?w=600&h=400&fit=crop&auto=format",
  },
  {
    tag: "Intermediate",
    tagColor: "#1e3fce",
    tagBg: "#eef1ff",
    title: "WebBuilders",
    subtitle: "Ages 13–16",
    desc: "Dive into HTML, CSS, and JavaScript. Students ship real websites, learn responsive design, and build interactive web applications with React.",
    duration: "16 weeks",
    seats: "18 per cohort",
    rating: "4.8",
    topics: ["HTML & CSS", "JavaScript", "React", "APIs"],
    accent: "#1e3fce",
    img: "https://images.unsplash.com/photo-1723987135977-ae935608939e?w=600&h=400&fit=crop&auto=format",
  },
  {
    tag: "Advanced",
    tagColor: "#ff6b35",
    tagBg: "#fff3ee",
    title: "AI Lab",
    subtitle: "Ages 15–18",
    desc: "Explore machine learning, neural networks, and AI ethics. Seniors work with real datasets, mentor younger students, and present capstone projects.",
    duration: "20 weeks",
    seats: "15 per cohort",
    rating: "5.0",
    topics: ["Python ML", "TensorFlow", "Data Science", "AI Ethics"],
    accent: "#ff6b35",
    img: "https://images.unsplash.com/photo-1705579610984-910ad33fe2db?w=600&h=400&fit=crop&auto=format",
  },
];

export function Programs() {
  const [active, setActive] = useState(0);
  const p = programs[active];

  return (
    <section id="programs" style={{ background: "#fff", padding: "100px 0" }}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Header */}
        <div className="flex flex-col lg:flex-row lg:items-end lg:justify-between mb-12 gap-6">
          <div>
            <p
              className="font-semibold text-sm tracking-widest mb-4 uppercase"
              style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}
            >
              What We Teach
            </p>
            <h2
              style={{
                fontFamily: "'Plus Jakarta Sans', sans-serif",
                fontSize: "clamp(2rem, 4vw, 3rem)",
                fontWeight: 800,
                color: "#0d0d2b",
                lineHeight: 1.1,
                letterSpacing: "-0.02em",
              }}
            >
              Three Tracks,
              <br />
              Infinite Futures
            </h2>
          </div>
          <button
            className="flex items-center gap-2 px-6 py-3 rounded-full font-semibold text-sm border-2 transition-all hover:scale-105"
            style={{
              fontFamily: "'Outfit', sans-serif",
              borderColor: "#0d0d2b",
              color: "#0d0d2b",
            }}
          >
            View Full Curriculum
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>

        {/* Tab switcher */}
        <div
          className="flex gap-2 mb-8 p-1.5 rounded-full w-fit"
          style={{ background: "#f8f7f4" }}
        >
          {programs.map((prog, i) => (
            <button
              key={prog.title}
              onClick={() => setActive(i)}
              className="px-5 py-2 rounded-full font-semibold text-sm transition-all"
              style={{
                fontFamily: "'Outfit', sans-serif",
                background: active === i ? p.accent : "transparent",
                color: active === i ? "#fff" : "#6b6b80",
              }}
            >
              {prog.title}
            </button>
          ))}
        </div>

        {/* Main card */}
        <div
          className="grid lg:grid-cols-2 rounded-3xl overflow-hidden"
          style={{
            background: "#f8f7f4",
            border: "1px solid rgba(13,13,43,0.08)",
          }}
        >
          {/* Image side */}
          <div className="relative" style={{ minHeight: 360 }}>
            <img
              src={p.img}
              alt={`${p.title} program`}
              className="w-full h-full object-cover"
            />
            <div
              className="absolute inset-0"
              style={{
                background: "linear-gradient(135deg, rgba(13,13,43,0.3) 0%, transparent 60%)",
              }}
            />
            <div
              className="absolute top-6 left-6 px-3 py-1.5 rounded-full text-xs font-bold"
              style={{
                background: p.tagBg,
                color: p.tagColor,
                fontFamily: "'Outfit', sans-serif",
              }}
            >
              {p.tag}
            </div>
          </div>

          {/* Text side */}
          <div className="p-10 lg:p-12 flex flex-col justify-center">
            <div className="mb-2">
              <p
                className="text-sm font-medium"
                style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
              >
                {p.subtitle}
              </p>
            </div>
            <h3
              className="mb-4"
              style={{
                fontFamily: "'Plus Jakarta Sans', sans-serif",
                fontSize: "2rem",
                fontWeight: 800,
                color: "#0d0d2b",
                letterSpacing: "-0.02em",
              }}
            >
              {p.title}
            </h3>
            <p
              className="mb-8 leading-relaxed"
              style={{
                fontFamily: "'Outfit', sans-serif",
                color: "#4a4a6a",
                fontSize: "1rem",
              }}
            >
              {p.desc}
            </p>

            {/* Meta */}
            <div className="flex gap-6 mb-8">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4" style={{ color: "#6b6b80" }} />
                <span
                  className="text-sm"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#4a4a6a" }}
                >
                  {p.duration}
                </span>
              </div>
              <div className="flex items-center gap-2">
                <Users className="w-4 h-4" style={{ color: "#6b6b80" }} />
                <span
                  className="text-sm"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#4a4a6a" }}
                >
                  {p.seats}
                </span>
              </div>
              <div className="flex items-center gap-2">
                <Star className="w-4 h-4" style={{ color: "#ffd23f" }} fill="#ffd23f" />
                <span
                  className="text-sm font-semibold"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#0d0d2b" }}
                >
                  {p.rating}
                </span>
              </div>
            </div>

            {/* Topics */}
            <div className="flex flex-wrap gap-2 mb-8">
              {p.topics.map((t) => (
                <span
                  key={t}
                  className="px-3 py-1 rounded-full text-xs font-semibold"
                  style={{
                    background: p.tagBg,
                    color: p.tagColor,
                    fontFamily: "'Outfit', sans-serif",
                  }}
                >
                  {t}
                </span>
              ))}
            </div>

            <button
              className="flex items-center gap-2 px-6 py-3 rounded-full font-semibold text-sm w-fit transition-all hover:scale-105 active:scale-95"
              style={{
                background: p.accent,
                color: "#fff",
                fontFamily: "'Outfit', sans-serif",
              }}
            >
              Apply Now — It's Free
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
