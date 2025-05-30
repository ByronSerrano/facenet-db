-- =============================================
-- TRANSACCIÓN 1: Registro de nuevo usuario y su vector facial
-- ACID dominante: Atomicidad
-- Nivel de aislamiento: SERIALIZABLE
-- Justificación: Se requiere consistencia estricta para evitar duplicidad de cédula o correo en concurrencia.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

INSERT INTO usuarios(cedula, nombres, apellidos, tipo_usuario, correo_institucional)
VALUES ('0102030405', 'Ana', 'Pérez', 'estudiante', 'ana.perez@uce.edu.ec');

INSERT INTO vectores_faciales(id_usuario, vector, version_algoritmo)
VALUES (currval('usuarios_id_usuario_seq'), ARRAY[0.123, 0.456, 0.789], 'FaceNet-v1');

INSERT INTO transacciones_log(descripcion, estado_tx)
VALUES ('Registro completo de usuario y vector facial', 'COMMIT');

INSERT INTO logs_eventos(evento, descripcion, nivel)
VALUES ('Registro usuario', 'Usuario 0102030405 registrado con embedding FaceNet-v1', 'INFO');

COMMIT;
