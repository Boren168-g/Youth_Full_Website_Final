import { Calendar, MapPin, ArrowRight, Clock } from "lucide-react";

const events = [
  {
    date: { month: "JUL", day: "12" },
    title: "Summer Bootcamp Kickoff",
    type: "In-Person",
    location: "Chicago, IL — Millennium Park Pavilion",
    time: "9:00 AM – 12:00 PM",
    desc: "Meet your cohort, set up your dev environment, and write your very first Python program.",
    color: "#ff6b35",
    spots: "48 spots left",
  },
  {
    date: { month: "JUL", day: "19" },
    title: "Parent & Family Info Night",
    type: "Virtual",
    location: "Zoom (link sent after registration)",
    time: "7:00 PM – 8:30 PM",
    desc: "Learn how C4Y works, meet the instructors, and ask every question you have before your child starts.",
    color: "#1e3fce",
    spots: "Open",
  },
  {
    date: { month: "AUG", day: "02" },
    title: "AI Demo Day — Cohort 14",
    type: "In-Person + Livestream",
    location: "Detroit, MI — TechTown",
    time: "2:00 PM – 5:00 PM",
    desc: "Watch our graduating AI Lab students present original machine learning projects to a panel of industry judges.",
    color: "#00c9a7",
    spots: "Public — Free admission",
  },
  {
    date: { month: "AUG", day: "23" },
    title: "Scholarship Application Deadline",
    type: "Online",
    location: "codeforyouth.org/apply",
    time: "11:59 PM EST",
    desc: "Last chance to apply for our Fall 2025 cohort. Complete applications are reviewed within 2 weeks.",
    color: "#ffd23f",
    spots: "12 seats remaining",
  },
];

export function Events() {
  return (
    <section id="events" style={{ background: "#fff", padding: "100px 0" }}>
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex flex-col lg:flex-row lg:items-end lg:justify-between mb-12 gap-6">
          <div>
            <p
              className="font-semibold text-sm tracking-widest mb-4 uppercase"
              style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}
            >
              Upcoming
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
              Events & Deadlines
            </h2>
          </div>
          <button
            className="flex items-center gap-2 px-6 py-3 rounded-full font-semibold text-sm border-2 w-fit transition-all hover:scale-105"
            style={{
              fontFamily: "'Outfit', sans-serif",
              borderColor: "#0d0d2b",
              color: "#0d0d2b",
            }}
          >
            Full Calendar
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>

        <div className="flex flex-col gap-4">
          {events.map((ev) => (
            <div
              key={ev.title}
              className="grid md:grid-cols-[auto_1fr_auto] gap-6 items-center p-6 rounded-2xl group hover:-translate-y-0.5 transition-all cursor-pointer"
              style={{
                background: "#f8f7f4",
                border: "1px solid rgba(13,13,43,0.06)",
              }}
            >
              {/* Date */}
              <div
                className="w-16 h-16 rounded-xl flex flex-col items-center justify-center shrink-0"
                style={{ background: ev.color }}
              >
                <span
                  className="text-xs text-white/80 font-semibold"
                  style={{ fontFamily: "'Outfit', sans-serif" }}
                >
                  {ev.date.month}
                </span>
                <span
                  className="text-2xl font-black text-white leading-none"
                  style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}
                >
                  {ev.date.day}
                </span>
              </div>

              {/* Info */}
              <div>
                <div className="flex flex-wrap gap-2 items-center mb-1">
                  <h3
                    className="font-bold"
                    style={{
                      fontFamily: "'Plus Jakarta Sans', sans-serif",
                      color: "#0d0d2b",
                      fontSize: "1.05rem",
                    }}
                  >
                    {ev.title}
                  </h3>
                  <span
                    className="px-2.5 py-0.5 rounded-full text-xs font-semibold"
                    style={{
                      background: "#eeede8",
                      color: "#6b6b80",
                      fontFamily: "'Outfit', sans-serif",
                    }}
                  >
                    {ev.type}
                  </span>
                </div>

                <div className="flex flex-wrap gap-4 text-sm mb-2">
                  <span
                    className="flex items-center gap-1.5"
                    style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                  >
                    <MapPin className="w-3.5 h-3.5" />
                    {ev.location}
                  </span>
                  <span
                    className="flex items-center gap-1.5"
                    style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                  >
                    <Clock className="w-3.5 h-3.5" />
                    {ev.time}
                  </span>
                </div>

                <p
                  className="text-sm leading-relaxed"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#4a4a6a" }}
                >
                  {ev.desc}
                </p>
              </div>

              {/* CTA */}
              <div className="flex flex-col items-end gap-2 shrink-0">
                <span
                  className="text-xs font-semibold"
                  style={{ fontFamily: "'Outfit', sans-serif", color: ev.color }}
                >
                  {ev.spots}
                </span>
                <button
                  className="flex items-center gap-1.5 px-4 py-2 rounded-full text-sm font-semibold transition-all hover:scale-105"
                  style={{
                    background: ev.color,
                    color: "#fff",
                    fontFamily: "'Outfit', sans-serif",
                  }}
                >
                  Register
                  <ArrowRight className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
