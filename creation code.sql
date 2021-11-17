CREATE DATABASE ВедениеЗаказов
ON PRIMARY
(NAME = ВедениеЗаказов,
FILENAME = 'D:\DB\Orders\ВедениеЗаказов.mdf',
SIZE = 5 Mb,
FILEGROWTH = 10%)

LOG ON
(NAME = ВедениеЗаказовЖурнал,
FILENAME = 'D:\DB\Orders\ВедениеЗазаковЖурнал.ldf',
SIZE = 2 Mb,
FILEGROWTH = 1 Mb)

CREATE TABLE Заказчик
(IDЗаказчика int NOT NULL
IDENTITY (1,1)
CONSTRAINT prkCustomerID
PRIMARY KEY,
Наименование varchar(50) NOT NULL,
Адрес varchar(50) NOT NULL,
Телефон varchar(50) NOT NULL
CONSTRAINT phoneNumber CHECK (Телефон LIKE ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
OR Телефон LIKE ('+[0-9]([0-9][0-9][0-9][0-9])[0-9][0-9]-[0-9][0-9]-[0-9][0-9]') OR Телефон LIKE ('8([0-9][0-9][0-9][0-9])[0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
OR Телефон LIKE ('8([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')),
КонтактноеЛицо varchar(50) NOT NULL)

CREATE TABLE Заказ
(IDЗаказа int NOT NULL
IDENTITY (1,1)
CONSTRAINT orderID
PRIMARY KEY,
IDЗаказчика int NOT NULL
FOREIGN KEY REFERENCES
Заказчик (IDЗаказчика)
ON UPDATE CASCADE
ON DELETE CASCADE,
ДатаЗаказа datetime NOT NULL,
CONSTRAINT orderDate CHECK (ДатаЗаказа <= GetDate()) )

CREATE TABLE Товар
(IDТовара int NOT NULL
IDENTITY(1, 1)
CONSTRAINT productID
PRIMARY KEY,
Цена float NOT NULL
CONSTRAINT price CHECK (Цена >= 0),
Название varchar(50) NOT NULL )

CREATE TABLE СпособДоставкиТовара
(IDТовара int NOT NULL
FOREIGN KEY REFERENCES
Товар (IDТовара)
ON UPDATE CASCADE
ON DELETE CASCADE,
СпособДоставки varchar(50) NOT NULL,
СтоимостьДоставки float NOT NULL
CONSTRAINT orderPrice CHECK (СтоимостьДоставки >= 0)
PRIMARY KEY (IDТовара, СпособДоставки) )

CREATE TABLE ТоварВЗаказе
(IDЗаказа int NOT NULL
FOREIGN KEY REFERENCES
Заказ (IDЗаказа)
ON UPDATE CASCADE
ON DELETE CASCADE,
IDТовара int NOT NULL,
Количество int NOT NULL
CONSTRAINT NumCheck CHECK (Количество > 0),
СпособДоставки varchar(50) NOT NULL,
FOREIGN KEY (IDТовара, СпособДоставки) REFERENCES СпособДоставкиТовара(IDТовара, СпособДоставки)
ON UPDATE CASCADE
ON DELETE CASCADE,
PRIMARY KEY (IDЗаказа, IDТовара) )


INSERT INTO Товар (Цена, Название)
VALUES (1200.5, 'Ваза'),
(120, 'Степлер'),
(2000, 'Офисный стул'),
(25235.12, 'Велосипед'),
(15325, 'Кондиционер'),
(31596.12, 'Камера видеонаблюдения'),
(4563, 'Вешалка для одежды'),
(3530, 'Рабочий костюм'),
(2000, 'Компьютерный монитор'),
(6545, 'Запчасти к станку'),
(2250, 'Спортивный костюм'),
(500, 'Лампа'),
(1000, 'Набор шариковых ручек'),
(35000, 'Станок'),
(2506.56, 'Медные провода'),
(1250, 'Тиски'),
(1789.99, 'Офисный стол'),
(3560, 'Керамическая плитка'),
(2540.89, 'Автомобильный видеорегистратор'),
(800, 'Коврик для мыши')


INSERT INTO Заказчик (Наименование, Адрес, Телефон, КонтактноеЛицо)
VALUES ('ООО Грант', 'Россия, Кировская, Киров, Московская, 199', '+7(953)485-89-25', 'Никита Земцов'),
('ЗАО Кристалл', 'Россия, Кировская, Киров, Щорса, 68Г', '+7(800)200-25-05', 'Сергей Быков'),
('СПБ Сфера', 'Россия, Кировская, Киров, Дерендяева, 28', '+7(8332)46-83-88', 'Юлия Тарасова'),
('ВМП Авитек', 'Россия, Кировская, Киров, Октябрьский проспект, 1А', '+7(8332)74-04-58', 'Дмитрий Санников'),
('Кировэнерго', 'Россия, Кировская, Киров, Спасская, 51', '+7(8332)64-76-50', 'Александр Милюков'),
('Кировский молочный комбинат', 'Россия, Кировская, Киров, Воровского, 105', '+7(8332)48-90-82', 'Андрей Малых'),
('Вятка-ЦУМ', 'Россия, Кировская, Киров, Воровского, 77', '+7(8332)57-85-78', 'Алексей Никитин'),
('Частное лицо', 'Россия, Кировская, Киров, Карла Маркса, 35', '+7(912)338-52-12', 'Максим Зайцев'),
('Спортмастер', 'Россия, Кировская, Киров, Ленина, 119А', '8(800)777-77-71', 'Артём Тарасов'),
('ОЦМ', 'Россия, Кировская, Киров, Октябрьский проспект, 18', '+7(8332)40-65-01', 'Александр Боков')

BULK INSERT СпособДоставкиТовара
FROM 'D:\DB\Orders\СпособДоставки.txt'
WITH
(CHECK_CONSTRAINTS,
CODEPAGE = 'ACP')

BULK INSERT Заказ
FROM 'D:\DB\Orders\Заказ.txt'
WITH
(CHECK_CONSTRAINTS)

BULK INSERT ТоварВЗаказе
FROM 'D:\DB\Orders\ТоварВЗаказе.txt'
WITH
(CHECK_CONSTRAINTS,
CODEPAGE = 'ACP')

--Общая стоимость заказов каждого заказчика
CREATE VIEW InfoOrders ([Заказчик], [Общая стоимость заказов])
AS
SELECT Наименование, SUM(Цена * Количество + СтоимостьДоставки)
FROM (((Заказчик INNER JOIN Заказ ON Заказчик.IDЗаказчика = Заказ.IDЗаказчика)
INNER JOIN ТоварВЗаказе ON ТоварВЗаказе.IDЗаказа = Заказ.IDЗаказа)
INNER JOIN СпособДоставкиТовара ON СпособДоставкиТовара.IDТовара = ТоварВЗаказе.IDТовара AND СпособДоставкиТовара.СпособДоставки = ТоварВЗаказе.СпособДоставки)
INNER JOIN Товар ON Товар.IDТовара = СпособДоставкиТовара.IDТовара
GROUP BY Наименование

SELECT * FROM InfoOrders

--Заказы по месяцам
CREATE VIEW InfoOrdersDate ([Номер], [Дата], [Стоимость])
AS
SELECT Заказ.IDЗаказа, CONVERT(nvarchar, Month(Заказ.ДатаЗаказа)) + '.' + CONVERT(nvarchar, Year(Заказ.ДатаЗаказа)), Цена * Количество + СтоимостьДоставки AS Стоимость
FROM ((Заказ INNER JOIN ТоварВЗаказе ON ТоварВЗаказе.IDЗаказа = Заказ.IDЗаказа)
INNER JOIN СпособДоставкиТовара ON СпособДоставкиТовара.IDТовара = ТоварВЗаказе.IDТовара AND СпособДоставкиТовара.СпособДоставки = ТоварВЗаказе.СпособДоставки)
INNER JOIN Товар ON Товар.IDТовара = СпособДоставкиТовара.IDТовара

SELECT * FROM InfoOrdersDate

--Стоимость заказов по месяцам
SELECT Дата, COUNT(Номер) AS КоличествоЗаказов, SUM(Стоимость) AS СуммаЗаказов
FROM InfoOrdersDate
GROUP BY Дата
ORDER BY Дата ASC

--товары с обычным способом доставки
CREATE VIEW UsualWayOrders ([Заказ], [Товар])
AS
SELECT IDЗаказа, Название
FROM (ТоварВЗаказе INNER JOIN СпособДоставкиТовара ON СпособДоставкиТовара.IDТовара = ТоварВЗаказе.IDТовара AND СпособДоставкиТовара.СпособДоставки = ТоварВЗаказе.СпособДоставки)
INNER JOIN Товар ON Товар.IDТовара = СпособДоставкиТовара.IDТовара
WHERE ТоварВЗаказе.СпособДоставки = 'Обычный'

SELECT * FROM UsualWayOrders

--Количество товаров с обычной доставкой в каждом заказе
SELECT IDЗаказа, COUNT(DISTINCT Товар) AS КоличествоТоваров
FROM UsualWayOrders RIGHT JOIN ТоварВЗаказе ON UsualWayOrders.Заказ = ТоварВЗаказе.IDЗаказа
GROUP BY IDЗаказа

--TOP, сортировка, диапазон значений
SELECT TOP 5 Название, Цена
FROM Товар
WHERE Цена > 500 AND Цена < 2000
ORDER BY Цена DESC

--Шаблон, из множества
SELECT Наименование, Телефон
FROM Заказчик
WHERE Телефон LIKE ('%([0-9][0-9][0-9][0-9])%') AND
Адрес IN ('Россия, Кировская, Киров, Воровского, 105',
'Россия, Кировская, Киров, Воровского, 77', 'Россия, Кировская, Киров, Карла Маркса, 35')

--формирование нового поля, сложное условие, неявное соединение таблиц
SELECT Наименование AS Заказчик, CONVERT(nvarchar, Количество) + ' ' + Название AS Заказ
FROM Товар, ТоварВЗаказе, Заказчик, Заказ
WHERE Количество > 5 AND Товар.IDТовара = ТоварВЗаказе.IDТовара AND ТоварВЗаказе.IDЗаказа = Заказ.IDЗаказа
AND Заказ.IDЗаказчика = Заказчик.IDЗаказчика

--подзапросы
SELECT Наименование AS Заказчик, Название AS Товар, СпособДоставкиТовара.СпособДоставки, Стоимость AS Сумма, Количество
FROM (((Заказчик INNER JOIN Заказ ON Заказчик.IDЗаказчика = Заказ.IDЗаказчика)
INNER JOIN ТоварВЗаказе ON ТоварВЗаказе.IDЗаказа = Заказ.IDЗаказа)
INNER JOIN СпособДоставкиТовара ON СпособДоставкиТовара.IDТовара = ТоварВЗаказе.IDТовара AND СпособДоставкиТовара.СпособДоставки = ТоварВЗаказе.СпособДоставки)
INNER JOIN Товар ON СпособДоставкиТовара.IDТовара = Товар.IDТовара
WHERE Стоимость > (SELECT AVG(Стоимость) FROM ТоварВЗаказе)
ORDER BY Стоимость ASC

--с группировкой записей
SELECT Название AS Товар, COUNT(ТоварВЗаказе.IDТовара) AS Заказов
FROM (ТоварВЗаказе INNER JOIN СпособДоставкиТовара ON СпособДоставкиТовара.IDТовара = ТоварВЗаказе.IDТовара
AND СпособДоставкиТовара.СпособДоставки = ТоварВЗаказе.СпособДоставки) RIGHT JOIN
Товар ON Товар.IDТовара = СпособДоставкиТовара.IDТовара
GROUP BY Название

--Стоимость товаров в заказе с учётом количества и доставки
EXEC Order_Price 11
--Наличие доставки для товара/всех товаров
EXEC OrderAvailability 41
--Товары с ценой большей, чем указанное значение
EXEC ProductsPrice 2000
--Список товаров в заказе
EXEC ProductsList 17
--Количество заказанных штук товара в период времени
EXEC ProductSells '2019-01-01', '2022-01-01'
--клиенты, заказавшие более n штук товара k
EXEC GetClients 5, 51


ALTER TRIGGER [dbo].[Adress]
ON [dbo].[Заказчик]
FOR INSERT, UPDATE
AS
	DECLARE @adress varchar(200) = REPLACE((SELECT Адрес FROM Inserted), ' ', '')
	IF @adress NOT LIKE '_%,_%,_%,_%,_%'
	BEGIN
		ROLLBACK TRAN
		RAISERROR('Адрес должен быть по форме: [страна, область, город, улица, дом]', 3, 1)
	END
	ELSE IF SUBSTRING(@adress, 0, CHARINDEX(',', @adress)) IN ('Австралия', 'Новая Зеландия', 'КНДР', 'Боливия')
	BEGIN
		ROLLBACK TRAN
		RAISERROR('Доставки в Австралю, Новую Зеландию, КНДР, Боливию нет', 3, 2)
	END

ALTER TRIGGER [dbo].[EmptyCustomers]
ON [dbo].[Заказ]
FOR DELETE
AS
	IF NOT EXISTS
	(SELECT IDЗаказа
	FROM Заказ
	WHERE IDЗаказчика = (SELECT IDЗаказчика FROM deleted))
	BEGIN
		DELETE Заказчик
		WHERE IDЗаказчика = (SELECT IDЗаказчика FROM deleted)
	END

ALTER TRIGGER [dbo].[EmptyOrders]
ON [dbo].[ТоварВЗаказе]
FOR DELETE
AS
	IF NOT EXISTS
	(SELECT IDТовара
	FROM ТоварВЗаказе
	WHERE IDЗаказа = (SELECT IDЗаказа FROM deleted))
	BEGIN
		DELETE Заказ
		WHERE IDЗаказа = (SELECT IDЗаказа FROM deleted)
	END


ALTER PROCEDURE [dbo].[GetClients]
	@number int,
	@productID int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Наименование AS Заказчик, Количество
	FROM (Заказчик INNER JOIN Заказ ON Заказчик.IDЗаказчика = Заказ.IDЗаказчика) INNER JOIN
	ТоварВЗаказе ON ТоварВЗаказе.IDЗаказа = Заказ.IDЗаказа
	WHERE IDТовара = @productID AND Количество >= @number
END

ALTER PROCEDURE [dbo].[Order_Price]
		@IDЗаказа int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Название AS Товар, Цена * Количество + СтоимостьДоставки AS Стоимость
	FROM (ТоварВЗаказе INNER JOIN СпособДоставкиТовара ON ТоварВЗаказе.IDТовара = СпособДоставкиТовара.IDТовара
	AND ТоварВЗаказе.СпособДоставки = СпособДоставкиТовара.СпособДоставки)
	INNER JOIN Товар ON СпособДоставкиТовара.IDТовара = Товар.IDТовара
	WHERE ТоварВЗаказе.IDЗаказа = @IDЗаказа
END

ALTER PROCEDURE [dbo].[OrderAvailability]
		@IDТовара int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @IDТовара IS NULL
	BEGIN
		SELECT Название, COUNT(DISTINCT СпособДоставкиТовара.IDТовара) AS НаличиеДоставки
		FROM Товар LEFT JOIN СпособДоставкиТовара ON Товар.IDТовара = СпособДоставкиТовара.IDТовара
		GROUP BY Название
	END
	ELSE
	BEGIN
		SELECT Название, COUNT(DISTINCT СпособДоставкиТовара.IDТовара) AS НаличиеДоставки
		FROM Товар LEFT JOIN СпособДоставкиТовара ON Товар.IDТовара = СпособДоставкиТовара.IDТовара
		WHERE Товар.IDТовара = @IDТовара
		GROUP BY Название
	END
END

ALTER PROCEDURE [dbo].[ProductSells]
		@leftBorder datetime,
		@rightBorder datetime
AS	
BEGIN
	SET NOCOUNT ON;

	SELECT Название AS Товар, SUM(ТоварВЗаказе.Количество) AS Продано
	FROM ((Заказ INNER JOIN ТоварВЗаказе ON Заказ.IDЗаказа = ТоварВЗаказе.IDЗаказа AND Заказ.ДатаЗаказа >= @leftBorder AND Заказ.ДатаЗаказа <= @rightBorder)
	INNER JOIN СпособДоставкиТовара ON ТоварВЗаказе.IDТовара = СпособДоставкиТовара.IDТовара AND ТоварВЗаказе.СпособДоставки = СпособДоставкиТовара.СпособДоставки)
	INNER JOIN Товар ON Товар.IDТовара = СпособДоставкиТовара.IDТовара
	GROUP BY Название
END

ALTER PROCEDURE [dbo].[ProductsList]
	@order int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Название AS Товар, Количество, ТоварВЗаказе.СпособДоставки
	FROM (ТоварВЗаказе INNER JOIN СпособДоставкиТовара ON ТоварВЗаказе.IDТовара = СпособДоставкиТовара.IDТовара AND IDЗаказа = @order
	AND ТоварВЗаказе.СпособДоставки = СпособДоставкиТовара.СпособДоставки) INNER JOIN Товар ON
	Товар.IDТовара = СпособДоставкиТовара.IDТовара
END

ALTER PROCEDURE [dbo].[ProductsPrice]
		@price float
AS	
BEGIN
	SET NOCOUNT ON;

	SELECT Название AS Товар, Цена
	FROM Товар
	WHERE Цена > @price
END
