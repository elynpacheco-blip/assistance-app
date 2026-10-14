-- ========================================================
-- Esquema de Base de Datos para Sistema de Asistencias
-- Ejecutar en el SQL Editor de Supabase
-- ========================================================

-- 1. Tabla de Ciclos Académicos
CREATE TABLE IF NOT EXISTS public.academic_cycles (
    id TEXT PRIMARY KEY,                       -- Ej: '2026c2', '2026c1'
    start_date DATE NOT NULL DEFAULT '2026-10-12',
    is_default BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabla de Materias / Asignaturas
CREATE TABLE IF NOT EXISTS public.subjects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    hash_id TEXT UNIQUE NOT NULL,              -- Identificador único para el enlace del estudiante
    cycle_id TEXT NOT NULL REFERENCES public.academic_cycles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabla de Estudiantes
CREATE TABLE IF NOT EXISTS public.students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    cedula TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Tabla Intermedia Materias <-> Estudiantes
CREATE TABLE IF NOT EXISTS public.subject_students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_subject_student UNIQUE (subject_id, student_id)
);

-- 5. Tabla de Horario de Clases
CREATE TABLE IF NOT EXISTS public.schedule (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
    day_of_week TEXT NOT NULL,                 -- 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Tabla de Registro de Asistencias
CREATE TABLE IF NOT EXISTS public.attendance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
    subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
    attendance_date DATE NOT NULL,
    is_present BOOLEAN NOT NULL DEFAULT false,
    week_number INTEGER NOT NULL,              -- Semana del ciclo (1-16)
    partial_number INTEGER NOT NULL,           -- 1 para Parcial I, 2 para Parcial II
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT attendance_unique_record UNIQUE (student_id, subject_id, attendance_date)
);

-- ========================================================
-- Políticas de Seguridad (Row Level Security - RLS)
-- Permitir lectura y escritura mediante la clave anon del cliente
-- ========================================================

ALTER TABLE public.academic_cycles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subject_students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedule ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
    DROP POLICY IF EXISTS "Allow anon all on academic_cycles" ON public.academic_cycles;
    DROP POLICY IF EXISTS "Allow anon all on subjects" ON public.subjects;
    DROP POLICY IF EXISTS "Allow anon all on students" ON public.students;
    DROP POLICY IF EXISTS "Allow anon all on subject_students" ON public.subject_students;
    DROP POLICY IF EXISTS "Allow anon all on schedule" ON public.schedule;
    DROP POLICY IF EXISTS "Allow anon all on attendance" ON public.attendance;
END $$;

CREATE POLICY "Allow anon all on academic_cycles" ON public.academic_cycles FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon all on subjects" ON public.subjects FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon all on students" ON public.students FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon all on subject_students" ON public.subject_students FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon all on schedule" ON public.schedule FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon all on attendance" ON public.attendance FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- ========================================================
-- Datos del Segundo Ciclo de Estudios (2026 - 2027 CII / 2026c2)
-- Conforme a los Planes Analíticos Oficiales Firmados UAE
-- ========================================================

-- Insertar ciclos académicos
INSERT INTO public.academic_cycles (id, start_date, is_default)
VALUES 
    ('2026c2', '2026-10-12', true),
    ('2026c1', '2026-04-20', false)
ON CONFLICT (id) DO UPDATE SET 
    start_date = EXCLUDED.start_date,
    is_default = EXCLUDED.is_default;

-- Insertar las 4 asignaturas del Ciclo II (2026c2)
INSERT INTO public.subjects (id, name, hash_id, cycle_id)
VALUES
    ('c2000001-0000-0000-0000-000000000001', 'Gerencia de Proyectos Informáticos', 'gpi-10sa', '2026c2'),
    ('c2000002-0000-0000-0000-000000000002', 'Investigación de Operaciones', 'io-6sa', '2026c2'),
    ('c2000003-0000-0000-0000-000000000003', 'Probabilidad', 'prob-4sa', '2026c2'),
    ('c2000004-0000-0000-0000-000000000004', 'Sistemas Operativos', 'so-6sa', '2026c2')
ON CONFLICT (hash_id) DO UPDATE SET
    name = EXCLUDED.name,
    cycle_id = EXCLUDED.cycle_id;

-- Insertar los horarios oficiales de clases según los planes analíticos
DELETE FROM public.schedule WHERE subject_id IN (
    'c2000001-0000-0000-0000-000000000001',
    'c2000002-0000-0000-0000-000000000002',
    'c2000003-0000-0000-0000-000000000003',
    'c2000004-0000-0000-0000-000000000004'
);

INSERT INTO public.schedule (subject_id, day_of_week)
VALUES
    -- 1. Gerencia de Proyectos Informáticos (10SA): Lunes, Miércoles y Viernes
    ('c2000001-0000-0000-0000-000000000001', 'Monday'),
    ('c2000001-0000-0000-0000-000000000001', 'Wednesday'),
    ('c2000001-0000-0000-0000-000000000001', 'Friday'),

    -- 2. Investigación de Operaciones (6SA): Martes y Jueves
    ('c2000002-0000-0000-0000-000000000002', 'Tuesday'),
    ('c2000002-0000-0000-0000-000000000002', 'Thursday'),

    -- 3. Probabilidad (4SA): Martes y Jueves
    ('c2000003-0000-0000-0000-000000000003', 'Tuesday'),
    ('c2000003-0000-0000-0000-000000000003', 'Thursday'),

    -- 4. Sistemas Operativos (6SA): Miércoles y Viernes
    ('c2000004-0000-0000-0000-000000000004', 'Wednesday'),
    ('c2000004-0000-0000-0000-000000000004', 'Friday');

-- ========================================================
-- Estudiantes Oficiales del Ciclo II (43 estudiantes)
-- ========================================================

