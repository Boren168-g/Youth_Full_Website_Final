import { useEffect, useRef, useState } from "react";

const stats = [
  { value: 4200, suffix: "+", label: "Students Taught", color: "#ff6b35" },
  { value: 38, suffix: "", label: "Cities Reached", color: "#1e3fce" },
  { value: 92, suffix: "%", label: "Pursue STEM Careers", color: "#00c9a7" },
  { value: 1200, suffix: "+", label: "Scholarships Awarded", color: "#ffd23f" },
];

function CountUp({ target, suffix }: { target: number; suffix: string }) {
  const [count, setCount] = useState(0);
  const ref = useRef<HTMLSpanElement>(null);
  const started = useRef(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting && !started.current) {
          started.current = true;
          const duration = 1800;
          const step = 16;
          const steps = duration / step;
          let current = 0;
          const timer = setInterval(() => {
            current++;
            setCount(Math.round(target * (current / steps)));
            if (current >= steps) {
              setCount(target);
              clearInterval(timer);
            }
          }, step);
        }
      },
      { threshold: 0.5 }
    );
    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, [target]);

  return (
    <span ref={ref}>
      {count.toLocaleString()}
      {suffix}
    </span>
  );
}

export function Stats() {
  return (
    <section id="impact" style={{ background: "#0d0d2b", padding: "80px 0" }}>
      <div className="max-w-7xl mx-auto px-6">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-8 lg:gap-4">
          {stats.map((s) => (
            <div key={s.label} className="text-center">
              <p
                className="mb-2"
                style={{
                  fontFamily: "'Plus Jakarta Sans', sans-serif",
                  fontSize: "clamp(2.5rem, 5vw, 3.5rem)",
                  fontWeight: 800,
                  color: s.color,
                  letterSpacing: "-0.03em",
                }}
              >
                <CountUp target={s.value} suffix={s.suffix} />
              </p>
              <p
                className="text-white/50"
                style={{
                  fontFamily: "'Outfit', sans-serif",
                  fontSize: "0.95rem",
                }}
              >
                {s.label}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
