 SET client_encoding=UTF8; 

--Klassifikaatorite testing data
INSERT INTO Isiku_seisundi_liik(Isiku_seisundi_liik_kood, nimetus, kirjeldus) VALUES (
	1, 'Aktiivne', 'Sisselooginud Tootaja voi Juhataja'
);
INSERT INTO Isiku_seisundi_liik(Isiku_seisundi_liik_kood, nimetus, kirjeldus) VALUES (
	2, 'Mitteaktiivne', 'Mite sisselooginud kasutaja'
);

INSERT INTO Kauba_seisundi_liik(Kauba_seisundi_liik_kood, nimetus, kirjeldus) VALUES (
		1, 'Aktiivne', 'Kaub on praegu muugil'
);
INSERT INTO Kauba_seisundi_liik(Kauba_seisundi_liik_kood, nimetus, kirjeldus) VALUES (
		2, 'Mitteaktiivne', 'Kaub on olemas, aga praegu ei ole muugil'
);
INSERT INTO Kauba_seisundi_liik(Kauba_seisundi_liik_kood, nimetus, kirjeldus) VALUES (
		3, 'Kustutatud', 'Kaub on kauba loetelust kustutatud ja rohkem ei ole kasutatav'
);

INSERT INTO Tootaja_seisundi_liik(Tootaja_seisundi_liik_kood, nimetus, kirjeldus) VALUES (
		1, 'Tootav', 'Tootav inimesed' 
);
INSERT INTO Tootaja_seisundi_liik(Tootaja_seisundi_liik_kood, nimetus, kirjeldus) VALUES (
		2, 'Puhkus', 'Tootaja, kes praegu on puhkuseperioodil'
);




INSERT INTO Amet(Amet_kood, nimetus, kirjeldus) VALUES (
	1, 'Administraator', 'Kauba andmete muutmine, kustutamine, mitteaktiivseks muutmine, andmete vaatamine ja registreerimine'
);
INSERT INTO Amet(Amet_kood, nimetus, kirjeldus) VALUES (
	2, 'Juhataja','Kauba detailaruande vaatamine'
);
INSERT INTO Amet(Amet_kood, nimetus, kirjeldus) VALUES (
	3, 'Külastaja','Kauba andmete vaatamine'
);


INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	1, 'SAMSUNG Group', 'Telerit'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	2, 'APPLE Inc.', 'Kaekellad'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	3, 'HTC Corporation', 'Telefonid'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	4, 'Atari', 'Video mang PC'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	5, 'Acer', 'Sülearvutid'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	6, 'Alienware', 'Sülearvutid'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	7, 'MSI', 'Sülearvutid'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	8, 'Lenovo', 'Sülearvutid'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	9, 'Fujitsu', 'Sülearvutid'
);

INSERT INTO tootja(tootja_kood, nimetus, kirjeldus) VALUES (
	10, 'Toshiba', 'Sülearvutid'
);

INSERT INTO Kauba_kategooria(Kauba_kategooria_kood, nimetus, kirjeldus) VALUES (
	1, 'Kaekellad', 'Kaasaegsed kaekellad. Varustatud erinevate smart funktsioonidega.'
);
INSERT INTO Kauba_kategooria(Kauba_kategooria_kood, nimetus, kirjeldus) VALUES (
	2, 'Mobiiltelefonid', 'Kaasaegsed mobiiltelefonid ehk smartfonid.'
);
INSERT INTO Kauba_kategooria(Kauba_kategooria_kood, nimetus, kirjeldus) VALUES (
	3, 'Full HD TV', 'Telerit koos korgekvaliteetse pildiga ehk Full HD-ga.'
);
INSERT INTO Kauba_kategooria(Kauba_kategooria_kood, nimetus, kirjeldus) VALUES (
	4, 'Arvutid', 'Sulearvutid, laudaarvutid, tahvelarvutid nii oppimiseks, kui ka tootamiseks.'
);