INSERT INTO public.students (name, cedula)
VALUES
    ('ALBAN CONTRERAS NORBERTO JEAMPIERRE', '0943079749'),
    ('ALVARADO MARCILLO JOSUE HUGO', '0951134055'),
    ('ARANDA PENAFIEL FREDDY RUBEN', '2000114732'),
    ('BOHORQUEZ BONZO ALFREDA VICTORIA', '0923078281'),
    ('BRAVO CAMPUZANO ANGELINA ELIZABETH', '0943784405'),
    ('BRIONES AZU FRANKLIN FERNANDO', '0941331993'),
    ('CASTRO ROCHA BRYAN ARIEL', '0941333692'),
    ('CHELE IZA ANGEL ISRAEL', '0953006186'),
    ('CONZA PESANTES LUIS DAVID', '0959277005'),
    ('GARCIA CEDENO FABIAN FRANCISCO', '0941102451'),
    ('GARCIA DIAZ PEDRO LUIS', '0928809151'),
    ('GOROSABEL CORREA JORDAN ANDRE', '0942077124'),
    ('GUAMAN MIRANDA JOSUE ADRIAN', '0953925369'),
    ('GUAMAN TORRES JOSTIN JOSUE', '0931998058'),
    ('GUAPULEMA TORRES MAX FERNANDO', '0956256093'),
    ('GUERRERO COELLO KAREN MARIUXI', '0955376348'),
    ('HELAO JIMENEZ GEANCARLO ANTONIO', '0924035942'),
    ('HIDALGO GARCIA MANUEL EDUARDO', '0959378506'),
    ('HUAYLLA APONTE KATRINA SAHORI', '0955426325'),
    ('JARA FLORES DIEGO ALEXANDER', '0942051038'),
    ('LEON GONZALEZ GENESIS ELIZABETH', '0955915780'),
    ('LEON GONZALEZ GENESIS ESTHER', '0955915640'),
    ('LEON TOLEDO REINALDO EMANUEL', '2450612326'),
    ('MENDEZ NEGRETE JAZMANY ROLANDO', '0953207156'),
    ('MENDEZ SALAVARRIA VICTOR HUGO', '0955172804'),
    ('MEZA PILOSO ERIKA BELEN', '0941148819'),
    ('MONTENEGRO PEREZ JUAN DANIEL', '0951894716'),
    ('MOREIRA QUINTANA BRAULIO OMAR', '0951974682'),
    ('MURILLO FLORES ANTHONY GABRIEL', '0958962144'),
    ('PALMA MUNOZ VICTOR HUGO', '0955512272'),
    ('PIGUAVE DUARTE EDWIN JAVIER', '0952213759'),
    ('POVEDA FIGUEROA YUL MIGUEL', '0953867223'),
    ('RAMIREZ CASTRO AMELIA JORDANA', '0943542357'),
    ('RENDON RIERA VICTOR ANDRES', '0952891638'),
    ('RODRIGUEZ VALLE LUIS ANDRES', '0929785889'),
    ('SOLIS POVEDA FELIX JAVIER', '0942432469'),
    ('SOLORZANO FLORES ERICK DAMIAN', '0950317487'),
    ('TERAN ASTUDILLO ANGELLY MICHELLE', '0955815014'),
    ('VACA CHAMORRO WLADIMIR ANDRE', '0956807671'),
    ('VALENCIA BENAVIDES ISRAEL JOSUE', '0959312703'),
    ('VARGAS SANTUR JOSE DAVID', '0941529836'),
    ('VICUNA DELGADO DENISSE LILIANA', '0957032386'),
    ('VILLAMAR CEVALLOS STEVEN ALEXANDER', '0958866238')
ON CONFLICT (cedula) DO UPDATE SET name = EXCLUDED.name;

-- ========================================================
-- Matrícula de Estudiantes por Asignatura (subject_students)
-- ========================================================

-- 1. Gerencia de Proyectos Informáticos (10SA) (21 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000001-0000-0000-0000-000000000001', s.id
FROM public.students s
WHERE s.cedula IN (
    '0923078281', '0929785889', '0941102451', '0941333692', '0943542357',
    '0950317487', '0951134055', '0951894716', '0951974682', '0952213759',
    '0953006186', '0953207156', '0953867223', '0955172804', '0955512272',
    '0955815014', '0958866238', '0959277005', '0959312703', '0959378506',
    '2000114732'
)
ON CONFLICT (subject_id, student_id) DO NOTHING;

-- 2. Investigación de Operaciones (6SA) (13 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000002-0000-0000-0000-000000000002', s.id
FROM public.students s
WHERE s.cedula IN (
    '0924035942', '0941331993', '0942051038', '0942077124', '0942432469',
    '0943079749', '0943784405', '0953925369', '0955376348', '0956256093',
    '0956807671', '0957032386', '2450612326'
)
ON CONFLICT (subject_id, student_id) DO NOTHING;

-- 3. Probabilidad (4SA) (8 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000003-0000-0000-0000-000000000003', s.id
FROM public.students s
WHERE s.cedula IN (
    '0928809151', '0941148819', '0941529836', '0952891638', '0955426325',
    '0955915640', '0955915780', '0958962144'
)
ON CONFLICT (subject_id, student_id) DO NOTHING;

-- 4. Sistemas Operativos (6SA) (14 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000004-0000-0000-0000-000000000004', s.id
FROM public.students s
WHERE s.cedula IN (
    '0924035942', '0931998058', '0941331993', '0942051038', '0942077124',
    '0942432469', '0943079749', '0943784405', '0953925369', '0955376348',
    '0956256093', '0956807671', '0957032386', '2450612326'
)
ON CONFLICT (subject_id, student_id) DO NOTHING;
