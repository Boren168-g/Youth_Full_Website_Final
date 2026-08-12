import { Linkedin, Twitter } from "lucide-react";

const team = [
  {
    name: "Dr. Keisha Monroe",
    role: "Executive Director",
    bio: "Former Google engineer and education policy advocate. 15 years building equitable tech pathways.",
    initials: "KM",
    color: "#ff6b35",
    img: "https://images.unsplash.com/photo-1596496356933-9b6e0b186b88?w=400&h=400&fit=crop&auto=format&faces=1",
  },
  {
    name: "Marcus Chen",
    role: "Director of Curriculum",
    bio: "Ex-Meta engineer. Designed learning experiences for 10,000+ developers worldwide before joining C4Y.",
    initials: "MC",
    color: "#1e3fce",
    img: "https://images.unsplash.com/photo-1571391756721-0e5caf1d8f80?w=400&h=400&fit=crop&auto=format",
  },
  {
    name: "Zara Ahmed",
    role: "Head of Community",
    bio: "Youth organizer turned nonprofit leader. Built C4Y's alumni network to over 2,000 members.",
    initials: "ZA",
    color: "#00c9a7",
    img: "https://images.unsplash.com/photo-1705579610984-910ad33fe2db?w=400&h=400&fit=crop&auto=format",
  },
  {
    name: "Leo Okonkwo",
    role: "Lead Instructor, AI Lab",
    bio: "PhD candidate in Machine Learning at MIT. Was a C4Y student himself — and now gives back full-time.",
    initials: "LO",
    color: "#ffd23f",
    img: "https://images.unsplash.com/photo-1705579610258-215a3e0025aa?w=400&h=400&fit=crop&auto=format",
  },
];

export function Team() {
  return (
    <section id="team" style={{ background: "#f8f7f4", padding: "100px 0" }}>
      <div className="max-w-7xl mx-auto px-6">
        <div className="mb-12">
          <p
            className="font-semibold text-sm tracking-widest mb-4 uppercase"
            style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}
          >
            Who We Are
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
            Meet the Team
          </h2>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {team.map((member) => (
            <div
              key={member.name}
              className="group rounded-2xl overflow-hidden transition-all hover:-translate-y-1"
              style={{
                background: "#fff",
                border: "1px solid rgba(13,13,43,0.06)",
                boxShadow: "0 2px 8px rgba(13,13,43,0.04)",
              }}
            >
              {/* Photo */}
              <div className="relative overflow-hidden" style={{ height: 220, background: "#eeede8" }}>
                <img
                  src={member.img}
                  alt={member.name}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                />
                <div
                  className="absolute bottom-0 left-0 right-0 h-1"
                  style={{ background: member.color }}
                />
              </div>

              {/* Info */}
              <div className="p-5">
                <p
                  className="font-bold mb-0.5"
                  style={{
                    fontFamily: "'Plus Jakarta Sans', sans-serif",
                    color: "#0d0d2b",
                  }}
                >
                  {member.name}
                </p>
                <p
                  className="text-xs font-semibold mb-3"
                  style={{
                    fontFamily: "'Outfit', sans-serif",
                    color: member.color,
                  }}
                >
                  {member.role}
                </p>
                <p
                  className="text-sm leading-relaxed"
                  style={{
                    fontFamily: "'Outfit', sans-serif",
                    color: "#6b6b80",
                  }}
                >
                  {member.bio}
                </p>

                <div className="flex gap-2 mt-4">
                  <button
                    className="w-7 h-7 rounded-full flex items-center justify-center transition-colors hover:opacity-80"
                    style={{ background: "#eeede8" }}
                  >
                    <Linkedin className="w-3.5 h-3.5" style={{ color: "#0d0d2b" }} />
                  </button>
                  <button
                    className="w-7 h-7 rounded-full flex items-center justify-center transition-colors hover:opacity-80"
                    style={{ background: "#eeede8" }}
                  >
                    <Twitter className="w-3.5 h-3.5" style={{ color: "#0d0d2b" }} />
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
