CREATE OR REPLACE VIEW aktiivsete_kaupade_nimekiri WITH (security_barrier=true) AS 
SELECT kaup.kaup_id,
    kaup.nimetus,
	kaup.kirjeldus,
    kaup.hetke_hind,
	kaup.kogus,
	tootja.nimetus AS tootja,
	kauba_kategooria.nimetus AS kategooria_nimetus,
    kauba_kategooria.kirjeldus AS kategooria_kirjeldus,
    kaup.loomise_aeg
    
   FROM kaup   
   JOIN kauba_kategooria USING (kauba_kategooria_kood)
   JOIN tootja USING (tootja_kood)
   WHERE kauba_seisundi_liik_kood=1
   ORDER BY kaup.loomise_aeg DESC;
  
COMMENT ON VIEW aktiivsete_kaupade_nimekiri IS 'Vaade leiab andmed aktiivse kauba kohta,mis on praegu muugil'; 
 
CREATE OR REPLACE VIEW mitteaktiivsete_kaupade_nimekiri WITH (security_barrier=true) AS 
SELECT kaup.kaup_id,
    kaup.nimetus,
	kaup.kirjeldus,
    kaup.hetke_hind,
	kaup.kogus,
	tootja.nimetus AS tootja,
	kauba_kategooria.nimetus AS kategooria_nimetus,
    kauba_kategooria.kirjeldus AS kategooria_kirjeldus,
    kaup.loomise_aeg
    
   FROM kaup   
   JOIN kauba_kategooria USING (kauba_kategooria_kood)
   JOIN tootja USING (tootja_kood)
   WHERE kauba_seisundi_liik_kood=2
   ORDER BY kaup.loomise_aeg DESC;
  

COMMENT ON VIEW mitteaktiivsete_kaupade_nimekiri IS 'Vaade leiab andmed  mitteaktiivse kauba kohta,mis on olemas, aga praegu ei ole muugil';

	
	
	
CREATE OR REPLACE VIEW tootajate_nimekiri WITH (security_barrier=true) AS 
SELECT isik.isikukood,
	isik.eesnimi || ' '||  isik.perekonnanimi AS nimi,
	isik.kasutajanimi,
	isik.e_mail,
	amet.nimetus AS amet,
	amet.kirjeldus AS ameti_kirjeldus	
FROM isik
JOIN tootaja USING (isikukood)
JOIN amet USING (amet_kood);

COMMENT ON VIEW tootajate_nimekiri IS 'Vaade leiab kogu tootajate nimeriki,kes voib tootada infosustemiga ';


CREATE OR REPLACE VIEW kogu_kaupade_nimekiri WITH (security_barrier=true) AS 
 SELECT kaup.kaup_id,
	kauba_seisundi_liik.nimetus AS seisundi_nimetus,
    kaup.nimetus,
	kaup.hetke_hind,
    kaup.kogus,
	kaup.kirjeldus AS kirjeldus,
    tootja.nimetus AS tootja,
    kauba_kategooria.nimetus AS kategooria_nimetus,
	kauba_kategooria.kirjeldus AS kategooria_kirjeldus,    
    kaup.loomise_aeg
   FROM kaup
     JOIN kauba_kategooria USING (kauba_kategooria_kood)
     JOIN kauba_seisundi_liik USING (kauba_seisundi_liik_kood)
     JOIN tootja USING (tootja_kood)
  ORDER BY kaup.loomise_aeg DESC;
  COMMENT ON VIEW kogu_kaupade_nimekiri IS 'Vaade leiab kogu andmete detail aruande,mis on praegu serveris on';
