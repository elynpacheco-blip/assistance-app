-- ========================================================
-- CARGA COMPLEMENTARIA: Estudiantes y Matrículas (2026c2)
-- Ejecutar en el SQL Editor de Supabase
-- ========================================================

-- 1. Insertar todos los estudiantes únicos (43 estudiantes)
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

-- 2. Matricular a los estudiantes en sus asignaturas correspondientes
-- Matrícula: Gerencia de Proyectos Informáticos (10SA) (21 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000001-0000-0000-0000-000000000001', s.id
FROM public.students s
WHERE s.cedula IN (
        '0923078281',
        '0929785889',
        '0941102451',
        '0941333692',
        '0943542357',
        '0950317487',
        '0951134055',
        '0951894716',
        '0951974682',
        '0952213759',
        '0953006186',
        '0953207156',
        '0953867223',
        '0955172804',
        '0955512272',
        '0955815014',
        '0958866238',
        '0959277005',
        '0959312703',
        '0959378506',
        '2000114732'
    )
ON CONFLICT (subject_id, student_id) DO NOTHING;

-- Matrícula: Investigación de Operaciones (6SA) (13 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000002-0000-0000-0000-000000000002', s.id
FROM public.students s
WHERE s.cedula IN (
        '0924035942',
        '0941331993',
        '0942051038',
        '0942077124',
        '0942432469',
        '0943079749',
        '0943784405',
        '0953925369',
        '0955376348',
        '0956256093',
        '0956807671',
        '0957032386',
        '2450612326'
    )
ON CONFLICT (subject_id, student_id) DO NOTHING;

-- Matrícula: Probabilidad (4SA) (8 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000003-0000-0000-0000-000000000003', s.id
FROM public.students s
WHERE s.cedula IN (
        '0928809151',
        '0941148819',
        '0941529836',
        '0952891638',
        '0955426325',
        '0955915640',
        '0955915780',
        '0958962144'
    )
ON CONFLICT (subject_id, student_id) DO NOTHING;

-- Matrícula: Sistemas Operativos (6SA) (14 estudiantes)
INSERT INTO public.subject_students (subject_id, student_id)
SELECT 'c2000004-0000-0000-0000-000000000004', s.id
FROM public.students s
WHERE s.cedula IN (
        '0924035942',
        '0931998058',
        '0941331993',
        '0942051038',
        '0942077124',
        '0942432469',
        '0943079749',
        '0943784405',
        '0953925369',
        '0955376348',
        '0956256093',
        '0956807671',
        '0957032386',
        '2450612326'
    )
ON CONFLICT (subject_id, student_id) DO NOTHING;
