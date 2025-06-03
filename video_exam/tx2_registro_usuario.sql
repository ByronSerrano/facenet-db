-- =============================================
-- TRANSACCIÓN 2: Registro de nuevo usuario y su vector facial
-- ACID dominante: Atomicidad
-- Nivel de aislamiento: SERIALIZABLE
-- Justificación: Se requiere consistencia estricta para evitar duplicidad de cédula o correo en concurrencia.
-- =============================================

BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Insertar usuario
INSERT INTO usuario(cedula, nombres, apellidos, id_tipo_usuario, correo_institucional)
VALUES ('0102030405', 'Ana', 'Pérez', 1, 'ana.perez@pucem.edu.ec');

-- Obtener el ID del usuario recién insertado y crear su vector facial
INSERT INTO vector_facial(id_usuario, vector, version_algoritmo)
VALUES (currval('usuario_id_usuario_seq'), ARRAY[0.123, 0.456, 0.789], 'FaceNet-v1');

-- Registrar la transacción
INSERT INTO transaccion_log(descripcion, estado_tx)
VALUES ('Registro completo de usuario y vector facial', 'COMMIT');

-- Log del evento
INSERT INTO log_evento(evento, descripcion, nivel)
VALUES ('Registro usuario', 'Usuario 0102030405 registrado con embedding FaceNet-v1', 'INFO');

COMMIT;
