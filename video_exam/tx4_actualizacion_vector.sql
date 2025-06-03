-- =============================================
-- TRANSACCIÓN 4: Actualización de vector facial
-- ACID dominante: Consistencia
-- Nivel de aislamiento: REPEATABLE READ
-- Justificación: Previene modificaciones simultáneas del vector facial del mismo usuario.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SAVEPOINT sp_actualizacion;

UPDATE vector_facial
SET vector = ARRAY[0.45, 0.67, 0.89, 0.12], fecha_almacenamiento = NOW()
WHERE id_usuario = 1 AND id_vector = 1;

INSERT INTO transaccion_log(descripcion, estado_tx)
VALUES ('Actualización vector facial usuario 1', 'COMMIT');

INSERT INTO log_evento(evento, descripcion, nivel)
VALUES ('Actualización biométrica', 'Vector actualizado para usuario 1', 'INFO');

COMMIT;
