-- Nivel de aislamiento: SERIALIZABLE
-- Justificación: Evita que dos accesos se registren al mismo tiempo por condiciones de carrera.

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SAVEPOINT control_concurrencia;

DO $$
DECLARE
    v_id_usuario INT;
    v_count INT;
BEGIN
    SELECT id_usuario INTO v_id_usuario FROM usuarios WHERE cedula = '1316229739';

    -- Verificar si ya hay un acceso en el último minuto
    SELECT COUNT(*) INTO v_count FROM registros_acceso
    WHERE id_usuario = v_id_usuario
    AND fecha_acceso > NOW() - INTERVAL '1 minute';

    IF v_count = 0 THEN
        -- Insertar acceso si no hubo recientemente
        INSERT INTO registros_acceso (id_usuario, id_dispositivo, exito)
        VALUES (v_id_usuario, 1, TRUE);

        INSERT INTO transacciones_log (descripcion, estado_tx)
        VALUES ('Acceso registrado bajo control de concurrencia', 'COMMIT');
    ELSE
        INSERT INTO transacciones_log (descripcion, estado_tx)
        VALUES ('Acceso ya registrado recientemente, no duplicado', 'COMMIT');
    END IF;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK TO control_concurrencia;

    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Error en control de concurrencia: ' || SQLERRM, 'ROLLBACK');

    RAISE EXCEPTION 'Error en concurrencia: %', SQLERRM;
END $$;

COMMIT;
