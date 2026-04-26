CREATE DATABASE db_library;
USE db_library;
SHOW TABLES;
SELECT * FROM Books;

CREATE USER 'lector_grupo'@'localhost' IDENTIFIED BY 'Lector123*';
GRANT SELECT ON db_library.* TO 'lector_grupo'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'lector_grupo'@'localhost';
SELECT * FROM db_library.Books;

INSERT INTO db_library.Books (Title, Author, Genre, PublicationYear, AvailableCopies, CategoryID)
VALUES ('Libro prueba', 'Autor prueba', 'Fiction', 2026, 1, 1);

UPDATE db_library.Books
SET AvailableCopies = 10
WHERE BookID = 1;

DELETE FROM db_library.Books
WHERE BookID = 1;

CREATE USER 'editor_grupo'@'localhost' IDENTIFIED BY 'Editor123*';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_library.* TO 'editor_grupo'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'editor_grupo'@'localhost';

INSERT INTO db_library.Users (FirstName, LastName, Email, PhoneNumber)
VALUES ('Jose', 'Navarro', 'jose@example.com', '3001234567');

SELECT * FROM db_library.Users;

UPDATE db_library.Users
SET PhoneNumber = '3119998888'
WHERE Email = 'jose@example.com';

SELECT * FROM db_library.Users
WHERE Email = 'jose@example.com';

DELETE FROM db_library.Users
WHERE Email = 'jose@example.com';

SELECT * FROM db_library.Users
WHERE Email = 'jose@example.com';

CREATE TABLE db_library.PruebaEditor (
    id INT PRIMARY KEY
);

DROP TABLE db_library.Books;

CREATE USER 'admin_grupo'@'localhost' IDENTIFIED BY 'Admin123*';
GRANT ALL PRIVILEGES ON db_library.* TO 'admin_grupo'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'admin_grupo'@'localhost';

CREATE TABLE db_library.TestAdmin (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    FechaRegistro DATE
);

INSERT INTO db_library.TestAdmin (Nombre, FechaRegistro)
VALUES ('Registro administrador', CURDATE());

SELECT * FROM db_library.TestAdmin;

DROP TABLE db_library.TestAdmin;