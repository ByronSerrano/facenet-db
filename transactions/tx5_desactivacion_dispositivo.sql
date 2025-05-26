-- =============================================
-- TRANSACCIÓN 5: Desactivación de dispositivo
-- ACID dominante: Atomicidad
-- Nivel de aislamiento: SERIALIZABLE
-- Justificación: Evita condiciones de carrera en el cambio de estado del dispositivo.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SAVEPOINT sp_desactivacion;

UPDATE dispositivos SET estado = FALSE WHERE id_dispositivo = 3;

INSERT INTO transacciones_log(descripcion, estado_tx)
VALUES ('Desactivación dispositivo 3', 'COMMIT');

INSERT INTO logs_eventos(evento, descripcion, nivel)
VALUES ('Mantenimiento', 'Dispositivo 3 desactivado', 'INFO');

COMMIT;
