-- =============================================
-- ORDEN DE EJECUCIÓN CORRECTO PARA TRANSACCIONES FACENET
-- =============================================
--
-- IMPORTANTE: Ejecutar en este orden exacto para evitar errores
-- de referencia y dependencias entre tablas.
--
-- Autor: Corrección automática del sistema
-- Fecha: Junio 2025
-- =============================================

/\*
ORDEN CORRECTO DE EJECUCIÓN:

1. schema.sql (Crear estructura de base de datos)
2. datos_iniciales.sql (Insertar datos maestros requeridos)
3. tx1_creacion_dispositivo.sql (Crear dispositivos adicionales)
4. tx2_registro_usuario.sql (Registrar usuarios y vectores faciales)
5. tx8_acceso_correcto.sql (Registrar accesos exitosos)
6. tx3_acceso_fallido.sql (Registrar accesos fallidos)
7. tx6_usuario_acceso.sql (Consultar accesos de usuario - solo lectura)
8. tx4_actualizacion_vector.sql (Actualizar vectores faciales existentes)
9. tx5_desactivacion_dispositivo.sql (Desactivar dispositivos)
10. tx9_edicion_dispositivo.sql (Editar información de dispositivos)
11. tx7_eliminacion_usuario.sql (Eliminar usuarios - cascada)
12. tx10_eliminacion_dispositivo.sql (Eliminar dispositivos sin registros)

JUSTIFICACIÓN DEL ORDEN:

✅ CREACIÓN PRIMERO:

- Schema y datos iniciales establecen la base
- Dispositivos y usuarios deben existir antes de operaciones

✅ OPERACIONES NORMALES:

- Accesos (exitosos/fallidos) requieren usuarios y dispositivos existentes
- Consultas necesitan datos previos para mostrar

✅ ACTUALIZACIONES:

- Modificaciones de datos existentes
- Cambios de estado de dispositivos

✅ ELIMINACIONES AL FINAL:

- Usuarios primero (para mantener integridad referencial)
- Dispositivos sin registros asociados al final

NOTAS IMPORTANTES:

- Todas las inconsistencias de nombres de tablas han sido corregidas
- Se agregaron datos iniciales necesarios (tipos de usuario, dispositivos base)
- TX6 fue reescrita completamente para usar sintaxis correcta de PL/pgSQL
- TX9 cambió de creación a edición de dispositivo (más lógico)
- Se mantuvieron los niveles de aislamiento y justificaciones ACID originales
  \*/
