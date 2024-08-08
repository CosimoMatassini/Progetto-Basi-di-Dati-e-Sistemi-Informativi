##################### CREAZIONE BASE DI DATI #############################

DROP DATABASE IF EXISTS `DBGestioneFerrovia` ;
CREATE DATABASE IF NOT EXISTS `DBGestioneFerrovia`;
USE `DBGestioneFerrovia` ;

##################### CREAZIONE TABELLE #############################

DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Prenotazione` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`TransitoEffettivo` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`TransitoProgrammato` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Gestione` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Personale` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Biglietto` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`CarrozzaAltaVelocità` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Carrozza` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Treno` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Stazione` ;
DROP TABLE IF EXISTS `DBGestioneFerrovia`.`Persona` ;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Stazione` (
	`Nome`        VARCHAR(45) NOT NULL,
	`Città`       VARCHAR(40) NOT NULL,
	`Provincia`   CHAR(2)     NOT NULL,
	`NumeroBinari`INT         NOT NULL,
	PRIMARY KEY (`Nome`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Treno` (
	`Data`      DATE NOT NULL,
	`Categoria` ENUM('Alta Velocità', 'Regionale') NOT NULL,
	`Numero`    INT NOT NULL,
	`Compagnia` VARCHAR(45) NOT NULL,
	`Arrivo`    VARCHAR(45) NULL,
	`Partenza`  VARCHAR(45) NULL,
	PRIMARY KEY (`Data`, `Categoria`, `Numero`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Carrozza` (
	`DataTreno`       DATE NOT NULL,
	`CategoriaTreno`  ENUM('Alta Velocità', 'Regionale') NOT NULL,
	`NumeroTreno`     INT NOT NULL,
	`NumeroCarrozza`  INT NOT NULL,
	`VelocitàMassima` INT NOT NULL,
	`Classe`          TINYINT NULL,
	PRIMARY KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`),
	FOREIGN KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`) REFERENCES `DBGestioneFerrovia`.`Treno` (`Data`, `Categoria`, `Numero`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`CarrozzaAltaVelocità` (
	`DataTreno`      DATE NOT NULL,
	`CategoriaTreno` ENUM('Alta Velocità', 'Regionale') NOT NULL,
	`NumeroTreno`    INT NOT NULL,
	`NumeroCarrozza` INT NOT NULL,
	`Servizio`       ENUM('Standard', 'Silenzio', 'Ristorante', 'Bar') NOT NULL,
	`NumeroPosti`    INT DEFAULT 0,

	PRIMARY KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`),
	FOREIGN KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`)
	REFERENCES `DBGestioneFerrovia`.`Carrozza` (`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Persona` (
	`CodiceFiscale` CHAR(16)    NOT NULL,
	`DataDiNascita` DATE        NOT NULL,
	`Nome`          VARCHAR(45) NOT NULL,
	`Cognome`       VARCHAR(45) NOT NULL,
	PRIMARY KEY (`CodiceFiscale`)
)ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Biglietto` (
	`Codice`           INT NOT NULL AUTO_INCREMENT,
	`Persona`          CHAR(16) NOT NULL,
	`StazionePartenza` VARCHAR(45) NOT NULL,
	`StazioneArrivo`   VARCHAR(45) NOT NULL,
	`Costo`            DECIMAL(6, 2) NOT NULL,
	`DataAcquisto`     DATE NOT NULL,
	`DataScadenza`     DATE NOT NULL,
	`Classe`           INT NULL,
	PRIMARY KEY (`Codice`),
	FOREIGN KEY (`Persona`) REFERENCES `DBGestioneFerrovia`.`Persona` (`CodiceFiscale`),
	FOREIGN KEY (`StazionePartenza`) REFERENCES `DBGestioneFerrovia`.`Stazione` (`Nome`),
	FOREIGN KEY (`StazioneArrivo`) REFERENCES `DBGestioneFerrovia`.`Stazione` (`Nome`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Personale` (
	`Persona` CHAR(16) NOT NULL,
	`CodiceCartellino` INT NOT NULL,
	`Mansione` VARCHAR(45) NOT NULL,
	PRIMARY KEY (`Persona`),
	FOREIGN KEY (`Persona`) REFERENCES `DBGestioneFerrovia`.`Persona` (`CodiceFiscale`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Gestione` (
	`Persona` CHAR(16) NOT NULL,
	`Data` DATE NOT NULL,
	`CategoriaTreno` ENUM('Alta Velocità', 'Regionale') NOT NULL,
	`NumeroTreno` INT NOT NULL,
	PRIMARY KEY (`Persona`, `Data`, `CategoriaTreno`, `NumeroTreno`),
	FOREIGN KEY (`Persona`) REFERENCES `DBGestioneFerrovia`.`Personale` (`Persona`),
	FOREIGN KEY (`Data`, `CategoriaTreno`, `NumeroTreno`) REFERENCES `DBGestioneFerrovia`.`Treno` (`Data`, `Categoria`, `Numero`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`TransitoProgrammato` (
	`DataTreno` DATE NOT NULL,
	`CategoriaTreno` ENUM('Alta Velocità', 'Regionale') NOT NULL,
	`NumeroTreno` INT NOT NULL,
	`NomeStazione` VARCHAR(45) NOT NULL,
	`Binario` INT NOT NULL,
	`Arrivo` TIME NULL,
	`Partenza` TIME NULL,
	PRIMARY KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NomeStazione`),
	FOREIGN KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`) REFERENCES `DBGestioneFerrovia`.`Treno` (`Data`, `Categoria`, `Numero`),
	FOREIGN KEY (`NomeStazione`) REFERENCES `DBGestioneFerrovia`.`Stazione` (`Nome`)
)ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`TransitoEffettivo` (
	`DataTreno` DATE NOT NULL,
	`CategoriaTreno` ENUM('Alta Velocità', 'Regionale') NOT NULL,
	`NumeroTreno` INT NOT NULL,
	`NomeStazione` VARCHAR(45) NOT NULL,
	`Binario` INT NOT NULL,
	`Arrivo` TIME NULL,
	`Partenza` TIME NULL,
	PRIMARY KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NomeStazione`),
	FOREIGN KEY (`DataTreno`, `CategoriaTreno`, `NumeroTreno`) REFERENCES `DBGestioneFerrovia`.`Treno` (`Data`, `Categoria`, `Numero`),
	FOREIGN KEY (`NomeStazione`) REFERENCES `DBGestioneFerrovia`.`Stazione` (`Nome`)
)ENGINE = InnoDB;




CREATE TABLE IF NOT EXISTS `DBGestioneFerrovia`.`Prenotazione` (
	`CodiceBiglietto` INT NOT NULL,
	`Data` DATE NOT NULL,
	`CategoriaTreno` ENUM('Alta Velocità', 'Regionale') NOT NULL,
	`NumeroTreno` INT NOT NULL,
	`NumeroCarrozza` INT NOT NULL,
	`Seduta` INT NOT NULL,
	PRIMARY KEY (`CodiceBiglietto`, `Data`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`),
	UNIQUE (`CodiceBiglietto`, `Data`, `CategoriaTreno`, `NumeroTreno`),
	FOREIGN KEY (`CodiceBiglietto`) REFERENCES `DBGestioneFerrovia`.`Biglietto` (`Codice`),
	FOREIGN KEY (`Data`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`)
	REFERENCES `DBGestioneFerrovia`.`CarrozzaAltaVelocità` (`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`)
)ENGINE = InnoDB;


DELIMITER $$
DROP PROCEDURE IF EXISTS `DBGestioneFerrovia`.`CreazioneBigliettoAV`$$
CREATE PROCEDURE CreazioneBigliettoAV(CFIN VARCHAR(16), CostoIN FLOAT, StazionePartenzaIN VARCHAR(45), StazioneArrivoIN VARCHAR(45),
										DataTrenoIN DATE, NumeroTrenoIN INT, NumeroCarrozzaIN INT)
BEGIN
		DECLARE seduta INT DEFAULT 1;
		DECLARE MAXPosti INT DEFAULT 1;
		Declare Msg varchar(8000);

	#SELECT DataTrenoIN, NumeroTrenoIN;

	#SELECT count(*) FROM `CarrozzaAltaVelocità`
	#WHERE (`DataTreno`= DataTrenoIN AND `CategoriaTreno`='Alta Velocità' AND `NumeroTreno`=NumeroTrenoIN);

		#SELECT count(*) FROM `CarrozzaAltaVelocità`
	#WHERE (`DataTreno`= DataTrenoIN AND `CategoriaTreno`='Alta Velocità' AND `NumeroTreno`=NumeroTrenoIN AND `NumeroCarrozza`=NumeroCarrozzaIN);

		IF ( (SELECT count(*) FROM `CarrozzaAltaVelocità` WHERE (`DataTreno`= DataTrenoIN AND `CategoriaTreno`='Alta Velocità' AND `NumeroTreno`=NumeroTrenoIN))  <= 0) THEN
		SET Msg = concat('ERROR: Non esiste il treno per cui state effettuando la prenotazione');
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = Msg;
		END IF;

	IF ( (SELECT count(*) FROM `CarrozzaAltaVelocità` WHERE (`DataTreno`= DataTrenoIN AND `CategoriaTreno`='Alta Velocità' AND `NumeroTreno`=NumeroTrenoIN AND `NumeroCarrozza`=NumeroCarrozzaIN)) <= 0) then
		SET Msg = concat('ERROR: Non esiste la carrozza per cui state effettuando la prenotazione');
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = Msg;
	end if;

		SET seduta = ((SELECT COUNT(*) FROM `Prenotazione` WHERE (`Data`=DataTrenoIN AND `CategoriaTreno`='Alta Velocità' AND `NumeroTreno`=NumeroTrenoIN AND `NumeroCarrozza`=NumeroCarrozzaIN)) + 1);

	SET MAXPosti = (SELECT `NumeroPosti` FROM `CarrozzaAltaVelocità` WHERE (`DataTreno`=DataTrenoIN AND `CategoriaTreno`='Alta Velocità' AND `NumeroTreno`=NumeroTrenoIN AND `NumeroCarrozza`=NumeroCarrozzaIN));

	IF (seduta > MAXPosti) THEN
		SET Msg = concat('ERROR: carroza piena, si prega di inserire un\'altra carrozza');
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = Msg;
		END IF;

		INSERT INTO `DBGestioneFerrovia`.`Biglietto`(`Persona`, `StazionePartenza`, `StazioneArrivo`, `Costo`, `DataAcquisto`, `DataScadenza`, `Classe`)
		VALUES
		(CFIN, StazionePartenzaIN, StazioneArrivoIN, CostoIN, DataTrenoIN, DataTrenoIN, NULL);

		INSERT INTO `DBGestioneFerrovia`.`Prenotazione`()
		VALUES
		((SELECT `Codice` FROM `Biglietto` WHERE `Codice`=(SELECT last_insert_id())), DataTrenoIN, 'Alta Velocità', NumeroTrenoIN, NumeroCarrozzaIN, seduta);

END $$


DROP PROCEDURE IF EXISTS `DBGestioneFerrovia`.`DescrizioneBigliettoREG`$$
CREATE PROCEDURE DescrizioneBigliettoREG(CodiceBigliettoIN INT)
BEGIN
		SELECT `Codice` as `Codice Biglietto`, `CodiceFiscale` as `Codice Fiscale`, `Nome`, `Cognome`, `DataDiNascita` as `Data Di Nascita`, `StazionePartenza` as `Stazione di Partenza`, `StazioneArrivo` as `Stazione di Arrivo`, `Classe`, `DataAcquisto` as `Data di Acquisto`, `DataScadenza` as `Data di Scadenza`
	FROM Biglietto JOIN Persona
	ON `Biglietto`.`Persona` = `Persona`.`CodiceFiscale`
	WHERE `Biglietto`.`Codice`=CodiceBigliettoIN;
END $$

DROP PROCEDURE IF EXISTS `DBGestioneFerrovia`.`DescrizioneBigliettoAV`$$
CREATE PROCEDURE DescrizioneBigliettoAV(CodiceBigliettoIN INT)
BEGIN

	SELECT `T6`.`CodiceBiglietto` as `Codice Biglietto`, `Nome`, `Cognome`, `CodiceFiscale` as `Codice Fiscale`, `T6`.`DataTreno`, `T6`.`NumeroTreno`, `T6`.`CategoriaTreno`, `T6`.`NumeroCarrozza`, `Servizio`, `T6`.`Seduta` as `Nr.Posto`, `StazionePartenza` as `Stazione di Partenza`, `StazioneArrivo` as `Stazione di Arrivo`, `Costo`, `DataAcquisto` as `Data di Acquisto`, `DataScadenza` as `Data di Scedanza`, `Compagnia`
	FROM
		(
			SELECT *
			FROM
				(
					SELECT *
					FROM `Prenotazione` JOIN `Biglietto`
					ON `Biglietto`.`Codice` = `Prenotazione`.`CodiceBiglietto`
				) AS T1
				JOIN
				(
					SELECT `Codice` as CodiceBigliettoCF, `CodiceFiscale`, `Nome`, `Cognome`, `DataDiNascita`
					FROM `Biglietto` JOIN `Persona`
					ON `Biglietto`.`Persona` = `Persona`.`CodiceFiscale`
				) AS T2
			ON `Codice`=`CodiceBigliettoCF`
			#WHERE `T1`.`Codice`=CodiceBigliettoIN
		) as T5
		JOIN
		(
			SELECT *
			FROM
				(
					SELECT `CodiceBiglietto`, `DataTreno`, `CarrozzaAltaVelocità`.`CategoriaTreno`, `CarrozzaAltaVelocità`.`NumeroCarrozza`, `Seduta`, `CarrozzaAltaVelocità`.`NumeroTreno`, `Servizio`
					FROM `Prenotazione` LEFT JOIN `CarrozzaAltaVelocità`
					ON (`Prenotazione`.`Data`=`CarrozzaAltaVelocità`.`DataTreno` AND `Prenotazione`.`CategoriaTreno`=`CarrozzaAltaVelocità`.`CategoriaTreno` AND `Prenotazione`.`NumeroTreno`=`CarrozzaAltaVelocità`.`NumeroTreno` AND `Prenotazione`.`NumeroCarrozza`=`CarrozzaAltaVelocità`.`NumeroCarrozza`)
					#WHERE `Prenotazione`.`CodiceBiglietto`=11;
				) AS T3
				JOIN
				(
					SELECT `Compagnia`, `Arrivo`, `Partenza`, `Data`, `Categoria`, `Numero`, `NumeroCarrozza` as `NumeroCarrozzaTR`
					FROM `CarrozzaAltaVelocità` JOIN `Treno`
					ON (`Treno`.`Data`=`CarrozzaAltaVelocità`.`DataTreno` AND `Treno`.`Categoria`=`CarrozzaAltaVelocità`.`CategoriaTreno` AND `Treno`.`Numero`=`CarrozzaAltaVelocità`.`NumeroTreno`)
				) AS T4
			ON (`T3`.`DataTreno`=`T4`.`Data` AND `T3`.`CategoriaTreno`=`T4`.`Categoria` AND `T3`.`NumeroTreno`=`T4`.`Numero` AND `T3`.`NumeroCarrozza`=`T4`.`NumeroCarrozzaTR`)
			#WHERE `T3`.`CodiceBiglietto` = CodiceBigliettoIN;
		) as T6
		ON `T5`.`Codice`=`T6`.`CodiceBiglietto`
		WHERE `T6`.`CodiceBiglietto`=CodiceBigliettoIN;

END $$

DROP PROCEDURE IF EXISTS `DBGestioneFerrovia`.`TabelloneStazioneTotale`$$
CREATE PROCEDURE TabelloneStazioneTotale(StazioneIN VARCHAR(45), DataTabelloneIN DATE)
BEGIN
		SELECT `DataTreno`, `NumeroTreno`, `CategoriaTreno`, `Binario`, `Arrivo`, `Partenza`
		FROM
		`Stazione` JOIN `TransitoProgrammato`
		ON (`Stazione`.`Nome`=`TransitoProgrammato`.`NomeStazione`)
		WHERE (`TransitoProgrammato`.`DataTreno`=DataTabelloneIN AND `Stazione`.`Nome`=StazioneIN) LIMIT 10;
END $$

DROP PROCEDURE IF EXISTS `DBGestioneFerrovia`.`TabelloneStazionePartenze`$$
CREATE PROCEDURE TabelloneStazionePartenze(StazioneIN VARCHAR(45), DataTabelloneIN DATE)
BEGIN
		SELECT `DataTreno`, `NumeroTreno`, `CategoriaTreno`, `Binario`, `Arrivo`, `Partenza`
		FROM
		`Stazione` JOIN `TransitoProgrammato`
		ON (`Stazione`.`Nome`=`TransitoProgrammato`.`NomeStazione`)
		WHERE (`TransitoProgrammato`.`DataTreno`=DataTabelloneIN AND `Stazione`.`Nome`=StazioneIN AND `TransitoProgrammato`.`Partenza` is not NULL) LIMIT 10;
END $$

DROP PROCEDURE IF EXISTS `DBGestioneFerrovia`.`TabelloneStazioneArrivi`$$
CREATE PROCEDURE TabelloneStazioneArrivi(StazioneIN VARCHAR(45), DataTabelloneIN DATE)
BEGIN
		SELECT `DataTreno`, `NumeroTreno`, `CategoriaTreno`, `Binario`, `Arrivo`, `Partenza`
		FROM
		`Stazione` JOIN `TransitoProgrammato`
		ON (`Stazione`.`Nome`=`TransitoProgrammato`.`NomeStazione`)
		WHERE (`TransitoProgrammato`.`DataTreno`=DataTabelloneIN AND `Stazione`.`Nome`=StazioneIN AND `TransitoProgrammato`.`Arrivo` is not NULL) LIMIT 10;
END $$

DROP PROCEDURE IF EXISTS `DBGestioneFerrovia`.`FermateTreno`$$
CREATE PROCEDURE FermateTreno(DataTrenoIN DATE, CateogoriaTrenoIN VARCHAR(45), NumeroTrenoIN INT)
BEGIN
		select `NomeStazione`, `Binario`, `Arrivo`, `Partenza` from `TransitoProgrammato` where (`NumeroTreno` = NumeroTrenoIN and `CategoriaTreno`  = CateogoriaTrenoIN and `DataTreno` = DataTrenoIN) order by `Arrivo` asc;
END $$


DELIMITER ;

DELIMITER $$

DROP TRIGGER IF EXISTS `AggiornamentoArrivoEPartenzaTrenoTP` $$
CREATE TRIGGER `AggiornamentoArrivoEPartenzaTrenoTP`
AFTER INSERT ON `TransitoProgrammato`
FOR EACH ROW
BEGIN
	DECLARE StazionePartenza VARCHAR(45);
	DECLARE StazioneArrivo VARCHAR(45);

	SET StazionePartenza = (SELECT `Partenza` FROM `Treno` WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno));
	SET StazioneArrivo =   (SELECT `Arrivo` FROM `Treno` WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno));

	IF( NEW.Partenza is null) then
		UPDATE `Treno` SET `Arrivo`=NEW.NomeStazione WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno);
	end if;
		IF( NEW.Arrivo is null) then
		UPDATE `Treno` SET `Partenza`=NEW.NomeStazione WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno);
		end if;
