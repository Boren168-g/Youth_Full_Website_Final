import { useState } from "react";
import { X, Eye, EyeOff, Code2, Loader2, AlertCircle, CheckCircle2 } from "lucide-react";
import { useAuth, User } from "../context/AuthContext";

interface Props {
  open: boolean;
  defaultTab?: "signin" | "signup";
  onClose: () => void;
}

const roles: { value: User["role"]; label: string; emoji: string }[] = [
  { value: "student", label: "Student (Age 10–18)", emoji: "🎓" },
  { value: "parent", label: "Parent / Guardian", emoji: "👨‍👩‍👧" },
  { value: "volunteer", label: "Volunteer / Instructor", emoji: "💻" },
  { value: "donor", label: "Donor / Supporter", emoji: "❤️" },
];

export function AuthModal({ open, defaultTab = "signin", onClose }: Props) {
  const { signIn, signUp } = useAuth();
  const [tab, setTab] = useState<"signin" | "signup">(defaultTab);
  const [showPw, setShowPw] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  const [form, setForm] = useState({
    name: "",
    email: "",
    password: "",
    confirmPassword: "",
    role: "student" as User["role"],
  });

  if (!open) return null;

  const set = (k: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
    setForm((f) => ({ ...f, [k]: e.target.value }));

  const switchTab = (t: "signin" | "signup") => {
    setTab(t);
    setError("");
    setSuccess("");
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setSuccess("");

    if (tab === "signup") {
      if (!form.name.trim()) return setError("Please enter your name.");
      if (form.password.length < 6) return setError("Password must be at least 6 characters.");
      if (form.password !== form.confirmPassword) return setError("Passwords don't match.");
    }

    setLoading(true);
    try {
      if (tab === "signin") {
        await signIn(form.email, form.password);
        setSuccess("Welcome back! Signing you in…");
        setTimeout(onClose, 800);
      } else {
        await signUp(form.name, form.email, form.password, form.role);
        setSuccess("Account created! Welcome to Code for Youth 🎉");
        setTimeout(onClose, 1000);
      }
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Something went wrong. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  const inputClass = "w-full px-4 py-3 rounded-xl text-sm outline-none transition-all focus:ring-2";
  const inputStyle = {
    background: "#f8f7f4",
    border: "1.5px solid rgba(13,13,43,0.1)",
    fontFamily: "'Outfit', sans-serif",
    color: "#0d0d2b",
  };

  return (
    <div
      className="fixed inset-0 z-[100] flex items-center justify-center p-4"
      style={{ background: "rgba(13,13,43,0.7)", backdropFilter: "blur(6px)" }}
      onClick={onClose}
    >
      <div
        className="w-full max-w-md rounded-3xl overflow-hidden relative"
        style={{
          background: "#fff",
          boxShadow: "0 40px 80px rgba(13,13,43,0.3)",
        }}
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header bar */}
        <div
          className="px-8 pt-8 pb-6"
          style={{ borderBottom: "1px solid rgba(13,13,43,0.06)" }}
        >
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-2">
              <div
                className="w-7 h-7 rounded-lg flex items-center justify-center"
                style={{ background: "#ff6b35" }}
              >
                <Code2 className="w-3.5 h-3.5 text-white" />
              </div>
              <span
                className="font-bold text-sm"
                style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", color: "#0d0d2b" }}
              >
                Code<span style={{ color: "#ff6b35" }}>4</span>Youth
              </span>
            </div>
            <button
              onClick={onClose}
              className="w-8 h-8 rounded-full flex items-center justify-center transition-colors hover:bg-gray-100"
            >
              <X className="w-4 h-4 text-gray-400" />
            </button>
          </div>

          {/* Tabs */}
          <div
            className="flex p-1 rounded-xl"
            style={{ background: "#f8f7f4" }}
          >
            {(["signin", "signup"] as const).map((t) => (
              <button
                key={t}
                onClick={() => switchTab(t)}
                className="flex-1 py-2 rounded-lg text-sm font-semibold transition-all"
                style={{
                  fontFamily: "'Outfit', sans-serif",
                  background: tab === t ? "#fff" : "transparent",
                  color: tab === t ? "#0d0d2b" : "#6b6b80",
                  boxShadow: tab === t ? "0 1px 4px rgba(13,13,43,0.08)" : "none",
                }}
              >
                {t === "signin" ? "Sign In" : "Create Account"}
              </button>
            ))}
          </div>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="px-8 py-6 flex flex-col gap-4">
          {tab === "signup" && (
            <div>
              <label
                className="block text-xs font-semibold mb-1.5 uppercase tracking-wider"
                style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
              >
                Full Name
              </label>
              <input
                required
                value={form.name}
                onChange={set("name")}
                placeholder="Maya Johnson"
                className={inputClass}
                style={inputStyle}
              />
            </div>
          )}

          <div>
            <label
              className="block text-xs font-semibold mb-1.5 uppercase tracking-wider"
              style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
            >
              Email Address
            </label>
            <input
              required
              type="email"
              value={form.email}
              onChange={set("email")}
              placeholder="you@example.com"
              className={inputClass}
              style={inputStyle}
            />
          </div>

          <div>
            <label
              className="block text-xs font-semibold mb-1.5 uppercase tracking-wider"
              style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
            >
              Password
            </label>
            <div className="relative">
              <input
                required
                type={showPw ? "text" : "password"}
                value={form.password}
                onChange={set("password")}
                placeholder={tab === "signup" ? "At least 6 characters" : "Your password"}
                className={inputClass}
                style={{ ...inputStyle, paddingRight: "3rem" }}
              />
              <button
                type="button"
                onClick={() => setShowPw(!showPw)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                {showPw ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>
          </div>

          {tab === "signup" && (
            <>
              <div>
                <label
                  className="block text-xs font-semibold mb-1.5 uppercase tracking-wider"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                >
                  Confirm Password
                </label>
                <input
                  required
                  type={showPw ? "text" : "password"}
                  value={form.confirmPassword}
                  onChange={set("confirmPassword")}
                  placeholder="Repeat password"
                  className={inputClass}
                  style={inputStyle}
                />
              </div>

              <div>
                <label
                  className="block text-xs font-semibold mb-2 uppercase tracking-wider"
                  style={{ fontFamily: "'Outfit', sans-serif", color: "#6b6b80" }}
                >
                  I am a…
                </label>
                <div className="grid grid-cols-2 gap-2">
                  {roles.map((r) => (
                    <button
                      key={r.value}
                      type="button"
                      onClick={() => setForm((f) => ({ ...f, role: r.value }))}
                      className="px-3 py-2.5 rounded-xl text-xs font-semibold text-left transition-all"
                      style={{
                        fontFamily: "'Outfit', sans-serif",
                        background: form.role === r.value ? "#fff3ee" : "#f8f7f4",
                        color: form.role === r.value ? "#ff6b35" : "#6b6b80",
                        border: `1.5px solid ${form.role === r.value ? "#ff6b35" : "transparent"}`,
                      }}
                    >
                      {r.emoji} {r.label}
                    </button>
                  ))}
                </div>
              </div>
            </>
          )}

          {/* Error / Success */}
          {error && (
            <div
              className="flex items-center gap-2 px-4 py-3 rounded-xl text-sm"
              style={{
                background: "#fff0f0",
                color: "#c0152a",
                fontFamily: "'Outfit', sans-serif",
              }}
            >
              <AlertCircle className="w-4 h-4 shrink-0" />
              {error}
            </div>
          )}
          {success && (
            <div
              className="flex items-center gap-2 px-4 py-3 rounded-xl text-sm"
              style={{
                background: "#e6faf7",
                color: "#00875a",
                fontFamily: "'Outfit', sans-serif",
              }}
            >
              <CheckCircle2 className="w-4 h-4 shrink-0" />
              {success}
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="flex items-center justify-center gap-2 py-3.5 rounded-xl font-semibold text-sm transition-all hover:scale-105 active:scale-95 disabled:opacity-70 disabled:scale-100"
            style={{
              background: "#ff6b35",
              color: "#fff",
              fontFamily: "'Outfit', sans-serif",
              marginTop: 4,
            }}
          >
            {loading ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                {tab === "signin" ? "Signing in…" : "Creating account…"}
              </>
            ) : tab === "signin" ? (
              "Sign In"
            ) : (
              "Create Account — It's Free"
            )}
          </button>

          <p
            className="text-center text-xs pb-2"
            style={{ fontFamily: "'Outfit', sans-serif", color: "#9b9bae" }}
          >
            {tab === "signin" ? (
              <>
                Don't have an account?{" "}
                <button
                  type="button"
                  onClick={() => switchTab("signup")}
                  className="font-semibold hover:underline"
                  style={{ color: "#ff6b35" }}
                >
                  Sign up free
                </button>
              </>
            ) : (
              <>
                Already have an account?{" "}
                <button
                  type="button"
                  onClick={() => switchTab("signin")}
                  className="font-semibold hover:underline"
                  style={{ color: "#ff6b35" }}
                >
                  Sign in
                </button>
              </>
            )}
          </p>
        </form>
      </div>
    </div>
  );
}
