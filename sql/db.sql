ALTER TABLE IF EXISTS Kaup DROP CONSTRAINT IF EXISTS FK_Kauba_seisundi_liik_kood;
ALTER TABLE IF EXISTS Kaup DROP CONSTRAINT IF EXISTS FK_Kauba_kategooria_kood;
ALTER TABLE IF EXISTS Kaup DROP CONSTRAINT IF EXISTS FK_Tootja_kood;
ALTER TABLE IF EXISTS Kaup DROP CONSTRAINT IF EXISTS FK_Kaup_isikukood;
ALTER TABLE IF EXISTS Tootaja DROP CONSTRAINT IF EXISTS FK_Tootaja;
ALTER TABLE IF EXISTS Tootaja DROP CONSTRAINT IF EXISTS FK_Tootaja_tootaja_seisundi_liik_kood;
ALTER TABLE IF EXISTS Tootaja DROP CONSTRAINT IF EXISTS FK_Tootaja_isikukood;
ALTER TABLE IF EXISTS Isik DROP CONSTRAINT IF EXISTS FK_Isik_isiku_seisundi_liik_kood;

DROP TABLE IF EXISTS Kaup CASCADE;
DROP TABLE IF EXISTS Tootaja_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Tootaja CASCADE;
DROP TABLE IF EXISTS Kauba_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Amet CASCADE;
DROP TABLE IF EXISTS Tootja CASCADE;
DROP TABLE IF EXISTS Isiku_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Isik CASCADE;
DROP TABLE IF EXISTS Kauba_kategooria CASCADE;
DROP TABLE IF EXISTS Hinnang_kommentaar CASCADE; 

DROP DOMAIN IF EXISTS d_hind CASCADE;
DROP DOMAIN IF EXISTS d_hinnang CASCADE;
DROP DOMAIN IF EXISTS d_nimetus CASCADE;
DROP DOMAIN IF EXISTS d_kirjeldus CASCADE;
DROP DOMAIN IF EXISTS d_eesnimi_perenimi CASCADE;
DROP DOMAIN IF EXISTS d_isikukood CASCADE;
DROP DOMAIN IF EXISTS d_email CASCADE;
DROP DOMAIN IF EXISTS d_kasutajanimi CASCADE;
DROP DOMAIN IF EXISTS d_kogus CASCADE;
DROP DOMAIN IF EXISTS d_aeg CASCADE;

CREATE DOMAIN d_hind AS  DECIMAL ( 10, 2 ) NOT NULL
CONSTRAINT chk_Kaup_hind_pole_negatiivne CHECK (VALUE>= 0::decimal);

CREATE DOMAIN d_nimetus  AS VARCHAR ( 60 ) NOT NULL
CONSTRAINT chk_Nimetus_ei_koosne_tyhikutest CHECK (VALUE!~'^[[:space:]]+$')
CONSTRAINT chk_Nimetus_ei_tohi_olla_tyhi_string CHECK (VALUE!='');

CREATE DOMAIN d_kirjeldus  AS VARCHAR ( 255 ) NOT NULL
CONSTRAINT chk_Kirjeldus_ei_koosne_tyhikutest CHECK (VALUE!~'^[[:space:]]*$')
CONSTRAINT chk_Kirjeldus_ei_tohi_olla_tyhi_string CHECK (VALUE!='');


CREATE DOMAIN d_eesnimi_perenimi VARCHAR ( 30 ) NOT NULL
CONSTRAINT chk_Isik_nimi CHECK (VALUE~'^[[:upper:]][[:lower:]]+([-][[:upper:]][[:lower:]])*$')
CONSTRAINT chk_Isik_nimi_ei_tohi_ola_tyhi_string CHECK (VALUE!='');


CREATE DOMAIN d_isikukood CHAR ( 11 ) NOT NULL
CONSTRAINT chk_Isik_isikukood_on_unikaalne CHECK (VALUE~'^([3-6]{1}[[:digit:]]{2}[0-1]{1}[[:digit:]]{1}[0-3]{1}[[:digit:]]{5})$');

