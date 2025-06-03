-- =============================================
-- TRANSACCIÓN 6: Obtener los accesos de un usuario específico
-- ACID dominante: Aislamiento
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Asegura lecturas consistentes de los datos del usuario y sus accesos,
-- evitando lecturas sucias pero permitiendo nuevos registros de acceso.
-- =============================================

DO $$
DECLARE
    v_id_usuario INT;
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    -- Obtener ID del usuario
    SELECT id_usuario INTO v_id_usuario
    FROM usuario 
    WHERE cedula = '0102030405';

    -- Si el usuario existe, consultar sus accesos
    IF v_id_usuario IS NOT NULL THEN
        -- Esta consulta mostraría los resultados en un entorno real
        PERFORM * FROM registro_acceso 
        WHERE id_usuario = v_id_usuario
        ORDER BY fecha_acceso DESC;

        INSERT INTO log_evento(evento, descripcion, nivel)
        VALUES ('Consulta accesos', 'Accesos consultados para usuario: ' || v_id_usuario, 'INFO');

        INSERT INTO transaccion_log(descripcion, estado_tx)
        VALUES ('Consulta accesos usuario: ' || v_id_usuario, 'COMMIT');
    ELSE
        INSERT INTO log_evento(evento, descripcion, nivel)
        VALUES ('Consulta accesos', 'Usuario no encontrado con cédula: 0102030405', 'WARNING');

        INSERT INTO transaccion_log(descripcion, estado_tx)
        VALUES ('Error: Usuario no encontrado', 'ROLLBACK');
    END IF;

EXCEPTION WHEN OTHERS THEN
    INSERT INTO transaccion_log(descripcion, estado_tx)
    VALUES ('Error al consultar accesos usuario: ' || COALESCE(v_id_usuario::text, 'NULL'), 'ROLLBACK');
    RAISE;
END $$;