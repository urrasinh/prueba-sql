CREATE DATABASE biblioteca_db;
-- /c biblioteca_db;

CREATE TABLE socios (
    rut VARCHAR(11) PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono INT UNIQUE NOT NULL
);

CREATE TABLE libros (
    isbn BIGINT PRIMARY KEY,
    titulo VARCHAR(30) NOT NULL,
    numero_paginas INT NOT NULL
);

CREATE TABLE prestamos (
    id SERIAL PRIMARY KEY,
    rut_socio_fk VARCHAR(11) NOT NULL REFERENCES socios(rut),
    isnb_libro_fk BIGINT NOT NULL REFERENCES libros(isbn),
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE NOT NULL
);

CREATE TABLE autores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    fecha_nacimiento SMALLINT,
    fecha_muerte SMALLINT,
    tipo VARCHAR(20) NOT NULL
);

CREATE TABLE autoria (
    id SERIAL PRIMARY KEY,
    isnb_libro_fk BIGINT NOT NULL REFERENCES libros(isbn),
    id_auto_fk INT NOT NULL REFERENCES autores(id)
);

BEGIN TRANSACTION;
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('1111111-1', 'Juan', 'Soto', 'Avenida 1, Santiago', 911111111);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('2222222-2', 'Ana', 'Perez', 'Pasaje 2, Santiago', 922222222);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('3333333-3', 'Sandra', 'Aguilar', 'Avenida 2, Santiago', 933333333);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('4444444-4', 'Esteban', 'Jerez', 'Avenida 3, Santiago', 944444444);
INSERT INTO socios (rut, nombre, apellido, direccion, telefono) VALUES ('5555555-5', 'Silvana', 'Muñoz', 'Pasaje 3, Santiago', 955555555);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO libros (isbn, titulo, numero_paginas) VALUES (1111111111111, 'Cuentos de Terror', 344);
INSERT INTO libros (isbn, titulo, numero_paginas) VALUES (2222222222222, 'Poesia Contemporaneas', 167);
INSERT INTO libros (isbn, titulo, numero_paginas) VALUES (3333333333333, 'Historia de Asia', 511);
INSERT INTO libros (isbn, titulo, numero_paginas) VALUES (4444444444444, 'Manual de Mecanica', 298);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO autores (nombre, apellido, fecha_nacimiento, tipo) VALUES ('Andres', 'Ulloa', 1982, 'Principal');
INSERT INTO autores (nombre, apellido, fecha_nacimiento, fecha_muerte, tipo) VALUES ('Sergio', 'Mardones', 1950, 2012, 'Principal');
INSERT INTO autores (nombre, apellido, fecha_nacimiento, fecha_muerte, tipo) VALUES ('Jose', 'Salgado', 1968, 2020, 'Principal');
INSERT INTO autores (nombre, apellido, fecha_nacimiento, tipo) VALUES ('Ana', 'Salgado', 1972, 'Coautor');
INSERT INTO autores (nombre, apellido, fecha_nacimiento, tipo) VALUES ('Martin', 'Porta', 1976, 'Principal');
COMMIT;

BEGIN TRANSACTION;
INSERT INTO autoria (isnb_libro_fk, id_auto_fk) VALUES (1111111111111, 3);
INSERT INTO autoria (isnb_libro_fk, id_auto_fk) VALUES (1111111111111, 4);
INSERT INTO autoria (isnb_libro_fk, id_auto_fk) VALUES (2222222222222, 1);
INSERT INTO autoria (isnb_libro_fk, id_auto_fk) VALUES (3333333333333, 2);
INSERT INTO autoria (isnb_libro_fk, id_auto_fk) VALUES (4444444444444, 3);
COMMIT;


BEGIN TRANSACTION;
INSERT INTO prestamos (rut_socio_fk, isnb_libro_fk, fecha_prestamo, fecha_devolucion) VALUES ('1111111-1', 1111111111111, '20-01-2020', '27-01-2020');
INSERT INTO prestamos (rut_socio_fk, isnb_libro_fk, fecha_prestamo, fecha_devolucion) VALUES ('5555555-5', 2222222222222, '20-01-2020', '30-01-2020');
INSERT INTO prestamos (rut_socio_fk, isnb_libro_fk, fecha_prestamo, fecha_devolucion) VALUES ('3333333-3', 3333333333333, '22-01-2020', '30-01-2020');
INSERT INTO prestamos (rut_socio_fk, isnb_libro_fk, fecha_prestamo, fecha_devolucion) VALUES ('4444444-4', 4444444444444, '23-01-2020', '30-01-2020');
INSERT INTO prestamos (rut_socio_fk, isnb_libro_fk, fecha_prestamo, fecha_devolucion) VALUES ('2222222-2', 1111111111111, '27-01-2020', '04-02-2020');
INSERT INTO prestamos (rut_socio_fk, isnb_libro_fk, fecha_prestamo, fecha_devolucion) VALUES ('1111111-1', 4444444444444, '20-01-2020', '27-01-2020');
INSERT INTO prestamos (rut_socio_fk, isnb_libro_fk, fecha_prestamo, fecha_devolucion) VALUES ('3333333-3', 2222222222222, '31-01-2020', '12-02-2020');
COMMIT;

-- Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)
SELECT * FROM libros WHERE numero_paginas < 300;

-- Mostrar todos los autores que hayan nacido después del 01-01-1970. (0.5 puntos)
SELECT * FROM autores WHERE fecha_nacimiento > 1969;

-- ¿Cuál es el libro más solicitado? (0.5 puntos).

SELECT titulo, MAX(veces_pedido) AS numero_solicitudes FROM 
(SELECT COUNT(isnb_libro_fk) AS veces_pedido, isnb_libro_fk FROM prestamos GROUP BY isnb_libro_fk) as prest 
INNER JOIN libros ON isnb_libro_fk = isbn 
WHERE veces_pedido = 
(SELECT COUNT(isnb_libro_fk) as contador_libros FROM prestamos GROUP BY isnb_libro_fk ORDER BY contador_libros DESC LIMIT 1) GROUP BY titulo;

-- Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días. (0.5 puntos)
SELECT nombre, apellido, (fecha_devolucion - fecha_prestamo - 7) * 100 AS deuda FROM socios INNER JOIN prestamos ON socios.rut = prestamos.rut_socio_fk WHERE (fecha_devolucion - fecha_prestamo) > 7;