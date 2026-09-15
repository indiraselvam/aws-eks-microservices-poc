const express = require("express");
const { Pool } = require("pg");

const app = express();
app.use(express.json());

const port = process.env.PORT || 3000;

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000
});

app.get("/api/health", async (_req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({ status: "healthy", database: "connected" });
  } catch (error) {
    console.error("Database health check failed:", error.message);
    res.status(503).json({ status: "unhealthy", database: "unavailable" });
  }
});

app.get("/api/employees", async (_req, res) => {
  try {
    const result = await pool.query(
      "SELECT id, name, email, role FROM employees ORDER BY id"
    );
    res.json(result.rows);
  } catch (error) {
    console.error("Employee query failed:", error.message);
    res.status(500).json({ error: "Unable to retrieve employees" });
  }
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Backend listening on port ${port}`);
});