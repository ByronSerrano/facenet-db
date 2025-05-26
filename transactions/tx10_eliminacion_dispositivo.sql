-- =============================================
-- TRANSACCIÓN 10: Eliminación condicional de dispositivo
-- ACID dominante: Atomicidad + Consistencia
-- Nivel de aislamiento: SERIALIZABLE
-- Justificación: Garantiza que el dispositivo solo se elimine si no tiene registros asociados.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SAVEPOINT sp_eliminacion_condicional;

WITH registros_asociados AS (
    SELECT 1 FROM registros_acceso WHERE id_dispositivo = 6 LIMIT 1
)
DELETE FROM dispositivos
WHERE id_dispositivo = 6
AND NOT EXISTS (SELECT 1 FROM registros_asociados);

INSERT INTO transacciones_log(descripcion, estado_tx)
VALUES ('Eliminación condicional dispositivo 6', 'COMMIT');

INSERT INTO logs_eventos(evento, descripcion, nivel)
VALUES ('Mantenimiento', 'Dispositivo 6 eliminado sin registros asociados', 'INFO');

COMMIT;
