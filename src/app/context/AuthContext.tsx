import { createContext, useContext, useState, useEffect, ReactNode } from "react";

export interface User {
  id: string;
  name: string;
  email: string;
  role: "student" | "parent" | "volunteer" | "donor";
  createdAt: string;
}

interface AuthContextType {
  user: User | null;
  signUp: (name: string, email: string, password: string, role: User["role"]) => Promise<void>;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => void;
  loading: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

const USERS_KEY = "c4y_users";
const SESSION_KEY = "c4y_session";

function getStoredUsers(): Record<string, { user: User; passwordHash: string }> {
  try {
    return JSON.parse(localStorage.getItem(USERS_KEY) || "{}");
  } catch {
    return {};
  }
}

function simpleHash(str: string): string {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = (hash << 5) - hash + str.charCodeAt(i);
    hash |= 0;
  }
  return hash.toString(36);
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const session = localStorage.getItem(SESSION_KEY);
    if (session) {
      try {
        setUser(JSON.parse(session));
      } catch {
        localStorage.removeItem(SESSION_KEY);
      }
    }
    setLoading(false);
  }, []);

  const signUp = async (name: string, email: string, password: string, role: User["role"]) => {
    await new Promise((r) => setTimeout(r, 600));
    const users = getStoredUsers();
    const key = email.toLowerCase();
    if (users[key]) throw new Error("An account with this email already exists.");
    const newUser: User = {
      id: Math.random().toString(36).slice(2),
      name,
      email: email.toLowerCase(),
      role,
      createdAt: new Date().toISOString(),
    };
    users[key] = { user: newUser, passwordHash: simpleHash(password) };
    localStorage.setItem(USERS_KEY, JSON.stringify(users));
    localStorage.setItem(SESSION_KEY, JSON.stringify(newUser));
    setUser(newUser);
  };

  const signIn = async (email: string, password: string) => {
    await new Promise((r) => setTimeout(r, 600));
    const users = getStoredUsers();
    const record = users[email.toLowerCase()];
    if (!record) throw new Error("No account found with that email.");
    if (record.passwordHash !== simpleHash(password)) throw new Error("Incorrect password.");
    localStorage.setItem(SESSION_KEY, JSON.stringify(record.user));
    setUser(record.user);
  };

  const signOut = () => {
    localStorage.removeItem(SESSION_KEY);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, signUp, signIn, signOut, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used inside AuthProvider");
  return ctx;
}
