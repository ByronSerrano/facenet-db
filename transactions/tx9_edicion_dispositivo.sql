-- =============================================
-- TRANSACCIÓN 9: Edición de dispositivo existente
-- ACID dominante: Consistencia
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Actualización sencilla de datos del dispositivo.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SAVEPOINT sp_edicion_dispositivo;

UPDATE dispositivo 
SET descripcion = 'Cámara térmica facial 4K - Actualizada',
    ubicacion = 'Edificio C - Entrada Principal Renovada'
WHERE id_dispositivo = 4;

INSERT INTO transaccion_log(descripcion, estado_tx)
VALUES ('Actualización información dispositivo 4', 'COMMIT');

INSERT INTO log_evento(evento, descripcion, nivel)
VALUES ('Actualización dispositivo', 'Información del dispositivo 4 actualizada', 'INFO');

COMMIT;
