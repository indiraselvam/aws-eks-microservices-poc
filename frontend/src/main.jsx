import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import "./style.css";

function App() {
  const [health, setHealth] = useState("Checking...");
  const [employees, setEmployees] = useState([]);

  async function loadData() {
    try {
      const healthResponse = await fetch("/api/health");
      const healthData = await healthResponse.json();
      setHealth(healthData.status);

      const employeeResponse = await fetch("/api/employees");
      const employeeData = await employeeResponse.json();
      setEmployees(employeeData);
    } catch {
      setHealth("Backend unavailable");
    }
  }

  useEffect(() => {
    loadData();
  }, []);

  return (
    <main className="container">
      <h1>EKS Microservices POC</h1>
      <p className="subtitle">Frontend → Backend → RDS PostgreSQL</p>

      <section className="card">
        <h2>Application Health</h2>
        <p className="health">{health}</p>
      </section>

      <section className="card">
        <h2>Employees</h2>
        {employees.length === 0 ? (
          <p>No employees found. Add sample data in RDS using database/init.sql.</p>
        ) : (
          <table>
            <thead>
              <tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th></tr>
            </thead>
            <tbody>
              {employees.map((e) => (
                <tr key={e.id}>
                  <td>{e.id}</td><td>{e.name}</td><td>{e.email}</td><td>{e.role}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </main>
  );
}

createRoot(document.getElementById("root")).render(<App />);