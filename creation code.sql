CREATE DATABASE ��������������
ON PRIMARY
(NAME = ��������������,
FILENAME = 'D:\DB\Orders\��������������.mdf',
SIZE = 5 Mb,
FILEGROWTH = 10%)

LOG ON
(NAME = ��������������������,
FILENAME = 'D:\DB\Orders\��������������������.ldf',
SIZE = 2 Mb,
FILEGROWTH = 1 Mb)

CREATE TABLE ��������
(ID��������� int NOT NULL
IDENTITY (1,1)
CONSTRAINT prkCustomerID
PRIMARY KEY,
������������ varchar(50) NOT NULL,
����� varchar(50) NOT NULL,
������� varchar(50) NOT NULL
CONSTRAINT phoneNumber CHECK (������� LIKE ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
OR ������� LIKE ('+[0-9]([0-9][0-9][0-9][0-9])[0-9][0-9]-[0-9][0-9]-[0-9][0-9]') OR ������� LIKE ('8([0-9][0-9][0-9][0-9])[0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
OR ������� LIKE ('8([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')),
�������������� varchar(50) NOT NULL)

CREATE TABLE �����
(ID������ int NOT NULL
IDENTITY (1,1)
CONSTRAINT orderID
PRIMARY KEY,
ID��������� int NOT NULL
FOREIGN KEY REFERENCES
�������� (ID���������)
ON UPDATE CASCADE
ON DELETE CASCADE,
���������� datetime NOT NULL,
CONSTRAINT orderDate CHECK (���������� <= GetDate()) )

CREATE TABLE �����
(ID������ int NOT NULL
IDENTITY(1, 1)
CONSTRAINT productID
PRIMARY KEY,
���� float NOT NULL
CONSTRAINT price CHECK (���� >= 0),
�������� varchar(50) NOT NULL )

CREATE TABLE ��������������������
(ID������ int NOT NULL
FOREIGN KEY REFERENCES
����� (ID������)
ON UPDATE CASCADE
ON DELETE CASCADE,
�������������� varchar(50) NOT NULL,
����������������� float NOT NULL
CONSTRAINT orderPrice CHECK (����������������� >= 0)
PRIMARY KEY (ID������, ��������������) )

CREATE TABLE ������������
(ID������ int NOT NULL
FOREIGN KEY REFERENCES
����� (ID������)
ON UPDATE CASCADE
ON DELETE CASCADE,
ID������ int NOT NULL,
���������� int NOT NULL
CONSTRAINT NumCheck CHECK (���������� > 0),
�������������� varchar(50) NOT NULL,
FOREIGN KEY (ID������, ��������������) REFERENCES ��������������������(ID������, ��������������)
ON UPDATE CASCADE
ON DELETE CASCADE,
PRIMARY KEY (ID������, ID������) )


INSERT INTO ����� (����, ��������)
VALUES (1200.5, '����'),
(120, '�������'),
(2000, '������� ����'),
(25235.12, '���������'),
(15325, '�����������'),
(31596.12, '������ ���������������'),
(4563, '������� ��� ������'),
(3530, '������� ������'),
(2000, '������������ �������'),
(6545, '�������� � ������'),
(2250, '���������� ������'),
(500, '�����'),
(1000, '����� ��������� �����'),
(35000, '������'),
(2506.56, '������ �������'),
(1250, '�����'),
(1789.99, '������� ����'),
(3560, '������������ ������'),
(2540.89, '������������� ����������������'),
(800, '������ ��� ����')


INSERT INTO �������� (������������, �����, �������, ��������������)
VALUES ('��� �����', '������, ���������, �����, ����������, 199', '+7(953)485-89-25', '������ ������'),
('��� ��������', '������, ���������, �����, �����, 68�', '+7(800)200-25-05', '������ �����'),
('��� �����', '������, ���������, �����, ����������, 28', '+7(8332)46-83-88', '���� ��������'),
('��� ������', '������, ���������, �����, ����������� ��������, 1�', '+7(8332)74-04-58', '������� ��������'),
('�����������', '������, ���������, �����, ��������, 51', '+7(8332)64-76-50', '��������� �������'),
('��������� �������� ��������', '������, ���������, �����, ����������, 105', '+7(8332)48-90-82', '������ �����'),
('�����-���', '������, ���������, �����, ����������, 77', '+7(8332)57-85-78', '������� �������'),
('������� ����', '������, ���������, �����, ����� ������, 35', '+7(912)338-52-12', '������ ������'),
('�����������', '������, ���������, �����, ������, 119�', '8(800)777-77-71', '���� �������'),
('���', '������, ���������, �����, ����������� ��������, 18', '+7(8332)40-65-01', '��������� �����')

BULK INSERT ��������������������
FROM 'D:\DB\Orders\��������������.txt'
WITH
(CHECK_CONSTRAINTS,
CODEPAGE = 'ACP')

BULK INSERT �����
FROM 'D:\DB\Orders\�����.txt'
WITH
(CHECK_CONSTRAINTS)

BULK INSERT ������������
FROM 'D:\DB\Orders\������������.txt'
WITH
(CHECK_CONSTRAINTS,
CODEPAGE = 'ACP')

--����� ��������� ������� ������� ���������
CREATE VIEW InfoOrders ([��������], [����� ��������� �������])
AS
SELECT ������������, SUM(���� * ���������� + �����������������)
FROM (((�������� INNER JOIN ����� ON ��������.ID��������� = �����.ID���������)
INNER JOIN ������������ ON ������������.ID������ = �����.ID������)
INNER JOIN �������������������� ON ��������������������.ID������ = ������������.ID������ AND ��������������������.�������������� = ������������.��������������)
INNER JOIN ����� ON �����.ID������ = ��������������������.ID������
GROUP BY ������������

SELECT * FROM InfoOrders

--������ �� �������
CREATE VIEW InfoOrdersDate ([�����], [����], [���������])
AS
SELECT �����.ID������, CONVERT(nvarchar, Month(�����.����������)) + '.' + CONVERT(nvarchar, Year(�����.����������)), ���� * ���������� + ����������������� AS ���������
FROM ((����� INNER JOIN ������������ ON ������������.ID������ = �����.ID������)
INNER JOIN �������������������� ON ��������������������.ID������ = ������������.ID������ AND ��������������������.�������������� = ������������.��������������)
INNER JOIN ����� ON �����.ID������ = ��������������������.ID������

SELECT * FROM InfoOrdersDate

--��������� ������� �� �������
SELECT ����, COUNT(�����) AS �����������������, SUM(���������) AS ������������
FROM InfoOrdersDate
GROUP BY ����
ORDER BY ���� ASC

--������ � ������� �������� ��������
CREATE VIEW UsualWayOrders ([�����], [�����])
AS
SELECT ID������, ��������
FROM (������������ INNER JOIN �������������������� ON ��������������������.ID������ = ������������.ID������ AND ��������������������.�������������� = ������������.��������������)
INNER JOIN ����� ON �����.ID������ = ��������������������.ID������
WHERE ������������.�������������� = '�������'

SELECT * FROM UsualWayOrders

--���������� ������� � ������� ��������� � ������ ������
SELECT ID������, COUNT(DISTINCT �����) AS �����������������
FROM UsualWayOrders RIGHT JOIN ������������ ON UsualWayOrders.����� = ������������.ID������
GROUP BY ID������

--TOP, ����������, �������� ��������
SELECT TOP 5 ��������, ����
FROM �����
WHERE ���� > 500 AND ���� < 2000
ORDER BY ���� DESC

--������, �� ���������
SELECT ������������, �������
FROM ��������
WHERE ������� LIKE ('%([0-9][0-9][0-9][0-9])%') AND
����� IN ('������, ���������, �����, ����������, 105',
'������, ���������, �����, ����������, 77', '������, ���������, �����, ����� ������, 35')

--������������ ������ ����, ������� �������, ������� ���������� ������
SELECT ������������ AS ��������, CONVERT(nvarchar, ����������) + ' ' + �������� AS �����
FROM �����, ������������, ��������, �����
WHERE ���������� > 5 AND �����.ID������ = ������������.ID������ AND ������������.ID������ = �����.ID������
AND �����.ID��������� = ��������.ID���������

--����������
SELECT ������������ AS ��������, �������� AS �����, ��������������������.��������������, ��������� AS �����, ����������
FROM (((�������� INNER JOIN ����� ON ��������.ID��������� = �����.ID���������)
INNER JOIN ������������ ON ������������.ID������ = �����.ID������)
INNER JOIN �������������������� ON ��������������������.ID������ = ������������.ID������ AND ��������������������.�������������� = ������������.��������������)
INNER JOIN ����� ON ��������������������.ID������ = �����.ID������
WHERE ��������� > (SELECT AVG(���������) FROM ������������)
ORDER BY ��������� ASC

--� ������������ �������
SELECT �������� AS �����, COUNT(������������.ID������) AS �������
FROM (������������ INNER JOIN �������������������� ON ��������������������.ID������ = ������������.ID������
AND ��������������������.�������������� = ������������.��������������) RIGHT JOIN
����� ON �����.ID������ = ��������������������.ID������
GROUP BY ��������

--��������� ������� � ������ � ������ ���������� � ��������
EXEC Order_Price 11
--������� �������� ��� ������/���� �������
EXEC OrderAvailability 41
--������ � ����� �������, ��� ��������� ��������
EXEC ProductsPrice 2000
--������ ������� � ������
EXEC ProductsList 17
--���������� ���������� ���� ������ � ������ �������
EXEC ProductSells '2019-01-01', '2022-01-01'
--�������, ���������� ����� n ���� ������ k
EXEC GetClients 5, 51


ALTER TRIGGER [dbo].[Adress]
ON [dbo].[��������]
FOR INSERT, UPDATE
AS
	DECLARE @adress varchar(200) = REPLACE((SELECT ����� FROM Inserted), ' ', '')
	IF @adress NOT LIKE '_%,_%,_%,_%,_%'
	BEGIN
		ROLLBACK TRAN
		RAISERROR('����� ������ ���� �� �����: [������, �������, �����, �����, ���]', 3, 1)
	END
	ELSE IF SUBSTRING(@adress, 0, CHARINDEX(',', @adress)) IN ('���������', '����� ��������', '����', '�������')
	BEGIN
		ROLLBACK TRAN
		RAISERROR('�������� � ��������, ����� ��������, ����, ������� ���', 3, 2)
	END

ALTER TRIGGER [dbo].[EmptyCustomers]
ON [dbo].[�����]
FOR DELETE
AS
	IF NOT EXISTS
	(SELECT ID������
	FROM �����
	WHERE ID��������� = (SELECT ID��������� FROM deleted))
	BEGIN
		DELETE ��������
		WHERE ID��������� = (SELECT ID��������� FROM deleted)
	END

ALTER TRIGGER [dbo].[EmptyOrders]
ON [dbo].[������������]
FOR DELETE
AS
	IF NOT EXISTS
	(SELECT ID������
	FROM ������������
	WHERE ID������ = (SELECT ID������ FROM deleted))
	BEGIN
		DELETE �����
		WHERE ID������ = (SELECT ID������ FROM deleted)
	END


ALTER PROCEDURE [dbo].[GetClients]
	@number int,
	@productID int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ������������ AS ��������, ����������
	FROM (�������� INNER JOIN ����� ON ��������.ID��������� = �����.ID���������) INNER JOIN
	������������ ON ������������.ID������ = �����.ID������
	WHERE ID������ = @productID AND ���������� >= @number
END

ALTER PROCEDURE [dbo].[Order_Price]
		@ID������ int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT �������� AS �����, ���� * ���������� + ����������������� AS ���������
	FROM (������������ INNER JOIN �������������������� ON ������������.ID������ = ��������������������.ID������
	AND ������������.�������������� = ��������������������.��������������)
	INNER JOIN ����� ON ��������������������.ID������ = �����.ID������
	WHERE ������������.ID������ = @ID������
END

ALTER PROCEDURE [dbo].[OrderAvailability]
		@ID������ int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @ID������ IS NULL
	BEGIN
		SELECT ��������, COUNT(DISTINCT ��������������������.ID������) AS ���������������
		FROM ����� LEFT JOIN �������������������� ON �����.ID������ = ��������������������.ID������
		GROUP BY ��������
	END
	ELSE
	BEGIN
		SELECT ��������, COUNT(DISTINCT ��������������������.ID������) AS ���������������
		FROM ����� LEFT JOIN �������������������� ON �����.ID������ = ��������������������.ID������
		WHERE �����.ID������ = @ID������
		GROUP BY ��������
	END
END

ALTER PROCEDURE [dbo].[ProductSells]
		@leftBorder datetime,
		@rightBorder datetime
AS	
BEGIN
	SET NOCOUNT ON;

	SELECT �������� AS �����, SUM(������������.����������) AS �������
	FROM ((����� INNER JOIN ������������ ON �����.ID������ = ������������.ID������ AND �����.���������� >= @leftBorder AND �����.���������� <= @rightBorder)
	INNER JOIN �������������������� ON ������������.ID������ = ��������������������.ID������ AND ������������.�������������� = ��������������������.��������������)
	INNER JOIN ����� ON �����.ID������ = ��������������������.ID������
	GROUP BY ��������
END

ALTER PROCEDURE [dbo].[ProductsList]
	@order int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT �������� AS �����, ����������, ������������.��������������
	FROM (������������ INNER JOIN �������������������� ON ������������.ID������ = ��������������������.ID������ AND ID������ = @order
	AND ������������.�������������� = ��������������������.��������������) INNER JOIN ����� ON
	�����.ID������ = ��������������������.ID������
END

ALTER PROCEDURE [dbo].[ProductsPrice]
		@price float
AS	
BEGIN
	SET NOCOUNT ON;

	SELECT �������� AS �����, ����
	FROM �����
	WHERE ���� > @price
END