--Other testing data
INSERT INTO Isik(isikukood, Isiku_seisundi_liik_kood, eesnimi, perekonnanimi, kasutajanimi, parool, e_mail) VALUES (
	'39301142531', 1, 'Aleksei', 'Fjodorov', 'ljoha.le', '1337', 'aleksei.fjodorov@gmail.com'
);
INSERT INTO Isik(isikukood, Isiku_seisundi_liik_kood, eesnimi, perekonnanimi, kasutajanimi, parool, e_mail) VALUES (
	'39212233718', 2, 'Artur', 'Lipin', 'artur.li', '1228', 'artur.lipin@gmail.com'
);
INSERT INTO Isik(isikukood, Isiku_seisundi_liik_kood, eesnimi, perekonnanimi, kasutajanimi, parool, e_mail) VALUES (
	'39311295652', 2, 'Vadim', 'Nekrjatch', 'vadim.ne', '1567', 'vadim.nekrjatch@gmail.com'
);

INSERT INTO Isik(isikukood, Isiku_seisundi_liik_kood, eesnimi, perekonnanimi, kasutajanimi, parool, e_mail) VALUES (
	'39311290000', 2, 'Martin', 'Vehile', 'martin.ve', '1555', 'martinve@gmail.com'
);


INSERT INTO Tootaja(isikukood, Tootaja_seisundi_liik_kood, Amet_kood) VALUES (
	'39301142531', 1, 1
);
INSERT INTO Tootaja(isikukood, Tootaja_seisundi_liik_kood, Amet_kood) VALUES (
	'39212233718', 1, 1
);
INSERT INTO Tootaja(isikukood, Tootaja_seisundi_liik_kood, Amet_kood) VALUES (
	'39311295652', 2, 2
);


INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg, pilt,kogus ) VALUES (
	 1, 4, 2, '39301142531', 'MacBook', 1.400, 'Sulearvuti vaga hea',  date_trunc('minute',LOCALTIMESTAMP(0)),'',1
);

INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg, pilt,kogus ) VALUES (
	 1, 2, 2, '39301142531', 'Samsung Galaxy', 600.00, 'Nutitelefon vaga hea',  date_trunc('minute',LOCALTIMESTAMP(0)),'',1
);

INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg, pilt,kogus ) VALUES (
	 1, 1, 2, '39301142531', 'Apple Watch', 230.00, 'Vaga hea kaekellad',  date_trunc('minute',LOCALTIMESTAMP(0)),'',1
);

INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg, pilt,kogus ) VALUES (
	 1, 3, 2, '39301142531', 'Samsung TV', 1.400, 'Vaga hea teler',  date_trunc('minute',LOCALTIMESTAMP(0)),'',1
);

INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg, pilt,kogus ) VALUES (
	 1, 4, 2, '39301142531', 'Lenova', 1.400, 'Vaga hea arvuti',  date_trunc('minute',LOCALTIMESTAMP(0)),'',1
);

INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg, pilt,kogus ) VALUES (
	 1, 1, 2, '39301142531', 'Samsung watch', 400.00, 'Vaga hea kaekellad',  date_trunc('minute',LOCALTIMESTAMP(0)),'',1
);

INSERT INTO Kaup(kauba_seisundi_liik_kood,kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus ) VALUES (
	1, 2, 3, '39301142531', 'HTC One X', 150.00, 'HTC One X smartfon, 16GB malu, 8 MP kaamera', date_trunc('minute',LOCALTIMESTAMP(0)),1
);
INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus) VALUES (
	2, 2, 2, '39301142531', 'Iphone 5s', 400.00, 'Vana Iphone heas seisundis', '2001-09-28 01:00:00',100
);

INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus ) VALUES (
	1, 3, 1, '39301142531', '48" Full-HD Flat TV J5100 Seri', 1.000, 'Vaga hea ja suur teler', '2001-09-28 01:00:00',22
);
INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus) VALUES (
	1, 4, 1, '39301142531', 'SAMSUNG PC 2000', 400.00, 'Sulearvuti', '2001-09-28 01:00:00',44
);
INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus ) VALUES (
	3, 4, 1, '39301142531', 'SAMSUNG PC 2001', 400.00, 'Sulearvuti', '2001-09-28 01:00:00' ,55
);
INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus ) VALUES (
	3, 4, 1, '39301142531', 'SAMSUNG PC 2002', 400.00, 'Sulearvuti', '2001-09-28 01:00:00' ,44
);

-- INSERT INTO Kaup(kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood, isikukood, nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus ) VALUES (
-- 	2, 1, 2, '39301142531', 'Apple Watch', 1.000, 'Kaekellad, mis on seotud teie mobiiltelefoniga interneti kaudu.', '2001-09-28 01:00:00' ,50
-- );
	
