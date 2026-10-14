// Fechas de inicio (Lunes) de las 16 semanas efectivas del Ciclo II (2026 - 2027 CII / 2026c2)
// Obtenido de los planes analíticos aprobados y firmados de la UAE:
// - Parcial I: Semanas 1 a 8 (12-Oct-2026 a 06-Dic-2026)
// - Exámenes Parcial I: 07-Dic-2026 a 13-Dic-2026
// - Parcial II (inicio): Semana 9 (14-Dic-2026 a 20-Dic-2026)
// - Vacancia Fin de Año: 21-Dic-2026 a 03-Ene-2027
// - Parcial II (continuación): Semanas 10 a 16 (04-Ene-2027 a 21-Feb-2027)
export const WEEKS_START_DATES: string[] = [
  '2026-10-12', // Semana 1 (Parcial 1)
  '2026-10-19', // Semana 2 (Parcial 1)
  '2026-10-26', // Semana 3 (Parcial 1)
  '2026-11-02', // Semana 4 (Parcial 1)
  '2026-11-09', // Semana 5 (Parcial 1)
  '2026-11-16', // Semana 6 (Parcial 1)
  '2026-11-23', // Semana 7 (Parcial 1)
  '2026-11-30', // Semana 8 (Parcial 1)
  '2026-12-14', // Semana 9 (Parcial 2 - posterior a exámenes P1)
  '2027-01-04', // Semana 10 (Parcial 2 - retorno de vacancia)
  '2027-01-11', // Semana 11 (Parcial 2)
  '2027-01-18', // Semana 12 (Parcial 2)
  '2027-01-25', // Semana 13 (Parcial 2)
  '2027-02-01', // Semana 14 (Parcial 2)
  '2027-02-08', // Semana 15 (Parcial 2)
  '2027-02-15', // Semana 16 (Parcial 2)
];

export const START_DATE = new Date('2026-10-12T00:00:00');

export function getWeekAndPartial(date: Date) {
  const dateStr = formatDate(date);

  if (dateStr < WEEKS_START_DATES[0]) {
    return { week: 1, partial: 1 };
  }

  if (dateStr >= WEEKS_START_DATES[15]) {
    return { week: 16, partial: 2 };
  }

  for (let i = 0; i < 15; i++) {
    if (dateStr >= WEEKS_START_DATES[i] && dateStr < WEEKS_START_DATES[i + 1]) {
      const week = i + 1;
      const partial = week <= 8 ? 1 : 2;
      return { week, partial };
    }
  }

  return { week: 16, partial: 2 };
}

export function getDatesForWeek(week: number) {
  const index = Math.max(1, Math.min(week, 16)) - 1;
  const mondayStr = WEEKS_START_DATES[index];
  const [y, m, d] = mondayStr.split('-').map(Number);
  
  const dates: Date[] = [];
  for (let i = 0; i < 7; i++) {
    const day = new Date(y, m - 1, d + i);
    dates.push(day);
  }
  return dates;
}

export function formatDate(date: Date) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

export const DAYS_SPANISH = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
export const DAYS_ENGLISH_TO_SPANISH: Record<string, string> = {
  'Monday': 'Lunes',
  'Tuesday': 'Martes',
  'Wednesday': 'Miércoles',
  'Thursday': 'Jueves',
  'Friday': 'Viernes',
  'Saturday': 'Sábado',
  'Sunday': 'Domingo'
};

export function toTitleCase(str: string) {
  return str.toLowerCase().split(' ').map(word => {
    return word.charAt(0).toUpperCase() + word.slice(1);
  }).join(' ');
}
