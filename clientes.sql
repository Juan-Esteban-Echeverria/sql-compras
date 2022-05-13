-- 0. Creacion de la base de datos (cliente)
CREATE DATABASE clientes
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

----------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. Cargar el respaldo de la base de datos unidad2.sql. (Desde CMD)
    cd C:\Program Files\PostgreSQL\14\bin
    C:\Program Files\PostgreSQL\14\bin>psql -U postgres -h localhost -p 5432 clientes <"C:\Program Files\PostgreSQL\clientes\unidad2.sql"

----------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Compra del usuario01
    BEGIN;
        INSERT INTO compra (id, cliente_id, fecha)
        VALUES (33, 1, '09-12-2021');

        INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
        VALUES (43, 9, 33, 5);

        UPDATE producto set stock = stock - 5
        WHERE id = 9;
    COMMIT;

-- 2. Consulta a la tabla producto (el stock fue descontado correctamente)
    select * from producto
    where id = 9;

----------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Compras del usuario01
    --(compra producto 1)
    BEGIN;
		INSERT INTO compra (id, cliente_id, fecha)
        VALUES (34, 2, '09-12-2021');

        INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
        VALUES (44, 1, 34, 3);
		
		UPDATE producto set stock = stock - 3
        WHERE id = 1;
    COMMIT;

    --(compra producto 2)
    BEGIN;
		INSERT INTO compra (id, cliente_id, fecha)
        VALUES (35, 2, '09-12-2021');

        INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
        VALUES (45, 2, 35, 3);
		
		UPDATE producto set stock = stock - 3
        WHERE id = 2;
    COMMIT;

    --(compra producto 8 FALLO DETECTADO -> ROLLBACK)
    BEGIN;
		INSERT INTO compra (id, cliente_id, fecha)
        VALUES (36, 2, '09-12-2021');

        INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
        VALUES (46, 8, 36, 3);
		
		UPDATE producto set stock = stock - 3
        WHERE id = 8;
    ROLLBACK;

    -- 3. Comprobacion de la tabla producto (La Compra fallo debido a la ausencia de stock)
    select * from producto
    where id = 8;

----------------------------------------------------------------------------------------------------------------------------------------------------

-- 4.a Consulta del estado del Auto-Commit y su desactivacion
    \echo :AUTOCOMMIT
    \set AUTOCOMMIT off

-- 4.b Insertar a un nuevo cliente
    INSERT INTO public.cliente(id, nombre, email)
	VALUES (11, 'usuario011', 'usuario011@hotmail.com');

-- 4.c Confirmar que fue agregado en la tabla cliente.
    select * from cliente
    where id = 11; 

-- 4.d Realizar un ROLLBACK.
    ROLLBACK;

-- 4.e Confirmar que se restauró la información, sin considerar la inserción delpunto b.
    select * from cliente
    where id = 11; 

-- 4.f Habilitar de nuevo el AUTOCOMMIT.
    \set AUTOCOMMIT on