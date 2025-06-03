-- =============================================
-- DATOS INICIALES PARA EL SISTEMA FACENET
-- Este archivo debe ejecutarse después del schema.sql
-- =============================================

-- Insertar tipos de usuario
INSERT INTO tipo_usuario (nombre, descripcion) VALUES 
('Estudiante', 'Estudiante de la universidad'),
('Docente', 'Profesor o docente de la universidad'),
('Administrativo', 'Personal administrativo'),
('Visitante', 'Visitante temporal');

-- Insertar algunos dispositivos iniciales para las pruebas
INSERT INTO dispositivo (ubicacion, descripcion, estado, fecha_instalacion) VALUES 
('Edificio A - Entrada Principal', 'Cámara facial entrada principal', TRUE, '2024-01-15'),
('Edificio B - Laboratorios', 'Lector facial laboratorios', TRUE, '2024-01-20'),
('Biblioteca - Acceso', 'Sistema biométrico biblioteca', FALSE, '2024-02-01');
