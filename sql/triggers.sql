CREATE FUNCTION f_kauba_seisundi_kontroll() RETURNS trigger AS $$
    BEGIN
        
        IF NEW.kauba_seisundi_liik_kood = 3  THEN
            RAISE EXCEPTION 'Kauba lisamisel ei sa olla seisundis kustutatud';
        END IF;
        
        
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_seisundi_kontroll BEFORE INSERT OR UPDATE ON Kaup
    FOR EACH ROW EXECUTE PROCEDURE f_kauba_seisundi_kontroll();
	
COMMENT ON FUNCTION  f_kauba_seisundi_kontroll() IS 'See trigeri funktsioon aitab joustada arireegli: Ei saa lisada kauba seisundis kustutatud';

CREATE FUNCTION f_oigus_lisada() RETURNS trigger AS $$
    BEGIN
       
        IF NEW.isikukood  in(SELECT isikukood FROM tootaja where amet_kood !=1) THEN
            RAISE EXCEPTION 'Kaup saab lisada voi andmeid muuda ainult administraator';
        END IF;
        
        
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_kaupa_lisamine BEFORE INSERT OR UPDATE ON Kaup
    FOR EACH ROW EXECUTE PROCEDURE f_oigus_lisada();	
	
COMMENT ON FUNCTION f_oigus_lisada() IS 'See trigeri funktsioon aitab joustada arireegli: Kaup saab lisada voi andmeid muuda ainult administraator';