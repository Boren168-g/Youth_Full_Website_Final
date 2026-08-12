import { Calendar, MapPin, ArrowRight, Clock, X } from "lucide-react";
import { useState } from "react";

const events = [
  {
    date: { month: "SEP", day: "15" },
    title: "Phnom Penh Tech Summit",
    type: "Conference",
    location: "Factory Phnom Penh",
    time: "8:30 AM – 4:30 PM",
    desc: "Join local developers and startups for workshops, networking, and the future of tech in Cambodia.",
    color: "#ff6b35",
    spots: "Limited seats",
  },
  {
    date: { month: "OCT", day: "05" },
    title: "Siem Reap Coding Bootcamp",
    type: "Workshop",
    location: "Heritage Hub",
    time: "1:00 PM – 5:00 PM",
    desc: "A hands-on intensive session for beginners. Learn web development basics near the temples.",
    color: "#1e3fce",
    spots: "20 spots left",
  },
  {
    date: { month: "OCT", day: "22" },
    title: "Khmer AI & Data Night",
    type: "Virtual",
    location: "Zoom / Facebook Live",
    time: "7:00 PM – 9:00 PM",
    desc: "Exploring how Artificial Intelligence is being used in the Khmer language and local industries.",
    color: "#00c9a7",
    spots: "Open registration",
  },
  {
    date: { month: "NOV", day: "12" },
    title: "Battambang Youth Hackathon",
    type: "Competition",
    location: "University of Battambang",
    time: "2 Days Event",
    desc: "Build solutions for local challenges. Teams will compete for prizes and mentorship.",
    color: "#ffd23f",
    spots: "Team only",
  },
];

export function Events() {
  const [modalOpen, setModalOpen] = useState(false);

  return (
    <section id="events" style={{ background: "#0d0d2b", padding: "100px 0" }}>
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex flex-col lg:flex-row lg:items-end lg:justify-between mb-12 gap-6">
          <div>
            <p className="font-semibold text-sm tracking-widest mb-4 uppercase" style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}>Upcoming</p>
            <h2 style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", fontSize: "clamp(2rem, 4vw, 3rem)", fontWeight: 800, color: "#fff", lineHeight: 1.1 }}>Events in Cambodia</h2>
          </div>
          <button
            onClick={() => setModalOpen(true)}
            className="flex items-center gap-2 px-8 py-4 rounded-full font-bold text-sm border-2 transition-all hover:bg-white/5 active:scale-95"
            style={{ fontFamily: "'Outfit', sans-serif", borderColor: "rgba(255,255,255,0.2)", color: "#fff" }}
          >
            <Calendar className="w-4 h-4" />
            View Full Calendar
          </button>
        </div>

        <div className="flex flex-col gap-5">
          {events.map((ev, i) => (
            <div key={ev.title} className="grid md:grid-cols-[auto_1fr_auto] gap-6 items-center p-8 rounded-3xl transition-all cursor-pointer border border-white/5 hover:border-white/20 hover:bg-white/[0.02]" style={{ background: "rgba(255,255,255,0.02)" }}>
              <div className="w-20 h-20 rounded-2xl flex flex-col items-center justify-center shrink-0 shadow-lg" style={{ background: ev.color }}>
                <span className="text-xs text-white/80 font-bold">{ev.date.month}</span>
                <span className="text-3xl font-black text-white leading-none">{ev.date.day}</span>
              </div>
              <div>
                <div className="flex flex-wrap gap-3 items-center mb-2">
                  <h3 className="font-bold text-xl text-white">{ev.title}</h3>
                  <span className="px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase" style={{ background: "rgba(255,255,255,0.05)", color: ev.color, border: `1px solid ${ev.color}44` }}>{ev.type}</span>
                </div>
                <div className="flex flex-wrap gap-6 text-sm mb-3 opacity-60 text-white">
                  <span className="flex items-center gap-2"><MapPin className="w-4 h-4" />{ev.location}</span>
                  <span className="flex items-center gap-2"><Clock className="w-4 h-4" />{ev.time}</span>
                </div>
                <p className="text-sm opacity-50 text-white leading-relaxed max-w-2xl">{ev.desc}</p>
              </div>
              <div className="flex flex-col items-end gap-3 shrink-0">
                <span className="text-xs font-bold" style={{ color: ev.color }}>{ev.spots}</span>
                <button className="flex items-center gap-2 px-6 py-3 rounded-full text-sm font-bold transition-all hover:opacity-90" style={{ background: ev.color, color: "#fff" }}>Secure Seat</button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-6 bg-black/80 backdrop-blur-sm" onClick={() => setModalOpen(false)}>
          <div className="w-full max-w-2xl bg-[#111130] rounded-[32px] border border-white/10 overflow-hidden shadow-2xl" onClick={e => e.stopPropagation()}>
            <div className="p-8 border-b border-white/5 flex justify-between items-center">
              <div>
                <p className="text-[#ff6b35] text-xs font-bold tracking-widest uppercase mb-1">Schedule</p>
                <h3 className="text-2xl font-bold text-white">Full Event Calendar</h3>
              </div>
              <button onClick={() => setModalOpen(false)} className="p-2 rounded-full hover:bg-white/5 text-white/40"><X /></button>
            </div>
            <div className="p-8 max-h-[60vh] overflow-y-auto">
              <div className="space-y-4">
                {events.map((ev) => (
                  <div key={ev.title} className="flex items-center gap-4 p-4 rounded-2xl bg-white/5 border border-white/5">
                    <div className="text-center w-12 shrink-0">
                      <p className="text-[10px] font-bold text-white/40 leading-none">{ev.date.month}</p>
                      <p className="text-xl font-bold text-white">{ev.date.day}</p>
                    </div>
                    <div className="h-8 w-px bg-white/10" />
                    <div>
                      <p className="font-bold text-white">{ev.title}</p>
                      <p className="text-xs text-white/40">{ev.location}</p>
                    </div>
                  </div>
                ))}
                <div className="p-8 text-center opacity-30 text-white italic text-sm">More events being added soon...</div>
              </div>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
