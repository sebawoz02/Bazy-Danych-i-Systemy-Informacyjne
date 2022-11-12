--1. 	
	CREATE DATABASE db_aparaty;
	CREATE USER '268491'@localhost;
	SET PASSWORD FOR '268491'@localhost=PASSWORD('Sebastian491');
	GRANT SELECT, INSERT, UPDATE ON db_aparaty.* TO '268491'@localhost;

--2.	
	CREATE TABLE Aparat (model varchar(30) NOT NULL PRIMARY KEY,
	producent int,
	matryca int,
	obiektyw int,
	typ enum('kompaktowy','lustrzanka','profesjonalny','inny'),
	FOREIGN KEY(producent) REFERENCES Producent(ID) ON DELETE CASCADE,
	FOREIGN KEY(matryca) REFERENCES Matryca(ID) ON DELETE CASCADE,
	FOREIGN KEY(obiektyw) REFERENCES Obiektyw(ID) ON DELETE CASCADE
	);

	CREATE TABLE Matryca (ID int NOT NULL AUTO_INCREMENT,
	przekatna decimal(4,2) CHECK(przekatna>=0),
	rozdzielczosc decimal(3,1) CHECK(rozdzielczosc>=0),
	typ varchar(10),
	PRIMARY KEY(ID)
	)AUTO_INCREMENT=100;

	CREATE TABLE Obiektyw(ID int NOT NULL AUTO_INCREMENT,
	model varchar(30),
	minPrzeslona float CHECK(minPrzeslona>=0),
	maxPrzeslona float CHECK(maxPrzeslona>=0),
	PRIMARY KEY(ID),
	CONSTRAINT PrzeslonaCST CHECK(minPrzeslona<maxPrzeslona)
	);

	CREATE TABLE Producent(ID int NOT NULL AUTO_INCREMENT,
	nazwa varchar(50),
	kraj varchar(20),
	PRIMARY KEY(ID)
	);

--3.	
	mysql -u 268491 -p
	
	INSERT INTO Producent (nazwa, kraj) VALUES
	( 'Agfa' , 'Chiny'), ( 'Casio', 'Niemcy'),
	( 'Canon', 'Polska'), ( 'Fujifilm', 'Chiny'),
	( 'Hewlet', 'Chiny'), ( 'Packard', 'Norwegia'),
	( 'Kodak', 'Czechy'), ('Leica', 'Chiny'),
	( 'Nikon', 'Japonia'), ('Olympus', 'Grecja'),
	( 'Panasonic', 'Chiny'), ('Pentax', 'USA'),
	( 'Ricoh', 'Anglia'), ('Samsung', 'Anglia'),
	( 'Sony', 'Niemcy');

	INSERT INTO Obiektyw (model, minPrzeslona,maxPrzeslona) VALUES
	('RF100', 2 , 8),('RF200',2,12),('TFx2',1,10),('TFx33',3,13),
	('PROf1', 2 , 13),('PROf2',2,15),('PROf3',1,16),('PH4K',4,11),
	('PH8K',5,20),('MODv1',3,7),('MODv2',3,10),('MODv3',2, 14),
	('OB1v1',1,11),('OB1v2',1,12),('OB1v3',1,16);
	('k',9,2),('l',-1,2);	--niepoprawne wartosci

	INSERT INTO Matryca (przekatna, rozdzielczosc,typ) VALUES
	(12.30, 30.3 ,'IPS'),(3.30, 12.3 ,'TN'),(77.88, 33.9 ,'VA'),
	(12.42, 86.4 ,'IPS'),(13.32, 33.5 ,'TN'),(45.75, 23.3 ,'VA'),
	(45.24, 34.1 ,'IPS'),(43.34, 22.1 ,'TN'),(34.75, 43.3 ,'VA'),
	(35.66, 12.3 ,'IPS'),(99.99, 03.2 ,'TN'),(11.66, 65.1 ,'VA'),
	(11.55, 90.4 ,'IPS'),(46.42, 11.1 ,'TN'),(11.35, 67.3 ,'VA');
	(-3, 2, 'kis'), (33, -33, 'kas'); --niepoprawne wartosci

	INSERT INTO Aparat (model, producent, matryca, obiektyw, typ) VALUES
	('A600', 1, 101 , 2, 'lustrzanka'),('A800', 1, 106 , 8, 'lustrzanka'),
	('B4400', 12, 100 , 6, 'inny'),('B5600', 12, 110 , 15, 'inny'),
	('KP-100', 5, 101 , 2, 'kompaktowy'),('KP-250', 5, 111 , 11, 'kompaktowy'),
	('PROK', 6, 103 , 4, 'profesjonalny'),('SaP00', 6, 108 , 12, 'profesjonalny'),
	('APARAT0', 8, 100 , 6, 'inny'),('APARAT1', 9, 112 , 9, 'inny'),
	('ART1000', 10, 104 , 5, 'kompaktowy'),('ART2000', 11, 102 , 3, 'kompaktowy'),
	('MOD1', 13, 114 , 12, 'inny'),('MOD22', 14, 107 , 14, 'profesjonalny'),
	('KART33', 2, 110 , 4, 'lustrzanka');

--4. Z konta 268491 nie mozna stworzyc procedury.

	DELIMITER $$
	CREATE FUNCTION fn_generate_random_code (desired_code_len INTEGER) RETURNS VARCHAR(100)
	NO SQL
	BEGIN
		SET @possible_characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		SET @len =  LENGTH(@possible_characters);
    		SET @random_code = '';
		append_char_to_random_code: LOOP
			IF LENGTH(@random_code) >= desired_code_len THEN
			LEAVE append_char_to_random_code;
		END IF;
		SET @random_char_pos = FLOOR(RAND()*(@len - 0 + 1) + 0);
		SET @extracted_char = SUBSTRING(@possible_characters, @random_char_pos, 1);
		SET @random_code = CONCAT(@random_code, @extracted_char);
	END LOOP;
	RETURN @random_code;
	END $$
	DELIMITER ;

	
	DELIMITER $$
	CREATE PROCEDURE InsertRandomRecords ()
	BEGIN
		DECLARE cnt INT;
		SET cnt=0;
		WHILE cnt < 100 DO
   		INSERT INTO Aparat (model, producent, matryca, obiektyw, typ) VALUES
		((fn_generate_random_code(6)),
		(SELECT ID FROM Producent ORDER BY RAND() LIMIT 1),
		(SELECT ID FROM Matryca ORDER BY RAND() LIMIT 1),
		(SELECT ID FROM Obiektyw ORDER BY RAND() LIMIT 1),
		('inny')
		);
   		SET cnt = cnt + 1;
		END WHILE;
	END $$
	DELIMITER ;
