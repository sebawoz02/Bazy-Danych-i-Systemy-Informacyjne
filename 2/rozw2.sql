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
