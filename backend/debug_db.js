const mysql = require('mysql2');

const dbConfig = {
  host: 'mysql-4dc4cd4-borenabe210009-3a6b.h.aivencloud.com',
  user: 'avnadmin',
  password: 'AVNS_MAv2LUIlsBLZ3BKeP_N',
  port: 12986,
  database: 'defaultdb',
  ssl: { rejectUnauthorized: false }
};

async function debug() {
  const connection = mysql.createConnection(dbConfig).promise();
  try {
    console.log('--- DB DEBUG START ---');

    // 1. Test Connection
    await connection.query('SELECT 1');
    console.log('✅ Connection: OK');

    // 2. Check Tables
    const [tables] = await connection.query('SHOW TABLES');
    console.log('📋 Tables found:', tables.map(t => Object.values(t)[0]).join(', '));

    // 3. Check Registrations Schema
    try {
      const [schema] = await connection.query('DESCRIBE registrations');
      console.log('✅ Registrations Table exists.');
      // Print columns to see if there is a mismatch
      schema.forEach(col => console.log(`   - ${col.Field}: ${col.Type}`));
    } catch (e) {
      console.log('❌ Registrations Table MISSING or ERROR:', e.message);
    }

    console.log('--- DB DEBUG END ---');
  } catch (err) {
    console.error('❌ CRITICAL DB ERROR:', err.message);
  } finally {
    await connection.end();
  }
}

debug();
