const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();

app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'] }));
app.use(express.json());

// 1. Welcome Page (Defined at the TOP so it always works)
app.get('/', (req, res) => {
  res.send(`
    <div style="font-family: sans-serif; text-align: center; padding-top: 100px; background-color: #0d0d2b; color: white; min-height: 100vh;">
      <h1 style="color: #ff6b35; font-size: 48px;">Code4Youth API is Live! 🚀</h1>
      <p style="font-size: 18px; color: #a8b3cf;">The cloud backend is connected and running perfectly.</p>
      <div style="margin-top: 30px; padding: 20px; background: rgba(255,255,255,0.05); display: inline-block; border-radius: 12px;">
        <p>System Health: <a href="/api/status" style="color: #00c9a7; text-decoration: none; font-weight: bold;">CHECK STATUS</a></p>
      </div>
      <p style="margin-top: 50px; color: #555;">&copy; 2025 Code for Youth</p>
    </div>
  `);
});

// Configuration for Cloud MySQL
const dbConfig = {
  host: process.env.DB_HOST || 'mysql-4dc4cd4-borenabe210009-3a6b.h.aivencloud.com',
  user: process.env.DB_USER || 'avnadmin',
  password: process.env.DB_PASSWORD || 'AVNS_MAv2LUIlsBLZ3BKeP_N',
  port: process.env.DB_PORT || 12986,
  database: process.env.DB_NAME || 'defaultdb',
  ssl: { rejectUnauthorized: false }
};

// Database Pool for stability
const pool = mysql.createPool({
  ...dbConfig,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
}).promise();

// 2. API Endpoints
app.get('/api/status', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', database: 'connected' });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

app.post('/api/register', async (req, res) => {
  const { name, email, password, role } = req.body;
  try {
    const [result] = await pool.query('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',
    [name, email.toLowerCase().trim(), password, role]);
    res.status(201).json({ user: { id: result.insertId, name, email, role, createdAt: new Date() } });
  } catch (err) {
    res.status(400).json({ message: 'Email already exists or invalid data' });
  }
});

app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const [results] = await pool.query('SELECT * FROM users WHERE email = ? AND password = ?', [email.toLowerCase().trim(), password]);
    if (results.length === 0) return res.status(401).json({ message: 'Invalid credentials' });
    const user = results[0];
    res.json({ user: { id: user.id, name: user.name, email: user.email, role: user.role, createdAt: user.createdAt } });
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

app.get('/api/check-registration', async (req, res) => {
    const { userId, className } = req.query;
    try {
      console.log(`Checking registration for user ${userId} in ${className}`);
      const [results] = await pool.query('SELECT * FROM registrations WHERE user_id = ? AND class_name = ?', [userId, className]);
      res.json({ isRegistered: results.length > 0 });
    } catch (err) {
      console.error('Check Registration Error:', err.message);
      res.status(500).json({ message: 'Error checking status', error: err.message });
    }
});

app.post('/api/enroll', async (req, res) => {
    const { userId, className, phone, age, experience, amount, paymentMethod } = req.body;
    try {
      console.log(`Processing enrollment for user ${userId} in ${className}...`);
      await pool.query(
        'INSERT INTO registrations (user_id, class_name, phone, age, experience_level, amount, payment_method, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, "paid")',
        [userId, className, phone, age, experience, amount, paymentMethod]
      );
      console.log('Enrollment successful.');
      res.status(201).json({ message: 'Enrolled' });
    } catch (err) {
      console.error('Enrollment Error:', err.message);
      res.status(500).json({ message: 'Database error during enrollment', detail: err.message });
    }
});

app.get('/api/check-event-booking', async (req, res) => {
    const { userId, eventTitle } = req.query;
    try {
      const [results] = await pool.query('SELECT * FROM event_bookings WHERE user_id = ? AND event_title = ?', [userId, eventTitle]);
      res.json({ isBooked: results.length > 0 });
    } catch (err) { res.status(500).json({ message: 'Error' }); }
});

app.post('/api/book-event', async (req, res) => {
    const { userId, eventTitle } = req.body;
    try {
      await pool.query('INSERT INTO event_bookings (user_id, event_title, payment_status) VALUES (?, ?, "paid")', [userId, eventTitle]);
      res.status(201).json({ message: 'Booked' });
    } catch (err) { res.status(500).json({ message: 'Error' }); }
});

app.post('/api/contact', async (req, res) => {
    const { name, email, message } = req.body;
    try {
      await pool.query('INSERT INTO contacts (name, email, message) VALUES (?, ?, ?)', [name, email, message]);
      res.status(201).json({ message: 'Saved' });
    } catch (err) { res.status(500).json({ message: 'Error' }); }
});

// 3. Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
    // Create tables in background
    pool.query(`CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255) UNIQUE, password VARCHAR(255), role VARCHAR(50), createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP)`).catch(e => console.error(e));
    pool.query(`CREATE TABLE IF NOT EXISTS registrations (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT, class_name VARCHAR(255), phone VARCHAR(20), age INT, experience_level VARCHAR(50), amount DECIMAL(10,2), payment_method VARCHAR(50), payment_status VARCHAR(50), registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)`).catch(e => console.error(e));
    pool.query(`CREATE TABLE IF NOT EXISTS event_bookings (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT, event_title VARCHAR(255), payment_status VARCHAR(50), booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)`).catch(e => console.error(e));
    pool.query(`CREATE TABLE IF NOT EXISTS contacts (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255), message TEXT, createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP)`).catch(e => console.error(e));
});