END$$

DROP TRIGGER IF EXISTS `AggiornamentoArrivoEPartenzaTrenoTE` $$
CREATE TRIGGER `AggiornamentoArrivoEPartenzaTrenoTE`
AFTER INSERT ON `TransitoEffettivo`
FOR EACH ROW
BEGIN
	DECLARE StazionePartenza VARCHAR(45);
	DECLARE StazioneArrivo VARCHAR(45);

	SET StazionePartenza = (SELECT `Partenza` FROM `Treno` WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno));
	SET StazioneArrivo =   (SELECT `Arrivo` FROM `Treno` WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno));

	IF( NEW.Partenza is null) then
		UPDATE `Treno` SET `Arrivo`=NEW.NomeStazione WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno);
	end if;
		IF( NEW.Arrivo is null) then
		UPDATE `Treno` SET `Partenza`=NEW.NomeStazione WHERE (`Data`= NEW.DataTreno AND `Categoria`= NEW.CategoriaTreno AND `Numero`= NEW.NumeroTreno);
		end if;
END$$

DROP TRIGGER IF EXISTS `ControlloBinarioTP` $$
CREATE TRIGGER `ControlloBinarioTP`
AFTER INSERT ON `TransitoProgrammato`
FOR EACH ROW
BEGIN
	Declare Msg varchar(8000);
	Declare MaxBinario INT;
	SET MaxBinario =
		(SELECT NumeroBinari
		FROM `Stazione`
		WHERE `Nome`=NEW.NomeStazione);

		IF (NEW.Binario > MaxBinario OR NEW.Binario < 1) THEN
		SET Msg = concat('errore inserimento binario su tupla: ', NEW.DataTreno, ' ', NEW.CategoriaTreno,' ', NEW.NumeroTreno, ' ', NEW.NomeStazione);
				SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = Msg;
		END IF;