CREATE DOMAIN d_email VARCHAR ( 50 ) NOT NULL
CONSTRAINT chk_Isik_email_sisaldab_at_marki CHECK (VALUE~'^([a-zA-Z0-9_.-]+@[a-z0-9]+[.][a-z]+)$');

CREATE DOMAIN d_kasutajanimi VARCHAR ( 20 ) NOT NULL
CONSTRAINT chk_Isik_kasutajanimi_ei_tohi_olla_vahem_4 CHECK (length(VALUE)>=4)
CONSTRAINT chk_Isik_kasutajanimi_ei_koosne_tyhikutest CHECK (VALUE!~'^[[:space:]]*$')
CONSTRAINT chk_Isik_kasutajanimi CHECK (VALUE!~'(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,15})$');


CREATE DOMAIN d_aeg
AS timestamp without time zone
DEFAULT ('now'::text)::timestamp(0) without time zone
NOT NULL
CONSTRAINT chk_Kaup_loomise_aeg_peale_2000 CHECK (VALUE > '2000-01-01 00:00:00'::timestamp without time zone)
CONSTRAINT chk_Kaup_loomise_aeg_pole_tulevikus CHECK (VALUE <= 'now'::text::timestamp(0) without time zone);


CREATE DOMAIN d_kogus SMALLINT NOT NULL 
CONSTRAINT chk_Kaup_kogus_pole_negatiivne CHECK (VALUE>= 0::smallint);

CREATE DOMAIN d_hinnang AS smallint
CONSTRAINT chk_Kaup_hinnang_ei_tohi_rohkem_kui_5 CHECK (VALUE>=0::smallint AND VALUE<=5::smallint);

CREATE TABLE Isiku_seisundi_liik (
	Isiku_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus d_nimetus,
	kirjeldus d_kirjeldus,
	CONSTRAINT AK_Isiku_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_Isiku_seisundi_liik_kood PRIMARY KEY (isiku_seisundi_liik_kood)
	);
CREATE TABLE Kauba_seisundi_liik (
	Kauba_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus d_nimetus,
	kirjeldus d_kirjeldus,
	CONSTRAINT AK_Kauba_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_Kauba_seisundi_liik_kood PRIMARY KEY (kauba_seisundi_liik_kood)
	);
CREATE TABLE Kaup (
	Kaup_ID SERIAL NOT NULL,
	Kauba_seisundi_liik_kood SMALLINT DEFAULT 1 NOT NULL,
	Kauba_kategooria_kood SMALLINT NOT NULL,	
	Tootja_kood SMALLINT NOT NULL,
	isikukood  d_isikukood,
	nimetus d_nimetus,
	hetke_hind  d_hind,
	kirjeldus d_kirjeldus,
	loomise_aeg d_aeg,
	kogus d_kogus,
	pilt VARCHAR(255),
	CONSTRAINT AK_Kaup_kauba_kategooria_kood_nimetus UNIQUE (kauba_kategooria_kood, nimetus),
	CONSTRAINT PK_Kaup_kaup_ID PRIMARY KEY (kaup_id)
	);
CREATE INDEX idx_Kaup_tootja_kood ON Kaup (tootja_kood);
CREATE INDEX idx_Kaup_kauba_seisundi_liik_kood ON Kaup (kauba_seisundi_liik_kood );
CREATE INDEX idx_Kaup_isikukood ON Kaup(isikukood );
CREATE TABLE Tootaja_seisundi_liik (
	Tootaja_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus d_nimetus,
	kirjeldus d_kirjeldus,
	CONSTRAINT AK_Tootaja_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_Tootaja_seisundi_liik_kood PRIMARY KEY (tootaja_seisundi_liik_kood)
	);
CREATE TABLE Tootaja (
	isikukood  d_isikukood,
	Tootaja_seisundi_liik_kood SMALLINT DEFAULT 1 NOT NULL,
	Amet_kood SMALLINT NOT NULL,
	CONSTRAINT PK_Tootaja_isikukood PRIMARY KEY (isikukood)
	);
