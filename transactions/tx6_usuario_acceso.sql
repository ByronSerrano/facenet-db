-- =============================================
-- TRANSACCIÓN 6: Obtener los accesos de un usuario específico
-- ACID dominante: Aislamiento
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Asegura lecturas consistentes de los datos del usuario y sus accesos,
-- evitando lecturas sucias pero permitiendo nuevos registros de acceso.
-- =============================================

BEGIN;
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

  DECLARE
    v_id_usuario INT;

  -- Obtener ID del usuario usando  para bloquear la fila
  SELECT id_usuario INTO v_id_usuario
  FROM usuarios 
  WHERE cedula = '0102030405';

  SELECT * FROM registros_acceso WHERE id_usuario = v_id_usuario
  ORDER BY fecha_acceso DESC;

  INSERT INTO logs_eventos(evento, descripcion, nivel)
  VALUES ('Consulta accesos', 'Accesos consultados para usuario: ' || v_id_usuario, 'INFO');

  INSERT INTO transacciones_log(descripcion, estado_tx)
  VALUES ('Consulta accesos usuario: ' || v_id_usuario, 'COMMIT');

  EXCEPTION WHEN OTHERS THEN
    -- Manejo de errores, rollback si es necesario
    INSERT INTO transacciones_log(descripcion, estado_tx)
    VALUES ('Error al consultar accesos usuario: ' || v_id_usuario, 'ROLLBACK');
    ROLLBACK;
  END;

  COMMIT;
END;