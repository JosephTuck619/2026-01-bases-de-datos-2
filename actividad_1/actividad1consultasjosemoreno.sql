-- SUBCONSULTAS

-- Obtener los nombres y apellidos de los usuarios que han reservado un libro de la categoría "Fiction".
SELECT FirstName, LastName
FROM Users
WHERE UserID IN (
    SELECT UserID
    FROM Reservations
    WHERE BookID IN (
        SELECT BookID
        FROM Books
        WHERE CategoryID = (
            SELECT CategoryID
            FROM BookCategories
            WHERE CategoryName = 'Fiction'
        )
    )
);

-- Mostrar el título y autor de los libros que están prestados.
SELECT Title, Author
FROM Books
WHERE BookID IN (
    SELECT BookID FROM Loans
);

-- OPERADORES DE CONJUNTO

-- Encontrar los títulos de los libros que han sido reservados, pero no prestados.
SELECT Title
FROM Books
WHERE BookID IN (SELECT BookID FROM Reservations)
AND BookID NOT IN (SELECT BookID FROM Loans);

-- Encontrar los títulos de los libros que han sido prestados, pero no reservados.
SELECT Title
FROM Books
WHERE BookID IN (SELECT BookID FROM Loans)
AND BookID NOT IN (SELECT BookID FROM Reservations);

-- EXPRESIONES CONDICIONALES

-- Mostrar un listado de todos los libros con un estado: "Disponible" si AvailableCopies > 0, o "Agotado" si no hay copias disponibles.
SELECT Title,
       CASE
           WHEN AvailableCopies > 0 THEN 'Disponible'
           ELSE 'Agotado'
       END AS Estado
FROM Books;

-- Mostrar los usuarios y clasifícalos como "Activo" si tienen libros prestados y "Sin actividad" si no.
SELECT FirstName, LastName,
       CASE
           WHEN UserID IN (SELECT UserID FROM Loans) THEN 'Activo'
           ELSE 'Sin actividad'
       END AS EstadoUsuario
FROM Users;

-- ANÁLISIS AGREGADO CON GROUP BY Y HAVING

-- Encontrar las categorías con más de 3 libros.
SELECT bc.CategoryName, COUNT(b.BookID)
FROM BookCategories bc
INNER JOIN Books b ON bc.CategoryID = b.CategoryID
GROUP BY bc.CategoryID, bc.CategoryName
HAVING COUNT(b.BookID) > 3;

-- Mostrar los usuarios que tienen más de 2 libros reservados.
SELECT u.FirstName, u.LastName, COUNT(r.ReservationID)
FROM Users u
INNER JOIN Reservations r ON u.UserID = r.UserID
GROUP BY u.UserID, u.FirstName, u.LastName
HAVING COUNT(r.ReservationID) > 2;

-- INNER JOIN

-- Mostrar un listado de los nombres de usuarios y los títulos de los libros que han sido prestados.
SELECT u.FirstName, u.LastName, b.Title
FROM Users u
INNER JOIN Loans l ON u.UserID = l.UserID
INNER JOIN Books b ON l.BookID = b.BookID;

-- Mostrar los nombres de usuarios y los títulos de los libros que han reservado.
SELECT u.FirstName, u.LastName, b.Title
FROM Users u
INNER JOIN Reservations r ON u.UserID = r.UserID
INNER JOIN Books b ON r.BookID = b.BookID;

-- LEFT JOIN

-- Listar todos los libros junto con el nombre del usuario que los reservó, si es que existe una reserva.
SELECT b.Title, u.FirstName, u.LastName
FROM Books b
LEFT JOIN Reservations r ON b.BookID = r.BookID
LEFT JOIN Users u ON r.UserID = u.UserID;

-- Listar todos los usuarios junto con el título del libro prestado, si existe un préstamo.
SELECT u.FirstName, u.LastName, b.Title
FROM Users u
LEFT JOIN Loans l ON u.UserID = l.UserID
LEFT JOIN Books b ON l.BookID = b.BookID;

-- RIGHT JOIN

-- Listar todos los libros junto con los nombres de los usuarios que los han reservado, incluyendo los libros que no tienen reservas.
SELECT b.Title, u.FirstName, u.LastName
FROM Reservations r
RIGHT JOIN Books b ON r.BookID = b.BookID
LEFT JOIN Users u ON r.UserID = u.UserID;

-- Lista todos los usuarios junto con los títulos de los libros prestados, incluyendo los usuarios que no han realizado préstamos.
SELECT u.FirstName, u.LastName, b.Title
FROM Loans l
RIGHT JOIN Users u ON l.UserID = u.UserID
LEFT JOIN Books b ON l.BookID = b.BookID;

-- FUNCIONES ESPECIALIZADAS

-- Mostrar un listado de los títulos de los libros en mayúsculas.
SELECT UPPER(Title)
FROM Books;

-- Mostrar los nombres de los usuarios concatenados en un solo campo (Nombre Completo).
SELECT CONCAT(FirstName, ' ', LastName)
FROM Users;

-- FUNCIONES DE FECHA

-- Calcular el número de días que han pasado desde que se reservó cada libro.
SELECT ReservationID,
       DATEDIFF(CURDATE(), ReservationDate)
FROM Reservations;

-- Mostrar los préstamos que están pendientes de devolución (ReturnDate es NULL).
SELECT *
FROM Loans
WHERE ReturnDate IS NULL;

-- FUNCIONES DE AGREGACIÓN

-- Calcular el total de copias disponibles para cada categoría.
SELECT bc.CategoryName, SUM(b.AvailableCopies)
FROM BookCategories bc
INNER JOIN Books b ON bc.CategoryID = b.CategoryID
GROUP BY bc.CategoryID, bc.CategoryName;

-- Encontrar el número total de libros prestados por cada usuario.
SELECT u.FirstName, u.LastName, COUNT(l.LoanID)
FROM Users u
LEFT JOIN Loans l ON u.UserID = l.UserID
GROUP BY u.UserID, u.FirstName, u.LastName;