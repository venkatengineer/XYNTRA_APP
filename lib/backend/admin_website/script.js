async function loadMarks() {
  const tableBody = document.querySelector("#marksTable tbody");
  tableBody.innerHTML = "<tr><td colspan='4'>Loading...</td></tr>";

  try {
    const res = await fetch("http://192.168.56.1:8000/admin/marks");

    if (!res.ok) {
      throw new Error("Failed to fetch data");
    }

    const data = await res.json();

    tableBody.innerHTML = "";

    if (data.length === 0) {
      tableBody.innerHTML =
        "<tr><td colspan='4'>No marks submitted yet</td></tr>";
      return;
    }

    data.forEach(m => {
      const row = document.createElement("tr");

      row.innerHTML = `
        <td>${m.judge_id}</td>
        <td>${m.team_id}</td>
        <td>
          ${Object.entries(m.scores)
            .map(([k, v]) => `${k}: ${v}`)
            .join("<br>")}
        </td>
        <td><b>${m.total_score}</b></td>
      `;

      tableBody.appendChild(row);
    });

  } catch (err) {
    tableBody.innerHTML =
      "<tr><td colspan='4'>Error loading data</td></tr>";
    console.error("Admin fetch error:", err);
    alert("❌ Cannot connect to backend. Is FastAPI running?");
  }
}
