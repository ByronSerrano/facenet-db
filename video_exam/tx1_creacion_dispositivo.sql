-- =============================================
-- TRANSACCIÓN 1: Creación de dispositivo
-- ACID dominante: Atomicidad
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Transacción sencilla, sin conflictos concurrentes, requiere inserción segura.
-- =============================================

BEGIN;

INSERT INTO dispositivo (ubicacion, descripcion, fecha_instalacion)
VALUES ('Edificio C - Entrada Principal', 'Cámara térmica facial 4K', '2024-03-15');

INSERT INTO transaccion_log(descripcion, estado_tx)
VALUES ('Instalación nuevo dispositivo en Edificio C', 'COMMIT');

INSERT INTO log_evento(evento, descripcion, nivel)
VALUES ('Nuevo dispositivo', 'Dispositivo instalado en Edificio C', 'INFO');

COMMIT;
