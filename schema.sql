-- ========================================
-- Esquema de Base de Datos para Sistema de Seguridad con Reconocimiento Facial (FACENET)
-- Pontificia Universidad Católica del Ecuador Sede Manabí - Proyecto de Gestión de la Información
-- Autores: Byron Serrano, Johannes Carofilis y Stiven Guanoquiza
-- ========================================

-- Tabla: usuarios
-- Almacena información personal de los usuarios registrados en el sistema
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    cedula VARCHAR(10) UNIQUE NOT NULL CHECK (LENGTH(cedula) = 10),
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('estudiante', 'docente', 'administrativo', 'visitante')),
    correo_institucional VARCHAR(100) UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Fecha en que se registró al usuario
);

-- Tabla: vectores_faciales
-- Contiene los vectores de características del rostro de cada usuario
CREATE TABLE vectores_faciales (
    id_vector SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    vector FLOAT8[] NOT NULL, -- Array de floats que representa el rostro (embedding)
    fecha_almacenamiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    version_algoritmo VARCHAR(50) DEFAULT 'FaceNet-v1' -- Algoritmo usado para generar el vector
);

-- Tabla: dispositivos
-- Dispositivos físicos como cámaras o lectores instalados en la universidad
CREATE TABLE dispositivos (
    id_dispositivo SERIAL PRIMARY KEY,
    ubicacion VARCHAR(100) NOT NULL, -- Ej: "Primera Entrada"
    descripcion TEXT,
    estado BOOLEAN DEFAULT TRUE, -- TRUE = operativo, FALSE = en mantenimiento o desactivado
    fecha_instalacion DATE
);

-- Tabla: registros_acceso
-- Registro de cada intento de acceso, exitoso o fallido
CREATE TABLE registros_acceso (
    id_acceso SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario),
    id_dispositivo INT REFERENCES dispositivos(id_dispositivo),
    fecha_acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    exito BOOLEAN NOT NULL, -- TRUE si el reconocimiento fue exitoso
    motivo_fallo TEXT -- Si exito=FALSE, describe el motivo: "No reconocido", "Rostro cubierto", etc.
);

-- Tabla: logs_eventos
-- Registro de eventos internos del sistema como errores, advertencias, etc.
CREATE TABLE logs_eventos (
    id_log SERIAL PRIMARY KEY,
    evento VARCHAR(255) NOT NULL,
    descripcion TEXT,
    nivel VARCHAR(10) NOT NULL CHECK (nivel IN ('INFO', 'WARNING', 'ERROR')),
    fecha_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: transacciones_log
-- Guarda el estado de transacciones realizadas durante pruebas de ACID
CREATE TABLE transacciones_log (
    id_tx SERIAL PRIMARY KEY,
    descripcion TEXT,
    estado_tx VARCHAR(10) NOT NULL CHECK (estado_tx IN ('COMMIT', 'ROLLBACK', 'ERROR')),
    fecha_tx TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