END$$

DROP TRIGGER IF EXISTS `ControlloBinarioTE` $$
CREATE TRIGGER `ControlloBinarioTE`
AFTER INSERT ON `TransitoEffettivo`
FOR EACH ROW
BEGIN
	Declare Msg varchar(8000);
	Declare MaxBinario INT;
	SET MaxBinario =
		(SELECT NumeroBinari
		FROM `Stazione`
		WHERE `Nome`=NEW.NomeStazione);

		IF (NEW.Binario > MaxBinario OR New.Binario < 1) THEN
		SET Msg = concat('errore inserimento binario su tupla: ', NEW.DataTreno, ' ', NEW.CategoriaTreno,' ', NEW.NumeroTreno, ' ', NEW.NomeStazione);
				SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = Msg;
		END IF;
END$$

DROP TRIGGER IF EXISTS `ControlloComposizione` $$
CREATE TRIGGER `ControlloComposizione`
BEFORE INSERT ON `CarrozzaAltaVelocità`
FOR EACH ROW
BEGIN
	Declare Msg varchar(8000);
		IF (NEW.CategoriaTreno != 'Alta Velocità') THEN
		SET Msg = concat('Il treno: ', NEW.DataTreno, ' ', NEW.CategoriaTreno,' ', NEW.NumeroTreno, ' è stato erroneamente inserito nelle tuple di inserimento, si prega di rimuoverlo');
				SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = Msg;
	END IF;
