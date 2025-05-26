-- Nivel de aislamiento: READ COMMITTED
-- Justificación: Asegura que estamos leyendo un estado válido de la base de datos.

BEGIN;

SAVEPOINT inicio_acceso;

DO $$
DECLARE
    v_id_usuario INT;
BEGIN
    -- Verificar si el usuario existe
    SELECT id_usuario INTO v_id_usuario
    FROM usuarios
    WHERE cedula = '1316229739';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Usuario no encontrado';
    END IF;

    -- Registrar el acceso exitoso
    INSERT INTO registros_acceso (id_usuario, id_dispositivo, exito)
    VALUES (v_id_usuario, 1, TRUE);

    -- Registrar transacción exitosa
    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Registro de acceso exitoso', 'COMMIT');

EXCEPTION WHEN OTHERS THEN
    -- En caso de error, revertimos
    ROLLBACK TO inicio_acceso;
    
    -- Registramos el error
    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Error en registro de acceso: ' || SQLERRM, 'ROLLBACK');
    
    RAISE EXCEPTION 'Error en la transacción: %', SQLERRM;
END $$;

COMMIT;
