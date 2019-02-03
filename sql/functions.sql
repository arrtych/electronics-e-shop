/*Parooli krupteerimine*/
CREATE EXTENSION pgcrypto;
UPDATE isik
SET parool = public.crypt(parool,public.gen_salt('bf', 11));

/*Administratori sisselogimine*/
CREATE OR REPLACE FUNCTION f_on_admin( text, text)
  RETURNS boolean AS
$$
DECLARE
rslt boolean;
BEGIN
SELECT INTO rslt (isik.parool = public.crypt($2, isik.parool))
FROM isik 
JOIN tootaja ON isik.isikukood = tootaja.isikukood
WHERE isik.kasutajanimi=$1
AND tootaja.amet_kood = 1 AND tootaja.tootaja_seisundi_liik_kood = 1;

RETURN coalesce(rslt, FALSE);
END;
$$
  LANGUAGE plpgsql STABLE SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_on_admin(text, text) IS 'Selle
funktsiooni abil autenditakse administraatori nagu infosusteemi tootajat.Funktsiooni
valjakutsel on esimene argument kasutajanimi ja teine
argument parool.Isikul on oigus susteemi siseneda administraatorina,
vaid siis kui tema amet_kood=1 ja seisundiks on tootab. Funktsioon realiseerib andmebaasioperatsioon OP4.1';

-- TEST
SELECT f_on_admin('ljoha.le','1337');



CREATE OR REPLACE FUNCTION f_on_tootaja( text, text)
  RETURNS boolean AS
$$
DECLARE
rslt boolean;
BEGIN
SELECT INTO rslt (isik.parool = public.crypt($2, isik.parool))
FROM isik 
JOIN tootaja ON isik.isikukood = tootaja.isikukood
 WHERE kasutajanimi=$1 
 AND tootaja.amet_kood BETWEEN 1 AND 3;

RETURN coalesce(rslt, FALSE);
END;
$$
  LANGUAGE plpgsql STABLE SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_on_tootaja(text, text) IS 'Selle
funktsiooni abil autenditakse infosusteemi tootajat.Funktsiooni
valjakutsel on esimene argument kasutajanimi ja teine
argument parool.Tootajal on oigus susteemi siseneda,
vaid siis kui tema seisundiks on tootab.';

/*Test*/
SELECT f_on_tootaja('artur.li','1228');



/*Kauba kustutamine tabelist*/
CREATE OR REPLACE FUNCTION f_kaupade_kustutamine(kaup_kood
Kaup.kaup_id%TYPE) RETURNS BOOLEAN
AS $$
BEGIN
DELETE FROM Kaup WHERE kaup_ID=kaup_kood;
IF NOT FOUND THEN
RETURN FALSE;
ELSE
RETURN TRUE;
END IF;
END; $$
LANGUAGE plpgsql SECURITY DEFINER STRICT
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_kaupade_kustutamine(kaup_kood
Kaup.kaup_id%TYPE) IS 'Selle funktsiooni abil voib kaupa andmebaasist kustutada.Selle funktsiooni abil voib kaupa andmebaasist kustutada OP5.1';




/*Kaupade andmete muutmine*/
CREATE OR REPLACE FUNCTION f_kaupade_muutmine(
p_kaupID Kaup.kaup_ID%TYPE,
p_nimetus Kaup.nimetus%TYPE,
p_hetkeHind Kaup.hetke_hind%TYPE,
p_kirjeldus Kaup.kirjeldus%TYPE,
p_pilt Kaup.pilt%TYPE,
p_kogus Kaup.kogus%TYPE)

RETURNS VOID AS $$
	UPDATE Kaup SET
	
		nimetus = p_nimetus,
		hetke_hind = p_hetkeHind,
		kirjeldus = p_kirjeldus,
		pilt = p_pilt,
		kogus = p_kogus
		WHERE kaup_ID = p_kaupID
		AND kauba_seisundi_liik_kood  BETWEEN 1 AND 2;
		
$$ LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;



-- Kaupade andmete muutmine
COMMENT ON FUNCTION f_kaupade_muutmine(
p_kaupID Kaup.kaup_ID%TYPE,
p_nimetus Kaup.nimetus%TYPE,
p_hetkeHind Kaup.hetke_hind%TYPE,
p_kirjeldus Kaup.kirjeldus%TYPE,
p_pilt Kaup.pilt%TYPE,
p_kogus Kaup.kogus%TYPE) IS 'Selle
funktsiooni abil administraatori voimaldab kaupade andmete muuda.Funktsiooni
valjakutsel argumentid on: kaupID,kauba nimetus,hind,kirjeldus,pildi asukoht,kogus .Isikul on oigus susteemi andmete muuda 
vaid siis kui ta voimaldab administraatori oigusega ja  tema amet_kood=1.Funktsioon realiseerib andmebaasioperatsiooni OP6.1';
--TEST
SELECT * FROM f_kaupade_muutmine(81299345,'LLenox',5.00,'vana version','hgjh',3::SMALLINT);






CREATE OR REPLACE FUNCTION f_muuda_kaup_mitteaktiivseks(kaup_kood integer)
  RETURNS boolean AS
$BODY$
BEGIN
	UPDATE Kaup
	SET Kauba_seisundi_liik_kood = 2
	WHERE kaup_id = kaup_kood;
	IF FOUND THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END;
$BODY$
LANGUAGE plpgsql SECURITY DEFINER STRICT
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_muuda_kaup_mitteaktiivseks(kaup_kood integer) IS 'Selle funktsiooni abiladministraator voimaldab kauba seisundi mitteaktiivseks muuta.See funktsioon realiseerib
andmebaasioperatsiooni OP4.1.Funktsiooni valjakutsel argument on kaup id';


