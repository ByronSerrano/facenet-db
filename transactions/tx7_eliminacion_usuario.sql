-- =============================================
-- TRANSACCIÓN 7: Eliminación de usuario
-- ACID dominante: Consistencia
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Asegura la eliminación de registros dependientes en orden correcto.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SAVEPOINT sp_eliminacion;

DELETE FROM registros_acceso WHERE id_usuario = 4;
DELETE FROM vectores_faciales WHERE id_usuario = 4;
DELETE FROM usuarios WHERE id_usuario = 4;

INSERT INTO transacciones_log(descripcion, estado_tx)
VALUES ('Eliminación usuario 4 con registros asociados', 'COMMIT');

INSERT INTO logs_eventos(evento, descripcion, nivel)
VALUES ('Eliminación usuario', 'Usuario 4 y datos relacionados eliminados', 'INFO');

COMMIT;
