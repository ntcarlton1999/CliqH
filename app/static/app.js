const symptomForm = document.querySelector('#symptom-form');
const facilityForm = document.querySelector('#facility-form');

symptomForm.addEventListener('submit', async (event) => {
  event.preventDefault();
  const data = new FormData(symptomForm);
  const response = await fetch('/api/triage', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
      symptoms: data.get('symptoms').trim().split(/[,;\n]+/).map(v => v.trim()).filter(Boolean),
      urgentSymptoms: data.getAll('urgent')
    })
  });
  const result = await response.json();
  const box = document.querySelector('#symptom-result');
  box.hidden = false;
  box.className = `card result ${result.urgent ? 'urgent' : ''}`;
  box.innerHTML = `<h3>${result.title}</h3><p>${result.message}</p>`;
  box.scrollIntoView({behavior:'smooth', block:'nearest'});
});

async function loadFacilities(event) {
  if (event) event.preventEvent();
}
