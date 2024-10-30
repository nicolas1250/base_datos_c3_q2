DROP DATABASE if exists db_security;
CREATE DATABASE db_security;
use db_security;
-- Tabla de roles
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    route VARCHAR(255),
    status VARCHAR(20) NOT NULL CHECK (status IN ('activo', 'inactivo'))
);

-- Tabla de módulos
CREATE TABLE modules (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    route VARCHAR(255) NOT NULL
);

-- Tabla de vistas
CREATE TABLE views (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    route VARCHAR(255) NOT NULL
);

-- Tabla intermedia para relacionar roles y vistas
CREATE TABLE role_views (
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    view_id INT REFERENCES views(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, view_id)
);

-- Tabla intermedia para relacionar roles y módulos
CREATE TABLE role_modules (
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    module_id INT REFERENCES modules(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, module_id)
);
-- Insertar datos en la tabla roles
INSERT INTO roles (name, route, status) VALUES 
('Administrador', '/admin', 'activo'),
('Editor', '/editor', 'activo'),
('Visitante', '/visitante', 'inactivo');

-- Insertar datos en la tabla modules
INSERT INTO modules (name, route) VALUES 
('Gestión de Usuarios', '/usuarios'),
('Informes', '/informes'),
('Configuraciones', '/configuraciones');

-- Insertar datos en la tabla views
INSERT INTO views (name, route) VALUES 
('Ver Usuarios', '/usuarios/ver'),
('Editar Usuarios', '/usuarios/editar'),
('Ver Informes', '/informes/ver'),
('Configuración General', '/configuraciones/general');

-- Insertar datos en la tabla role_views
INSERT INTO role_views (role_id, view_id) VALUES 
(1, 1),  -- Administrador tiene acceso a "Ver Usuarios"
(1, 2),  -- Administrador tiene acceso a "Editar Usuarios"
(2, 1),  -- Editor tiene acceso a "Ver Usuarios"
(2, 2),  -- Editor tiene acceso a "Editar Usuarios"
(2, 3);  -- Editor tiene acceso a "Ver Informes"

-- Insertar datos en la tabla role_modules
INSERT INTO role_modules (role_id, module_id) VALUES 
(1, 1),  -- Administrador tiene acceso al módulo "Gestión de Usuarios"
(1, 2),  -- Administrador tiene acceso al módulo "Informes"
(2, 1);  -- Editor tiene acceso al módulo "Gestión de Usuarios"

SELECT 
    r.name AS rol,
    r.route AS ruta,
    m.name AS modulo,
    m.route AS paquete
FROM 
    roles r
LEFT JOIN 
    role_views rv ON r.id = rv.role_id
LEFT JOIN 
    views v ON rv.view_id = v.id
LEFT JOIN 
    role_modules rm ON r.id = rm.role_id
LEFT JOIN 
    modules m ON rm.module_id = m.id
WHERE 
    r.status = 'activo'
ORDER BY 
    r.name, m.name;  -- Ordenar primero por nombre de rol, luego por nombre de módulo