END$$

DELIMITER ;

############### POPOLAMENTO TABELLE #########################


load data local infile './DatiStazioni.csv'
into table `Stazione`
fields terminated by ';'
ignore 1 lines
(`Nome`, `NumeroBinari`, `Città`, `Provincia`);


INSERT INTO `DBGestioneFerrovia`.`Stazione`
VALUES
('Firenze Campo di Marte',	'Firenze',	   'FI',  15),
('Figline Valdarno',		'Figline Valdarno','FI',   4),
('Incisa Valdarno',		'Incisa Valdarno', 'FI',   3),
('San Giovanni Valdarno',	'San Giovanno Valdarno','AR', 4),
('Arezzo',			'Arezzo',	   'AR',  10),
('Montevarchi',			'Montevarchi',	   'AR',   8),
('Bologna Centrale',		'Bologna',	   'BO',  20),
('Milano Centrale',		'Milano',	   'MI',  30),
('Napoli Centrale',		'Napoli',	   'NA',  20),
('Genova Centrale',		'Genova',     	   'GE',  20),
('Roma termini',		'Roma',		   'RO',  20),
('Reggio Emilia AV',		'Emilia-Romagna',  'ER',  20);





INSERT INTO `DBGestioneFerrovia`.`Treno`(`Data`, `Categoria`, `Numero`, `Compagnia`)
VALUES
('2023-01-28','Regionale',19341, 'Trenitalia'),
('2023-01-27','Regionale',19341, 'Trenitalia'),
('2023-01-26','Regionale',19341, 'Trenitalia'),
('2023-03-29','Regionale',19341, 'Trenitalia'),
('2023-10-25','Regionale',19341, 'Trenitalia'),
('2023-03-14','Regionale',12341, 'Trenitalia'),

