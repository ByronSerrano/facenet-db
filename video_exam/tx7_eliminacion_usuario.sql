-- =============================================
-- TRANSACCIÓN 7: Eliminación de usuario
-- ACID dominante: Consistencia
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Asegura la eliminación de registros dependientes en orden correcto.
-- =============================================

BEGIN;

DELETE FROM registro_acceso WHERE id_usuario = 4;
DELETE FROM vector_facial WHERE id_usuario = 4;
DELETE FROM usuario WHERE id_usuario = 4;

INSERT INTO transaccion_log(descripcion, estado_tx)
VALUES ('Eliminación usuario 4 con registros asociados', 'COMMIT');

INSERT INTO log_evento(evento, descripcion, nivel)
VALUES ('Eliminación usuario', 'Usuario 4 y datos relacionados eliminados', 'INFO');

COMMIT;
