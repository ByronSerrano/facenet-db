-- =============================================
-- TRANSACCIÓN 2: Registro de acceso exitoso
-- ACID dominante: Consistencia
-- Nivel de aislamiento: REPEATABLE READ
-- Justificación: Garantiza que los datos usados para validar el acceso no cambien durante el proceso.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

WITH acceso_valido AS (
    SELECT 1 FROM usuario u
    JOIN dispositivo d ON d.estado = TRUE
    WHERE u.id_usuario = 1 AND d.id_dispositivo = 2
)
INSERT INTO registro_acceso (id_usuario, id_dispositivo, exito)
SELECT 1, 2, TRUE WHERE EXISTS (SELECT 1 FROM acceso_valido);

INSERT INTO transaccion_log(descripcion, estado_tx)
VALUES ('Acceso exitoso usuario 1 en dispositivo 2', 'COMMIT');

INSERT INTO log_evento(evento, descripcion, nivel)
VALUES ('Acceso exitoso', 'Usuario 1 ingresó por dispositivo 2', 'INFO');

COMMIT;