('2023-05-24','Regionale',15431, 'Trenitalia'),
('2023-01-12','Regionale',14331, 'Trenitalia'),
('2023-01-12','Regionale',12341, 'Trenitalia'),

('2023-02-05', 'Alta Velocità', 2321, 'Trenitalia'),
('2023-06-14', 'Alta Velocità',	6765, 'Trenitalia'),

('2023-12-25', 'Alta Velocità', 2314, 'Italo'),
('2023-07-05', 'Alta Velocità', 4532, 'Italo'),
('2023-07-10', 'Alta Velocità', 4532, 'Italo'),
('2023-07-15', 'Alta Velocità', 4532, 'Italo');





INSERT INTO `DBGestioneFerrovia`.`Carrozza`
VALUES
('2023-01-28','Regionale',19341, 1, 160.5, 2),
('2023-01-28','Regionale',19341, 2, 170, 2),
('2023-01-28','Regionale',19341, 3, 150, 2),
('2023-01-28','Regionale',19341, 4, 165, 2),
('2023-01-28','Regionale',19341, 5, 155, 1),
('2023-03-29','Regionale',19341, 1, 120, 2),
('2023-03-29','Regionale',19341, 2, 130, 2),
('2023-03-29','Regionale',19341, 3, 145, 2),
('2023-03-29','Regionale',19341, 4, 143, 1),
('2023-03-29','Regionale',19341, 5, 155, 1),
('2023-10-25','Regionale',19341, 1, 133, 2),
('2023-10-25','Regionale',19341, 2, 137, 2),
('2023-10-25','Regionale',19341, 3, 155, 2),
('2023-10-25','Regionale',19341, 4, 145, 2),
('2023-10-25','Regionale',19341, 5, 136, 2),

('2023-01-12','Regionale',14331, 1, 120, 2),

