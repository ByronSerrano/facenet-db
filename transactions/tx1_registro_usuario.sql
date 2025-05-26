-- Nivel de aislamiento: READ COMMITTED (por defecto)
-- Justificación: No hay riesgo de lecturas sucias, ya que estamos insertando datos nuevos.

BEGIN;

SAVEPOINT inicio_registro;

DO $$
DECLARE
    v_id_usuario INT;
BEGIN
    -- Registro del nuevo usuario
    INSERT INTO usuarios (cedula, nombres, apellidos, tipo_usuario, correo_institucional)
    VALUES ('1316229739', 'Johannes', 'Carofilis', 'estudiante', 'jcarofilis9739@pucesm.edu.ec')
    RETURNING id_usuario INTO v_id_usuario;

    -- Registro del vector facial asociado
    INSERT INTO vectores_faciales (id_usuario, vector)
    VALUES (v_id_usuario, ARRAY[0.1, 0.2, 0.3, 0.4]);

    -- Registro de transacción exitosa
    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Registro de usuario y vector facial exitoso', 'COMMIT');

EXCEPTION WHEN OTHERS THEN
    -- En caso de error, revertimos todo
    ROLLBACK TO SAVEPOINT inicio_registro;
    
    -- Registramos el error
    INSERT INTO transacciones_log (descripcion, estado_tx)
    VALUES ('Error en registro de usuario: ' || SQLERRM, 'ROLLBACK');
    
    RAISE EXCEPTION 'Error en la transacción: %', SQLERRM;
END $$;

COMMIT;
