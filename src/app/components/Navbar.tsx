import { useState, useEffect } from "react";
import { Menu, X, Code2, LogOut, ChevronDown, User } from "lucide-react";
import { useAuth } from "../context/AuthContext";
import { AuthModal } from "./AuthModal";

const links = [
  { label: "About", href: "#about" },
  { label: "Programs", href: "#programs" },
  { label: "Impact", href: "#impact" },
  { label: "Team", href: "#team" },
  { label: "Events", href: "#events" },
  { label: "Contact", href: "#contact" },
];

export function Navbar() {
  const { user, signOut } = useAuth();
  const [open, setOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const [authModal, setAuthModal] = useState<{ open: boolean; tab: "signin" | "signup" }>({
    open: false,
    tab: "signin",
  });
  const [dropdownOpen, setDropdownOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 40);
    window.addEventListener("scroll", onScroll);
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    const close = () => setDropdownOpen(false);
    if (dropdownOpen) window.addEventListener("click", close);
    return () => window.removeEventListener("click", close);
  }, [dropdownOpen]);

  const scrollTo = (href: string) => {
    setOpen(false);
    const el = document.querySelector(href);
    if (el) el.scrollIntoView({ behavior: "smooth" });
  };

  const openAuth = (tab: "signin" | "signup") => {
    setOpen(false);
    setAuthModal({ open: true, tab });
  };

  const roleLabel: Record<string, string> = {
    student: "Student",
    parent: "Parent",
    volunteer: "Volunteer",
    donor: "Donor",
  };

  return (
    <>
      <header
        className="fixed top-0 left-0 right-0 z-50 transition-all duration-300"
        style={{
          background: scrolled ? "#0d0d2b" : "transparent",
          borderBottom: scrolled ? "1px solid rgba(255,255,255,0.08)" : "none",
        }}
      >
        <div className="max-w-7xl mx-auto px-6 flex items-center justify-between h-16">
          {/* Logo */}
          <button
            onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}
            className="flex items-center gap-2 group"
          >
            <div
              className="w-8 h-8 rounded-lg flex items-center justify-center"
              style={{ background: "#ff6b35" }}
            >
              <Code2 className="w-4 h-4 text-white" />
            </div>
            <span
              className="text-white font-bold tracking-tight"
              style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", fontSize: "1.05rem" }}
            >
              Code<span style={{ color: "#ff6b35" }}>4</span>Youth
            </span>
          </button>

          {/* Desktop nav */}
          <nav className="hidden md:flex items-center gap-8">
            {links.map((l) => (
              <button
                key={l.href}
                onClick={() => scrollTo(l.href)}
                className="text-white/70 hover:text-white transition-colors text-sm font-medium"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                {l.label}
              </button>
            ))}
          </nav>

          {/* Desktop auth */}
          <div className="hidden md:flex items-center gap-3">
            {user ? (
              <div className="relative">
                <button
                  onClick={(e) => { e.stopPropagation(); setDropdownOpen(!dropdownOpen); }}
                  className="flex items-center gap-2 px-4 py-2 rounded-full transition-colors"
                  style={{
                    background: "rgba(255,255,255,0.08)",
                    border: "1px solid rgba(255,255,255,0.15)",
                  }}
                >
                  <div
                    className="w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold"
                    style={{ background: "#ff6b35", color: "#fff", fontFamily: "'Plus Jakarta Sans', sans-serif" }}
                  >
                    {user.name.charAt(0).toUpperCase()}
                  </div>
                  <span
                    className="text-white text-sm font-medium max-w-[120px] truncate"
                    style={{ fontFamily: "'Outfit', sans-serif" }}
                  >
                    {user.name.split(" ")[0]}
                  </span>
                  <ChevronDown className="w-3.5 h-3.5 text-white/60" />
                </button>

                {dropdownOpen && (
                  <div
                    className="absolute right-0 top-full mt-2 w-56 rounded-2xl overflow-hidden shadow-xl z-50"
                    style={{ background: "#fff", border: "1px solid rgba(13,13,43,0.08)" }}
                    onClick={(e) => e.stopPropagation()}
                  >
                    <div className="px-4 py-3" style={{ borderBottom: "1px solid rgba(13,13,43,0.06)" }}>
                      <p className="font-bold text-sm" style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", color: "#0d0d2b" }}>
                        {user.name}
                      </p>
                      <p className="text-xs text-gray-400 truncate" style={{ fontFamily: "'Outfit', sans-serif" }}>
                        {user.email}
                      </p>
                      <span
                        className="inline-block mt-1.5 px-2 py-0.5 rounded-full text-xs font-semibold"
                        style={{ background: "#fff3ee", color: "#ff6b35", fontFamily: "'Outfit', sans-serif" }}
                      >
                        {roleLabel[user.role]}
                      </span>
                    </div>
                    <div className="px-2 py-2">
                      <button
                        onClick={() => { signOut(); setDropdownOpen(false); }}
                        className="w-full flex items-center gap-2 px-3 py-2 rounded-xl text-sm transition-colors hover:bg-gray-50"
                        style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                      >
                        <LogOut className="w-4 h-4" />
                        Sign Out
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <>
                <button
                  onClick={() => openAuth("signin")}
                  className="text-sm font-semibold px-5 py-2 rounded-full text-white border border-white/20 hover:border-white/50 transition-colors"
                  style={{ fontFamily: "'Outfit', sans-serif" }}
                >
                  Sign In
                </button>
                <button
                  onClick={() => openAuth("signup")}
                  className="text-sm font-semibold px-5 py-2 rounded-full transition-all hover:scale-105"
                  style={{ background: "#ff6b35", color: "#fff", fontFamily: "'Outfit', sans-serif" }}
                >
                  Sign Up Free
                </button>
              </>
            )}
          </div>

          {/* Mobile toggle */}
          <button className="md:hidden text-white" onClick={() => setOpen(!open)}>
            {open ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
          </button>
        </div>

        {/* Mobile menu */}
        {open && (
          <div
            className="md:hidden px-6 pb-6 pt-2 flex flex-col gap-4"
            style={{ background: "#0d0d2b" }}
          >
            {links.map((l) => (
              <button
                key={l.href}
                onClick={() => scrollTo(l.href)}
                className="text-white/80 hover:text-white text-left text-base font-medium"
                style={{ fontFamily: "'Outfit', sans-serif" }}
              >
                {l.label}
              </button>
            ))}
            {user ? (
              <div
                className="flex items-center justify-between pt-3"
                style={{ borderTop: "1px solid rgba(255,255,255,0.08)" }}
              >
                <div className="flex items-center gap-2">
                  <div
                    className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold"
                    style={{ background: "#ff6b35", color: "#fff", fontFamily: "'Plus Jakarta Sans', sans-serif" }}
                  >
                    {user.name.charAt(0).toUpperCase()}
                  </div>
                  <div>
                    <p className="text-white text-sm font-medium" style={{ fontFamily: "'Outfit', sans-serif" }}>{user.name}</p>
                    <p className="text-white/40 text-xs" style={{ fontFamily: "'Outfit', sans-serif" }}>{roleLabel[user.role]}</p>
                  </div>
                </div>
                <button
                  onClick={() => { signOut(); setOpen(false); }}
                  className="flex items-center gap-1.5 text-sm text-white/50"
                  style={{ fontFamily: "'Outfit', sans-serif" }}
                >
                  <LogOut className="w-4 h-4" />
                  Sign Out
                </button>
              </div>
            ) : (
              <div className="flex flex-col gap-3 pt-3" style={{ borderTop: "1px solid rgba(255,255,255,0.08)" }}>
                <button
                  onClick={() => openAuth("signin")}
                  className="text-sm font-semibold py-2.5 rounded-full text-white border border-white/20 w-full"
                  style={{ fontFamily: "'Outfit', sans-serif" }}
                >
                  Sign In
                </button>
                <button
                  onClick={() => openAuth("signup")}
                  className="text-sm font-semibold py-2.5 rounded-full text-white w-full"
                  style={{ background: "#ff6b35", fontFamily: "'Outfit', sans-serif" }}
                >
                  Sign Up Free
                </button>
              </div>
            )}
          </div>
        )}
      </header>

      <AuthModal
        open={authModal.open}
        defaultTab={authModal.tab}
        onClose={() => setAuthModal((s) => ({ ...s, open: false }))}
      />
    </>
  );
}