('2023-07-15','Alta Velocità',4532, 1, 180, NULL),
('2023-07-15','Alta Velocità',4532, 2, 190, NULL),
('2023-07-15','Alta Velocità',4532, 3, 200, NULL),
('2023-07-15','Alta Velocità',4532, 4, 179, NULL),
('2023-07-15','Alta Velocità',4532, 5, 220, NULL),

('2023-06-14','Alta Velocità',6765, 1, 187, NULL),
('2023-06-14','Alta Velocità',6765, 2, 180, NULL),
('2023-06-14','Alta Velocità',6765, 3, 175, NULL),
('2023-06-14','Alta Velocità',6765, 4, 196, NULL),
('2023-06-14','Alta Velocità',6765, 5, 200, NULL);





INSERT INTO `DBGestioneFerrovia`.`CarrozzaAltaVelocità`(`DataTreno`, `CategoriaTreno`, `NumeroTreno`, `NumeroCarrozza`, `Servizio`, `NumeroPosti`)
VALUES
('2023-07-15','Alta Velocità',4532, 1, 'Standard',   50),
('2023-07-15','Alta Velocità',4532, 2, 'Silenzio',   40),
('2023-07-15','Alta Velocità',4532, 3, 'Silenzio',   40),
('2023-07-15','Alta Velocità',4532, 4, 'Ristorante', 30),
('2023-07-15','Alta Velocità',4532, 5, 'Bar', 	     20),

('2023-06-14','Alta Velocità',6765, 1, 'Standard',  100),
('2023-06-14','Alta Velocità',6765, 2, 'Bar', 	     25),
('2023-06-14','Alta Velocità',6765, 3, 'Bar',	     25),
('2023-06-14','Alta Velocità',6765, 4, 'Ristorante', 40),
('2023-06-14','Alta Velocità',6765, 5, 'Standard',   60);

#('2023-01-12','Regionale',14331, 1, 'Standard', 70)



load data local infile './DatiPersone.in'
into table Persona
fields terminated by ';'
optionally enclosed by '$'
ignore 4 lines;


INSERT INTO `DBGestioneFerrovia`.`Persona`
VALUES
('CSTLSN54H65D612U' ,'1954-06-25' ,'ALESSANDRA','CUSTODI'),
('BNCGVR99E65F656T' ,'1999-05-25' ,'GINEVRA'   ,'BIANCHI'),
('NREMTN04E55H501H' ,'2004-05-15' ,'MARTINA'   ,'NERI'),
('RSSFRC04S13D969Z' ,'2004-11-13' ,'FEDERICO'  ,'ROSSI'),
('MTSLRT96C19D969K' ,'1996-03-19' ,'ALBERTO'   ,'MATASSINI'),
('VRDGLG01E13H501L' ,'2001-05-13' ,'GIANLUIGI' ,'VERDI'),
('DDAFNC75T15D612I' ,'1975-12-15' ,'FRANCESCO' ,'DADO'),
('CMCLSE89A41D969D' ,'1989-01-01' ,'ELISA'     ,'CAMICI'),
('BRNCHR01E44D612R' ,'2001-05-04' ,'CHIARA'    ,'BARONE'),
('VTIRNI99H63H501R' ,'1999-06-23' ,'IRENE'     ,'VITE');





INSERT INTO `DBGestioneFerrovia`.`Biglietto`(`Persona`, `StazionePartenza`, `StazioneArrivo`, `Costo`, `DataAcquisto`, `DataScadenza`, `Classe`)
VALUES
('CSTLSN54H65D612U','Figline Valdarno', 'Firenze Santa Maria Novella',	4.6, '2023-05-15', '2023-05-15', 2),
('CSTLSN54H65D612U','Figline Valdarno', 'Firenze Santa Maria Novella', 	4.6, '2023-05-15', '2023-06-15', 1),
('BNCGVR99E65F656T','Roma Termini', 	'Firenze Santa Maria Novella', 	4.6, '2023-05-17', '2023-05-17', 1),
('MTSLRT96C19D969K','Genova Centrale',  'Firenze Santa Maria Novella', 	4.6, '2023-04-15', '2023-05-15', NULL),
('CMCLSE89A41D969D','Arezzo',	        'Firenze Santa Maria Novella', 	4.6, '2023-03-15', '2023-03-15', 2),
('RSSFRC04S13D969Z','Figline Valdarno', 'Montevarchi', 			4.6, '2023-05-15', '2023-05-15', 2),
('CMCLSE89A41D969D','Montevarchi',	'Firenze Santa Maria Novella', 	4.6, '2023-05-23', '2023-05-23', 2),
('CSTLSN54H65D612U','Milano Centrale', 	'Genova Centrale', 		4.6, '2023-03-12', '2023-03-12', NULL),
('CSTLSN54H65D612U','Napoli Centrale',  'Bologna Centrale', 		4.6, '2023-05-15', '2023-05-15', NULL),
('MTSLRT96C19D969K','Firenze Santa Maria Novella', 'Firenze Campo di Marte', 4.6, '2023-01-15', '2023-01-15', 2);





INSERT INTO `DBGestioneFerrovia`.`Personale`
VALUES
('VRDGLG01E13H501L', 20312, 'Capo Treno'),
('RSSFRC04S13D969Z', 23235 ,'Macchinista'),
('VTIRNI99H63H501R', 94832, 'Macchinista'),
('CMCLSE89A41D969D', 09382, 'Macchinista');





