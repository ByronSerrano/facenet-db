-- =============================================
-- TRANSACCIÓN 1: Registro de nuevo usuario y su vector facial
-- ACID dominante: Atomicidad
-- Nivel de aislamiento: SERIALIZABLE
-- Justificación: Se requiere consistencia estricta para evitar duplicidad de cédula o correo en concurrencia.
-- =============================================
DO $$
  BEGIN;
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


    INSERT INTO usuario(cedula, nombres, apellidos, id_tipo_usuario, correo_institucional)
    VALUES ('0102030405', 'Ana', 'Pérez', 1, 'ana.perez@pucem.edu.ec');

    INSERT INTO vector_facial(id_usuario, vector, version_algoritmo)
    VALUES (currval('usuario_id_usuario_seq'), ARRAY[0.123, 0.456, 0.789], 'FaceNet-v1');

    INSERT INTO transaccion_log(descripcion, estado_tx)
    VALUES ('Registro completo de usuario y vector facial', 'COMMIT');

    INSERT INTO log_evento(evento, descripcion, nivel)
    VALUES ('Registro usuario', 'Usuario 0102030405 registrado con embedding FaceNet-v1', 'INFO');

    EXCEPTION WHEN OTHERS THEN
      -- Manejo de errores, rollback si es necesario
      INSERT INTO transaccion_log(descripcion, estado_tx)
      VALUES ('Error al consultar accesos usuario: ' || v_id_usuario, 'ROLLBACK');
      ROLLBACK;
    END;

  COMMIT;

  END;
$$;
