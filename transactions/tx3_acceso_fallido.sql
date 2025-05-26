
-- Nivel de aislamiento: READ COMMITTED
-- Justificación: La transacción es simple y no afecta otras concurrencias.

BEGIN;

SAVEPOINT intento_fallido;

DO $$
BEGIN
    -- Acceso fallido, sin ID de usuario (rostro no reconocido)
    INSERT INTO registros_acceso (id_usuario, id_dispositivo, exito, motivo_fallo)
    VALUES (NULL, 1, FALSE, 'No se pudo reconocer el rostro');

    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Registro de intento fallido sin usuario', 'COMMIT');

EXCEPTION WHEN OTHERS THEN
    ROLLBACK TO intento_fallido;

    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Error al registrar acceso fallido: ' || SQLERRM, 'ROLLBACK');

    RAISE EXCEPTION 'Error en intento fallido: %', SQLERRM;
END $$;

COMMIT;