INSERT INTO `DBGestioneFerrovia`.`Gestione`
VALUES
('VRDGLG01E13H501L', '2023-07-15','Alta Velocità' , 4532 ),
('RSSFRC04S13D969Z', '2023-03-29','Regionale'	  , 19341),
('VTIRNI99H63H501R', '2023-10-25','Regionale'	  , 19341),
('RSSFRC04S13D969Z', '2023-06-14','Alta Velocità' , 6765 ),
('CMCLSE89A41D969D', '2023-12-25','Alta Velocità' , 2314 ),
('VRDGLG01E13H501L', '2023-12-25','Alta Velocità' , 2314 ),
('CMCLSE89A41D969D', '2023-03-14','Regionale'	  , 12341),
('VTIRNI99H63H501R', '2023-05-24','Regionale'	  , 15431),
('RSSFRC04S13D969Z', '2023-01-12','Regionale'	  , 14331),
('VTIRNI99H63H501R', '2023-02-05', 'Alta Velocità', 2321 );





INSERT INTO `DBGestioneFerrovia`.`TransitoProgrammato`
VALUES
('2023-01-28','Regionale',19341, 'Firenze Santa Maria Novella', 4  ,    NULL,  '8:23'),
('2023-01-28','Regionale',19341, 'Firenze Campo di Marte'     , 1  ,  '8:43',  '8:44'),
('2023-01-28','Regionale',19341, 'Arezzo'		      		  , 3  , '10:00',  '10:02'),
('2023-01-28','Regionale',19341, 'San Giovanni Valdarno'      , 3  , '10:05',  '10:07'),
('2023-01-28','Regionale',19341, 'Milano Centrale'		      , 6  , '10:30',  '10:31'),
('2023-01-28','Regionale',19341, 'Bologna Centrale'		      	  , 12 , '13:00',     NULL),


('2023-01-27','Regionale',19341, 'Firenze Santa Maria Novella', 4  ,    NULL,  '8:23'),
('2023-01-27','Regionale',19341, 'Firenze Campo di Marte'     , 1  ,  '8:43',  '8:44'),
('2023-01-27','Regionale',19341, 'Arezzo'		      		  , 3  , '10:00',  '10:02'),
('2023-01-27','Regionale',19341, 'San Giovanni Valdarno'      , 3  , '10:05',  '10:07'),
('2023-01-27','Regionale',19341, 'Milano Centrale'		      , 6  , '10:30',  '10:31'),
('2023-01-27','Regionale',19341, 'Bologna Centrale'		      	  , 12 , '13:00',     NULL),

('2023-05-24','Regionale',15431, 'Figline Valdarno', 3, '10:10', '10:12'),
('2023-01-12','Regionale',14331, 'Figline Valdarno', 2, '9:10' , '9:12' ),

('2023-01-12','Regionale',12341, 'Figline Valdarno', 3, '10:12', '10:14'),

('2023-07-15','Alta Velocità',4532, 'Bologna Centrale', 4,    NULL,  '9:40'),
('2023-07-15','Alta Velocità',4532, 'Reggio Emilia AV', 2, '10:45', '10:50'),
('2023-07-15','Alta Velocità',4532, 'Milano Centrale' , 4, '12:10',    NULL);




INSERT INTO `DBGestioneFerrovia`.`TransitoEffettivo`
VALUES
('2023-01-28','Regionale',19341, 'Firenze Santa Maria Novella', 4  ,    NULL,  '8:23'),
('2023-01-28','Regionale',19341, 'Firenze Campo di Marte'     , 1  ,  '8:45',  '8:46'),
('2023-01-28','Regionale',19341, 'Arezzo'		      		  , 3  , '10:00',  '10:30'),
('2023-01-28','Regionale',19341, 'San Giovanni Valdarno'      , 3  , '10:10',  '10:11'),
('2023-01-28','Regionale',19341, 'Milano Centrale'		      , 6  , '10:37',  '10:40'),
('2023-01-28','Regionale',19341, 'Bologna Centrale'		      	  , 12 , '13:20',     NULL),

('2023-01-27','Regionale',19341, 'Firenze Santa Maria Novella', 4  ,    NULL,   '8:23'),
('2023-01-27','Regionale',19341, 'Firenze Campo di Marte'     , 1  ,  '8:45',   '8:50'),
('2023-01-27','Regionale',19341, 'Arezzo'		      		  , 3  , '10:00',  '10:22'),
('2023-01-27','Regionale',19341, 'San Giovanni Valdarno'      , 3  , '10:35',  '10:36'),
('2023-01-27','Regionale',19341, 'Milano Centrale'		      , 6  , '11:00',  '11:01'),
('2023-01-27','Regionale',19341, 'Roma Termini'		      	  , 13 , '13:25',     NULL),

('2023-01-26','Regionale',19341, 'Firenze Santa Maria Novella', 4,    NULL,  '8:23'),
('2023-01-26','Regionale',19341, 'Firenze Campo di Marte'     , 1,  '8:45',  '8:46'),
('2023-01-26','Regionale',19341, 'Arezzo'		      , 3, '10:00', '10:02'),
('2023-01-26','Regionale',19341, 'San Giovanni Valdarno'      , 3, '10:15', '10:16'),
('2023-01-26','Regionale',19341, 'Milano Centrale'		      , 6, '10:40', '10:42'),
('2023-01-26','Regionale',19341, 'Roma Termini'		      ,12, '13:35',    NULL),

