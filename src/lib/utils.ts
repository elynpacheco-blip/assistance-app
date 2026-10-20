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

export interface AcademicStatus {
  isRegularWeek: boolean;
  statusType: 'regular' | 'vacation' | 'exams' | 'pre_cycle' | 'post_cycle';
  currentWeek: number; // 1 to 16
  partial: 1 | 2;
  title: string;
  message?: string;
  datesDescription?: string;
}

export function getWeekDateRange(week: number): { start: Date; end: Date; startStr: string; endStr: string } {
  const index = Math.max(1, Math.min(week, 16)) - 1;
  const mondayStr = WEEKS_START_DATES[index];
  const [y, m, d] = mondayStr.split('-').map(Number);
  const start = new Date(y, m - 1, d);
  const end = new Date(y, m - 1, d + 6);
  return {
    start,
    end,
    startStr: mondayStr,
    endStr: formatDate(end)
  };
}

export function getCurrentAcademicStatus(date: Date = new Date()): AcademicStatus {
  const dateStr = formatDate(date);

  // 1. Antes del inicio oficial del ciclo: < 2026-10-12
  if (dateStr < WEEKS_START_DATES[0]) {
    return {
      isRegularWeek: false,
      statusType: 'pre_cycle',
      currentWeek: 1,
      partial: 1,
      title: 'Fuera del Período Académico',
      message: 'El ciclo académico aún no ha iniciado. El inicio oficial de clases del Ciclo II es el 12 de octubre de 2026.',
      datesDescription: 'Inicio de clases: 12 de Octubre de 2026'
    };
  }

  // 2. Verificar si la fecha cae en alguna de las 16 semanas regulares de clase
  for (let i = 0; i < 16; i++) {
    const { startStr, endStr } = getWeekDateRange(i + 1);
    if (dateStr >= startStr && dateStr <= endStr) {
      const week = i + 1;
      const partial = (week <= 8 ? 1 : 2) as 1 | 2;
      return {
        isRegularWeek: true,
        statusType: 'regular',
        currentWeek: week,
        partial,
        title: `Semana ${week} en curso`,
        datesDescription: `${startStr} al ${endStr}`
      };
    }
  }

  // 3. Período de Exámenes del Parcial I: 2026-12-07 al 2026-12-13
  if (dateStr >= '2026-12-07' && dateStr <= '2026-12-13') {
    return {
      isRegularWeek: false,
      statusType: 'exams',
      currentWeek: 8,
      partial: 1,
      title: 'Período de Exámenes (Parcial I)',
      message: 'Nos encontramos en la semana de evaluaciones y exámenes del Parcial I (del 7 al 13 de diciembre de 2026). No hay clases regulares en esta semana.',
      datesDescription: '07-Dic-2026 al 13-Dic-2026'
    };
  }

  // 4. Período de Vacancia Fin de Año: 2026-12-21 al 2027-01-03
  if (dateStr >= '2026-12-21' && dateStr <= '2027-01-03') {
    return {
      isRegularWeek: false,
      statusType: 'vacation',
      currentWeek: 10,
      partial: 2,
      title: 'Período de Vacancia Académica',
      message: 'Nos encontramos en el receso vacacional de fin de año (del 21 de diciembre de 2026 al 3 de enero de 2027). Las clases regulares se reanudan el 4 de enero de 2027 en la Semana 10.',
      datesDescription: '21-Dic-2026 al 03-Ene-2027'
    };
  }

  // 5. Conclusión de las 16 semanas regulares: posterior a 2027-02-21
  const week16Range = getWeekDateRange(16);
  if (dateStr > week16Range.endStr) {
    return {
      isRegularWeek: false,
      statusType: 'post_cycle',
      currentWeek: 16,
      partial: 2,
      title: 'Fuera del Período Académico Regular',
      message: 'El período de 16 semanas de clases regulares del Ciclo II ha concluido (finalizó el 21 de febrero de 2027). Actualmente nos encontramos en exámenes finales o período intersemestral.',
      datesDescription: 'Fin de clases regulares: 21 de Febrero de 2027'
    };
  }

  return {
    isRegularWeek: false,
    statusType: 'post_cycle',
    currentWeek: 16,
    partial: 2,
    title: 'Fuera del Período Académico',
    message: 'La fecha actual se encuentra fuera de las semanas lectivas regulares.'
  };
}

export function getWeekAndPartial(date: Date) {
  const status = getCurrentAcademicStatus(date);
  return { week: status.currentWeek, partial: status.partial };
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
