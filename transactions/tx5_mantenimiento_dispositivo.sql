-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Evita conflictos sin necesidad de bloqueos prolongados.

BEGIN;

SAVEPOINT mantenimiento_dispositivo;

DO $$
BEGIN
    -- Cambiar el estado del dispositivo a inactivo
    UPDATE dispositivos SET estado = FALSE WHERE id_dispositivo = 1;

    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Dispositivo 1 desactivado por mantenimiento', 'COMMIT');

EXCEPTION WHEN OTHERS THEN
    ROLLBACK TO mantenimiento_dispositivo;

    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Error en desactivación de dispositivo: ' || SQLERRM, 'ROLLBACK');

    RAISE EXCEPTION 'Error en mantenimiento de dispositivo: %', SQLERRM;
END $$;

COMMIT;
