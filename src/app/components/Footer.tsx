import { Code2, Github, Instagram, Linkedin, Twitter, Youtube } from "lucide-react";

const links = {
  Programs: ["CodeStarter", "WebBuilders", "AI Lab", "Alumni Network", "Scholarships"],
  Organization: ["About Us", "Our Team", "Impact Report", "Partners", "Press Kit"],
  "Get Involved": ["Enroll a Student", "Volunteer", "Donate", "Corporate Sponsorship", "Refer a Family"],
  Resources: ["Student Portal", "Parent FAQ", "Curriculum Overview", "Blog", "Events Calendar"],
};

export function Footer() {
  return (
    <footer style={{ background: "#07071a", padding: "80px 0 40px" }}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Top */}
        <div className="grid md:grid-cols-2 lg:grid-cols-5 gap-12 mb-16">
          {/* Brand col */}
          <div className="lg:col-span-1">
            <div className="flex items-center gap-2 mb-4">
              <div
                className="w-8 h-8 rounded-lg flex items-center justify-center"
                style={{ background: "#ff6b35" }}
              >
                <Code2 className="w-4 h-4 text-white" />
              </div>
              <span
                className="text-white font-bold"
                style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}
              >
                Code<span style={{ color: "#ff6b35" }}>4</span>Youth
              </span>
            </div>
            <p
              className="text-sm leading-relaxed mb-6"
              style={{ fontFamily: "'Outfit', sans-serif", color: "rgba(255,255,255,0.4)" }}
            >
              Free, world-class coding education for young people aged 10–18.
            </p>
            <div className="flex gap-3">
              {[Twitter, Instagram, Linkedin, Github, Youtube].map((Icon, i) => (
                <button
                  key={i}
                  className="w-8 h-8 rounded-full flex items-center justify-center transition-all hover:scale-110"
                  style={{ background: "rgba(255,255,255,0.06)" }}
                >
                  <Icon className="w-3.5 h-3.5 text-white/50" />
                </button>
              ))}
            </div>
          </div>

          {/* Link cols */}
          {Object.entries(links).map(([cat, items]) => (
            <div key={cat}>
              <p
                className="text-white font-semibold text-xs uppercase tracking-widest mb-5"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                {cat}
              </p>
              <ul className="flex flex-col gap-3">
                {items.map((item) => (
                  <li key={item}>
                    <a
                      href="#"
                      className="text-sm transition-colors hover:text-white"
                      style={{
                        fontFamily: "'Outfit', sans-serif",
                        color: "rgba(255,255,255,0.4)",
                        textDecoration: "none",
                      }}
                    >
                      {item}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        {/* Divider */}
        <div style={{ borderTop: "1px solid rgba(255,255,255,0.06)", paddingTop: 32 }}>
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <p
              className="text-xs"
              style={{
                fontFamily: "'Outfit', sans-serif",
                color: "rgba(255,255,255,0.25)",
              }}
            >
              © 2025 Code for Youth. A registered 501(c)(3) nonprofit. EIN: 47-3928104
            </p>
            <div className="flex gap-6">
              {["Privacy Policy", "Terms of Use", "Accessibility"].map((item) => (
                <a
                  key={item}
                  href="#"
                  className="text-xs transition-colors hover:text-white/60"
                  style={{
                    fontFamily: "'Outfit', sans-serif",
                    color: "rgba(255,255,255,0.25)",
                    textDecoration: "none",
                  }}
                >
                  {item}
                </a>
              ))}
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
