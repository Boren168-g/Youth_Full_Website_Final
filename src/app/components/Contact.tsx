import { useState } from "react";
import { Send, Mail, MapPin, Phone, Check } from "lucide-react";

export function Contact() {
  const [form, setForm] = useState({ name: "", email: "", subject: "enroll", message: "" });
  const [sent, setSent] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSent(true);
  };

  return (
    <section id="contact" style={{ background: "#f8f7f4", padding: "100px 0" }}>
      <div className="max-w-7xl mx-auto px-6">
        <div className="grid lg:grid-cols-2 gap-16">
          {/* Left */}
          <div>
            <p
              className="font-semibold text-sm tracking-widest mb-4 uppercase"
              style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}
            >
              Reach Out
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
              Let's Talk
            </h2>
            <p
              className="mb-10 leading-relaxed"
              style={{
                fontFamily: "'Outfit', sans-serif",
                fontSize: "1.05rem",
                color: "#4a4a6a",
              }}
            >
              Questions about programs, volunteering, partnerships, or anything else — we reply within 48 hours.
            </p>

            <div className="flex flex-col gap-6">
              {[
                { icon: Mail, label: "hello@codeforyouth.org" },
                { icon: Phone, label: "+1 (312) 555-0194" },
                { icon: MapPin, label: "221 N. LaSalle St, Suite 1100, Chicago, IL 60601" },
              ].map((item) => (
                <div key={item.label} className="flex items-start gap-4">
                  <div
                    className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0"
                    style={{ background: "#fff3ee" }}
                  >
                    <item.icon className="w-4 h-4" style={{ color: "#ff6b35" }} />
                  </div>
                  <p
                    className="pt-2 text-sm leading-relaxed"
                    style={{ fontFamily: "'Outfit', sans-serif", color: "#4a4a6a" }}
                  >
                    {item.label}
                  </p>
                </div>
              ))}
            </div>

            {/* Supporters */}
            <div className="mt-14">
              <p
                className="text-xs text-gray-400 uppercase tracking-widest mb-5"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                Supported By
              </p>
              <div className="flex flex-wrap gap-4">
                {["Google.org", "Melinda Gates Foundation", "Mozilla", "Microsoft TEALS"].map((s) => (
                  <span
                    key={s}
                    className="px-4 py-2 rounded-full text-sm font-semibold"
                    style={{
                      background: "#fff",
                      color: "#4a4a6a",
                      fontFamily: "'Outfit', sans-serif",
                      border: "1px solid rgba(13,13,43,0.08)",
                    }}
                  >
                    {s}
                  </span>
                ))}
              </div>
            </div>
          </div>

          {/* Right — form */}
          <div
            className="rounded-3xl p-8 lg:p-10"
            style={{
              background: "#fff",
              border: "1px solid rgba(13,13,43,0.06)",
              boxShadow: "0 4px 24px rgba(13,13,43,0.06)",
            }}
          >
            {sent ? (
              <div className="flex flex-col items-center justify-center h-full text-center py-12">
                <div
                  className="w-16 h-16 rounded-full flex items-center justify-center mb-6"
                  style={{ background: "#e6faf7" }}
                >
                  <Check className="w-8 h-8" style={{ color: "#00c9a7" }} />
                </div>
                <h3
                  className="font-bold text-xl mb-2"
                  style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", color: "#0d0d2b" }}
                >
                  Message Sent!
                </h3>
                <p
                  className="text-sm"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                >
                  We'll get back to you within 48 hours.
                </p>
                <button
                  className="mt-6 text-sm underline"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#ff6b35" }}
                  onClick={() => setSent(false)}
                >
                  Send another
                </button>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="flex flex-col gap-5">
                <div className="grid sm:grid-cols-2 gap-5">
                  <div>
                    <label
                      className="block text-xs font-semibold mb-2 uppercase tracking-wider"
                      style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                    >
                      Name
                    </label>
                    <input
                      required
                      value={form.name}
                      onChange={(e) => setForm({ ...form, name: e.target.value })}
                      placeholder="Your full name"
                      className="w-full px-4 py-3 rounded-xl text-sm outline-none transition-all"
                      style={{
                        background: "#f8f7f4",
                        border: "1.5px solid rgba(13,13,43,0.1)",
                        fontFamily: "'Outfit', sans-serif",
                        color: "#0d0d2b",
                      }}
                    />
                  </div>
                  <div>
                    <label
                      className="block text-xs font-semibold mb-2 uppercase tracking-wider"
                      style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                    >
                      Email
                    </label>
                    <input
                      required
                      type="email"
                      value={form.email}
                      onChange={(e) => setForm({ ...form, email: e.target.value })}
                      placeholder="you@example.com"
                      className="w-full px-4 py-3 rounded-xl text-sm outline-none transition-all"
                      style={{
                        background: "#f8f7f4",
                        border: "1.5px solid rgba(13,13,43,0.1)",
                        fontFamily: "'Outfit', sans-serif",
                        color: "#0d0d2b",
                      }}
                    />
                  </div>
                </div>

                <div>
                  <label
                    className="block text-xs font-semibold mb-2 uppercase tracking-wider"
                    style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                  >
                    I'm reaching out about…
                  </label>
                  <select
                    value={form.subject}
                    onChange={(e) => setForm({ ...form, subject: e.target.value })}
                    className="w-full px-4 py-3 rounded-xl text-sm outline-none transition-all"
                    style={{
                      background: "#f8f7f4",
                      border: "1.5px solid rgba(13,13,43,0.1)",
                      fontFamily: "'Outfit', sans-serif",
                      color: "#0d0d2b",
                    }}
                  >
                    <option value="enroll">Enrolling my child</option>
                    <option value="volunteer">Volunteering</option>
                    <option value="donate">Donating</option>
                    <option value="partner">Corporate partnership</option>
                    <option value="press">Press / media</option>
                    <option value="other">Something else</option>
                  </select>
                </div>

                <div>
                  <label
                    className="block text-xs font-semibold mb-2 uppercase tracking-wider"
                    style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                  >
                    Message
                  </label>
                  <textarea
                    required
                    rows={5}
                    value={form.message}
                    onChange={(e) => setForm({ ...form, message: e.target.value })}
                    placeholder="Tell us more about what you have in mind…"
                    className="w-full px-4 py-3 rounded-xl text-sm outline-none transition-all resize-none"
                    style={{
                      background: "#f8f7f4",
                      border: "1.5px solid rgba(13,13,43,0.1)",
                      fontFamily: "'Outfit', sans-serif",
                      color: "#0d0d2b",
                    }}
                  />
                </div>

                <button
                  type="submit"
                  className="flex items-center justify-center gap-2 py-3.5 rounded-xl font-semibold transition-all hover:scale-105 active:scale-95"
                  style={{
                    background: "#ff6b35",
                    color: "#fff",
                    fontFamily: "'Outfit', sans-serif",
                  }}
                >
                  Send Message
                  <Send className="w-4 h-4" />
                </button>
              </form>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