CREATE OR REPLACE FUNCTION f_muuda_kaup_aktiivseks(kaup_kood integer)
  RETURNS boolean AS
$BODY$
BEGIN
	UPDATE Kaup
	SET Kauba_seisundi_liik_kood = 1
	WHERE kaup_id = kaup_kood;
	IF FOUND THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_muuda_kaup_aktiivseks(integer) IS 'Selle funktsiooni abil administraator voimaldab kauba seisundi aktiivseks muuta. See funktsioon realiseerib
andmebaasioperatsiooni OP4.2.Funktsiooni valjakutsel argument on kaup id';


CREATE OR REPLACE FUNCTION f_lisa_kaup(
    p_kauba_seisund smallint,
    p_kaupa_kategooria_kood smallint,
    p_tootja_kood smallint,
    p_isikukood d_isikukood,
    p_nimetus d_nimetus,
    p_hind d_hind,
    p_kirjeldus d_kirjeldus,
    p_kogus smallint,
    p_pilt varchar(255))
  RETURNS integer AS
$BODY$
  DECLARE
	id_val int;
 BEGIN
 INSERT INTO Kaup (
	
		kauba_seisundi_liik_kood, kauba_kategooria_kood, tootja_kood,
		isikukood,
		nimetus, hetke_hind, kirjeldus, loomise_aeg,kogus,pilt)
	VALUES( 
		p_kauba_seisund, p_kaupa_kategooria_kood, p_tootja_kood, 
		p_isikukood,p_nimetus,p_hind,p_kirjeldus,date_trunc('minute',localtimestamp(0)),p_kogus,p_pilt
	)RETURNING kaup_id INTO id_val;
   
   RETURN id_val;
 END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_lisa_kaup(smallint, smallint, smallint, d_isikukood, d_nimetus, d_hind, d_kirjeldus, smallint, character varying) IS 'Selle
funktsiooni abil administraator voimaldab kaupade andmebaasi lisada.See funktsioon realiseerib
andmebaasioperatsiooni OP2.1 Funktsiooni
valjakutsel argumentid on: kauba seisund liik,kauba kategooria kood,tootja kood,isikukood,kauba nimetus,hind,kirjeldus,kogus,pildi asukoht .Isikul on oigus susteemi kauba andmete lisada 
vaid siis kui ta voimaldab administraatori oigusega ja  tema amet_kood=1';

-- TEST
SELECT * FROM f_lisa_kaup(
1::SMALLINT,4::SMALLINT,2::SMALLINT,'39212233718','Asus computer Z2',1000,'hea arvuti',5::smallint,''
);


CREATE OR REPLACE FUNCTION f_kaup_pildi_lisamine(
	p_kaupID Kaup.kaup_id%TYPE,
	p_pilt text)
 RETURNS void AS
$BODY$

UPDATE Kaup SET pilt=p_pilt
WHERE kaup_id = p_kaupID
	
$BODY$	
LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_kaup_pildi_lisamine(p_kaupID Kaup.kaup_id%TYPE,
	p_pilt text) IS 'See fuknsioon voimaldab pildi lisada kauba juurde andmebaasis';

-- TEST
select * from f_kaup_pildi_lisamine(6::smallint,'kj');



CREATE OR REPLACE FUNCTION f_vali_kategoria(IN integer)
  RETURNS TABLE(nimetus d_nimetus, tootja d_nimetus, hetke_hind d_hind, kirjeldus d_kirjeldus, loomise_aeg d_aeg, kogus d_kogus, pilt character varying) AS
$BODY$

BEGIN RETURN QUERY
SELECT
Kaup.nimetus,
Tootja.nimetus,
Kaup.hetke_hind,
Kaup.kirjeldus,
Kaup.loomise_aeg,
Kaup.kogus,
Kaup.pilt
FROM Kaup  JOIN Kauba_kategooria USING (kauba_kategooria_kood)
	JOIN tootja USING (tootja_kood)
WHERE Kaup.kauba_kategooria_kood=$1
ORDER BY kaup.loomise_aeg DESC;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  SET search_path = public, pg_temp;
  COMMENT  ON FUNCTION f_vali_kategoria(IN integer) is 'See funktsioon voimaldab naha koik kaup,mis on antud kategoorias';
  
  
CREATE OR REPLACE FUNCTION f_hinnangu_lisamine(
    isikukood Isik.isikukood%TYPE,
kaup_kood Kaup.kaup_id%TYPE,
hinnang hinnang_kommentaar.hinnang%TYPE,
kommentaar hinnang_kommentaar.kommentaar%TYPE)
  RETURNS void AS
$BODY$
BEGIN
 INSERT INTO hinnang_kommentaar (isikukood,kaup_id,hinnang,kommentaar)
	values 
	(isikukood,kaup_kood,hinnang,kommentaar);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  SET search_path = public, pg_temp;
COMMENT  ON FUNCTION f_hinnangu_lisamine(
    isikukood Isik.isikukood%TYPE,
	kaup_kood Kaup.kaup_id%TYPE,
	hinnang hinnang_kommentaar.hinnang%TYPE,
	kommentaar hinnang_kommentaar.kommentaar%TYPE) is 'See funktsioon voimaldab kaubale lisada kommentaari ning hinnangu.Funktsioon realiseerib
andmebaasioperatsiooni OP8.1 ';

-- TEST
select * from f_hinnangu_lisamine('39212233718',95::integer,3::smallint,'gfg');