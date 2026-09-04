import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();
 

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  connectionTimeoutMillis: 5000,
});

pool.query('SELECT NOW()')
  .then((result) => {
    console.log('Database connected successfully at', result.rows[0].now);
  })
  .catch((err) => {
    console.error('Failed to connect to the database:', err.message);
    process.exit(1);
  });

export default pool;