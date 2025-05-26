-- Nivel de aislamiento: REPEATABLE READ
-- Justificación: Se garantiza que los datos leídos no cambien durante la transacción.

BEGIN;

SAVEPOINT actualizar_vector;

DO $$
DECLARE
    v_id_usuario INT;
BEGIN
    -- Obtenemos el ID del usuario
    SELECT id_usuario INTO v_id_usuario
    FROM usuarios WHERE cedula = '1316229739';

    -- Actualizamos su vector facial
    UPDATE vectores_faciales
    SET vector = ARRAY[0.5, 0.6, 0.7, 0.8],
        version_algoritmo = 'FaceNet-v2'
    WHERE id_usuario = v_id_usuario;

    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Vector facial actualizado para usuario 1316229739', 'COMMIT');

EXCEPTION WHEN OTHERS THEN
    ROLLBACK TO actualizar_vector;

    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Error en actualización de vector: ' || SQLERRM, 'ROLLBACK');

    RAISE EXCEPTION 'Error en actualización de vector: %', SQLERRM;
END $$;

COMMIT;