('2023-05-24','Regionale',15431, 'Bologna Centrale'	      , 3,   NULL,  '6:23'),
('2023-05-24','Regionale',15431, 'Firenze Santa Maria Novella', 2,  '8:10', '8:25'),
('2023-05-24','Regionale',15431, 'Firenze Campo di Marte'     , 5,  '8:35', '8:36'),
('2023-05-24','Regionale',15431, 'Napoli Centrale'	      , 10,'11:45', NULL),


('2023-07-15','Alta Velocità',4532, 'Bologna Centrale', 4,    NULL,  '9:40'),
('2023-07-15','Alta Velocità',4532, 'Reggio Emilia AV', 2, '10:45', '10:55'),
('2023-07-15','Alta Velocità',4532, 'Milano Centrale' , 4, '12:12',    NULL),

('2023-07-10','Alta Velocità',4532, 'Bologna Centrale', 4,    NULL, '9:40'),
('2023-07-10','Alta Velocità',4532, 'Reggio Emilia AV', 2, '10:45', '11:00'),
('2023-07-10','Alta Velocità',4532, 'Milano Centrale' , 4, '12:20',    NULL),

('2023-07-5','Alta Velocità',4532, 'Bologna Centrale', 7, NULL,     '9:45'),
('2023-07-5','Alta Velocità',4532, 'Reggio Emilia AV', 1, '10:55', '11:01'),
('2023-07-5','Alta Velocità',4532, 'Milano Centrale' , 5, '12:28',    NULL);



#SELECT * FROM `Stazione`;
#SELECT * FROM `Treno`;
#SELECT * FROM `Carrozza`;
#SELECT * FROM `CarrozzaAltaVelocità`;
#SELECT * FROM `Persona`;
#SELECT * FROM `Biglietto`;
#SELECT * FROM `Personale`;
#SELECT * FROM `Gestione`;
#SELECT * FROM `TransitoProgrammato`;
#SELECT * FROM `TransitoEffettivo`;




#call CreazioneBigliettoAV('BNCGVR99E65F656T',4.6, 'Napoli Centrale', 'Firenze Campo di Marte', '2023-06-14', 6765, 3);
#SELECT * FROM `Prenotazione`;
#call DescrizioneBigliettoREG(1);
#Select * FROM `Biglietto`;
#call DescrizioneBigliettoAV(13);
#call TabelloneStazioneTotale('Figline Valdarno', '2023-01-12');

#calcolare tutte le stazioni in cui ferma un treno
	#call FermateTreno('2023-01-28','Regionale',19341);

#Calcolare velocità massima di un treno
	#select NumeroTreno,CategoriaTreno, DataTreno, min(VelocitàMassima) as VelocitàMassimaTreno from Carrozza group by NumeroTreno, CategoriaTreno, DataTreno;


#mostrare tutti i gestori di un treno con i loro dati
		#select * from `Gestione` natural join `Personale` where (NumeroTreno = 2314 and CategoriaTreno = "Alta Velocità" and  `Data` = "2023-12-25");

#per ogni biglietto dire se è un abbonamento o ha validità singola
	#select Codice, IF(datediff(DataScadenza, DataAcquisto) > 1, "Abbonamento", "Singolo") AS Validità from Biglietto;

#listare tutte le stazioni di una città / Provincia
	#select Nome from `Stazione` where `Città` = "Firenze";

#stimare il ritardo medio della partenza di un treno in una specifica stazione.

		DROP VIEW IF EXISTS `DBGestioneFerrovia`.`ComparazioneAPconAE`;
	Create view ComparazioneAPconAE as
		SELECT `TransitoProgrammato`.`DataTreno`, `TransitoProgrammato`.`CategoriaTreno`, `TransitoProgrammato`.`NumeroTreno`, `TransitoProgrammato`.`NomeStazione` as `Stazione Programmata`,  `TransitoEffettivo`.`NomeStazione` as `Stazione Effettiva`, `TransitoProgrammato`.`Partenza` as `Partenza Programmata`, `TransitoEffettivo`.`Partenza` as `Partenza Effettiva`
				FROM TransitoProgrammato JOIN TransitoEffettivo ON (`TransitoProgrammato`.`DataTreno`=`TransitoEffettivo`.`DataTreno` AND `TransitoProgrammato`.`CategoriaTreno`=`TransitoEffettivo`.`CategoriaTreno` AND `TransitoProgrammato`.`NumeroTreno`=`TransitoEffettivo`.`NumeroTreno` AND  `TransitoProgrammato`.`NomeStazione`=`TransitoEffettivo`.`NomeStazione`);

		SELECT * FROM ComparazioneAPconAE;
	SELECT `DataTreno`, `CategoriaTreno`, `NumeroTreno`, `Stazione Programmata`, `Stazione Effettiva`, time(avg(timediff(`Partenza Effettiva`, `Partenza Programmata`))) FROM ComparazioneAPconAE WHERE (`Stazione Programmata`='Arezzo' and `CategoriaTreno`='Regionale' and `NumeroTreno`=19341) GROUP BY `CategoriaTreno`, `NumeroTreno`, `Stazione Programmata`;
