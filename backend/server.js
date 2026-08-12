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
  password: process.env.DB_PASSWORD, // No more hardcoded password here!
  port: process.env.DB_PORT || 12986,
  database: process.env.DB_NAME || 'defaultdb',
  ssl: { rejectUnauthorized: false }
};

const db = mysql.createConnection(dbConfig).promise();

// 2. API Endpoints
app.get('/api/status', (req, res) => res.json({ status: 'ok', database: 'connected' }));

app.post('/api/register', async (req, res) => {
  const { name, email, password, role } = req.body;
  try {
    const [result] = await db.query('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)', [name, email.toLowerCase().trim(), password, role]);
    res.status(201).json({ user: { id: result.insertId, name, email, role } });
  } catch (err) { res.status(400).json({ message: 'Email already exists' }); }
});

app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const [results] = await db.query('SELECT * FROM users WHERE email = ? AND password = ?', [email.toLowerCase().trim(), password]);
    if (results.length === 0) return res.status(401).json({ message: 'Invalid credentials' });
    res.json({ user: results[0] });
  } catch (err) { res.status(500).json({ message: 'Server error' }); }
});

app.post('/api/contact', async (req, res) => {
    const { name, email, message } = req.body;
    try {
      await db.query('INSERT INTO contacts (name, email, message) VALUES (?, ?, ?)', [name, email, message]);
      res.status(201).json({ message: 'Saved' });
    } catch (err) { res.status(500).json({ message: 'Error' }); }
});

app.post('/api/enroll', async (req, res) => {
    const { userId, className, phone, age, experience, amount, paymentMethod } = req.body;
    try {
      await db.query('INSERT INTO registrations (user_id, class_name, phone, age, experience_level, amount, payment_method, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, "paid")', [userId, className, phone, age, experience, amount, paymentMethod]);
      res.status(201).json({ message: 'Enrolled' });
    } catch (err) { res.status(500).json({ message: 'Error' }); }
});

app.post('/api/book-event', async (req, res) => {
    const { userId, eventTitle } = req.body;
    try {
      await db.query('INSERT INTO event_bookings (user_id, event_title, payment_status) VALUES (?, ?, "paid")', [userId, eventTitle]);
      res.status(201).json({ message: 'Booked' });
    } catch (err) { res.status(500).json({ message: 'Error' }); }
});

// 3. Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
    // Create tables in background
    db.query(`CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255) UNIQUE, password VARCHAR(255), role VARCHAR(50), createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP)`).catch(e => console.error(e));
});
