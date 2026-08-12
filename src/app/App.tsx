import "../styles/fonts.css";
import { AuthProvider } from "./context/AuthContext";
import { Navbar } from "./components/Navbar";
import { Hero } from "./components/Hero";
import { Stats } from "./components/Stats";
import { About } from "./components/About";
import { Programs } from "./components/Programs";
import { Testimonials } from "./components/Testimonials";
import { Team } from "./components/Team";
import { Events } from "./components/Events";
import { GetInvolved } from "./components/GetInvolved";
import { Contact } from "./components/Contact";
import { Footer } from "./components/Footer";

export default function App() {
  return (
    <AuthProvider>
      <div className="min-h-screen" style={{ fontFamily: "'Outfit', sans-serif" }}>
        <Navbar />
        <main>
          <Hero />
          <Stats />
          <About />
          <Programs />
          <Testimonials />
          <Team />
          <Events />
          <GetInvolved />
          <Contact />
        </main>
        <Footer />
      </div>
    </AuthProvider>
  );
}
