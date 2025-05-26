-- =============================================
-- TRANSACCIÓN 6: Control de concurrencia en accesos
-- ACID dominante: Aislamiento
-- Nivel de aislamiento: SERIALIZABLE
-- Justificación: Evita que se registren múltiples accesos simultáneos para el mismo usuario/dispositivo.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SAVEPOINT sp_acceso_concurrente;

WITH acceso_actual AS (
    SELECT id_usuario FROM registros_acceso
    WHERE id_dispositivo = 1 AND fecha_acceso > NOW() - INTERVAL '5 seconds'
    FOR UPDATE
)
INSERT INTO registros_acceso (id_usuario, id_dispositivo, exito)
SELECT 4, 1, TRUE WHERE NOT EXISTS (SELECT 1 FROM acceso_actual);

INSERT INTO transacciones_log(descripcion, estado_tx)
VALUES ('Intento acceso concurrente dispositivo 1', 'COMMIT');

INSERT INTO logs_eventos(evento, descripcion, nivel)
VALUES ('Acceso concurrente', 'Procesamiento acceso simultáneo en dispositivo 1', 'INFO');

COMMIT;