CREATE INDEX idx_Tootaja_tootaja_seisundi_liik_kood ON Tootaja (tootaja_seisundi_liik_kood);
CREATE INDEX idx_Tootaja_ameti_kood ON Tootaja (amet_kood);
CREATE TABLE Kauba_kategooria (
	Kauba_kategooria_kood SMALLINT NOT NULL,
	nimetus d_nimetus,
	kirjeldus d_kirjeldus,
	CONSTRAINT AK_Kauba_kategooria_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_Kauba_kategooria_kood PRIMARY KEY (kauba_kategooria_kood)
	);
CREATE TABLE Tootja (
	Tootja_kood SMALLINT NOT NULL,
	nimetus d_nimetus,
	kirjeldus d_kirjeldus,
	CONSTRAINT PK_Tootja_tootja_kood PRIMARY KEY (tootja_kood)
	
	);
CREATE TABLE Hinnang_kommentaar (
	hinnang_id SERIAL NOT NULL,
	isikukood d_isikukood,
	kaup_id integer NOT NULL,
	hinnang d_hinnang,
	kommentaar VARCHAR ( 255 ),
	CONSTRAINT PK_Hinnang_kommentaar_id PRIMARY KEY (hinnang_id)	
	);
CREATE INDEX idx_Hinnang_kaup_id ON Hinnang_kommentaar(kaup_id );
CREATE INDEX idx_Hinnang_kommentaar_isikukood ON Hinnang_kommentaar(isikukood );	
CREATE TABLE Isik (
	isikukood d_isikukood,
	Isiku_seisundi_liik_kood SMALLINT NOT NULL,
	eesnimi d_eesnimi_perenimi,
	perekonnanimi d_eesnimi_perenimi,
	kasutajanimi d_kasutajanimi,
	parool VARCHAR ( 60 ) NOT NULL,
	e_mail d_email,
	CONSTRAINT PK_Isik_isikukood PRIMARY KEY (isikukood),
	CONSTRAINT AK_Isik_kasutajanimi UNIQUE (kasutajanimi)
	);
CREATE INDEX idx_Isik_isiku_seisundi_liik_kood ON Isik (isiku_seisundi_liik_kood);
CREATE TABLE Amet (
	Amet_kood SMALLINT NOT NULL,
	nimetus d_nimetus,
	kirjeldus d_kirjeldus,
	CONSTRAINT PK_Amet_amet_kood PRIMARY KEY (amet_kood),
	CONSTRAINT AK_Amet_nimetus UNIQUE (nimetus)
	);
ALTER TABLE Kaup ADD CONSTRAINT FK_Kauba_seisundi_liik_kood FOREIGN KEY (kauba_seisundi_liik_kood) REFERENCES Kauba_seisundi_liik (kauba_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE Kaup ADD CONSTRAINT FK_Kauba_kategooria_kood FOREIGN KEY (kauba_kategooria_kood) REFERENCES Kauba_kategooria (kauba_kategooria_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE Kaup ADD CONSTRAINT FK_Tootja_kood FOREIGN KEY (tootja_kood) REFERENCES Tootja (tootja_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Kaup ADD CONSTRAINT FK_Kaup_isikukood FOREIGN KEY (isikukood) REFERENCES Tootaja (isikukood)  ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE Tootaja ADD CONSTRAINT FK_Tootaja FOREIGN KEY (isikukood) REFERENCES Isik (isikukood)  ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Tootaja ADD CONSTRAINT FK_Tootaja_tootaja_seisundi_liik_kood FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES Tootaja_seisundi_liik (tootaja_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE Tootaja ADD CONSTRAINT FK_Tootaja_isikukood FOREIGN KEY (amet_kood) REFERENCES Amet (amet_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Isik ADD CONSTRAINT FK_Isik_Isiku_seisundi_liik_kood FOREIGN KEY (Isiku_seisundi_liik_kood) REFERENCES Isiku_seisundi_liik (Isiku_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE Hinnang_kommentaar ADD CONSTRAINT FK_Hinnang_kommentaar_isikukood FOREIGN KEY (isikukood) REFERENCES Tootaja (isikukood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Hinnang_kommentaar ADD CONSTRAINT FK_Hinnang_kommentaar_kaup_id FOREIGN KEY (kaup_id) REFERENCES Kaup (kaup_id)  ON DELETE NO ACTION ON UPDATE CASCADE;