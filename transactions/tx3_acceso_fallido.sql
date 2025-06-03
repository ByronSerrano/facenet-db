-- =============================================
-- TRANSACCIÓN 3: Registro de acceso fallido
-- ACID dominante: Durabilidad
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Permite registrar el fallo inmediatamente con estado actualizado del sistema.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SAVEPOINT sp_intento_fallido;

INSERT INTO registro_acceso (id_usuario, id_dispositivo, exito, motivo_fallo)
VALUES (NULL, 1, FALSE, 'Reconocimiento facial fallido - baja confianza');

INSERT INTO transaccion_log(descripcion, estado_tx)
VALUES ('Intento de acceso fallido dispositivo 1', 'COMMIT');

INSERT INTO log_evento(evento, descripcion, nivel)
VALUES ('Acceso fallido', 'Intento no reconocido en dispositivo 1', 'WARNING');

COMMIT;
