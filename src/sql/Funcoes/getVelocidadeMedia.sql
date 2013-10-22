CREATE OR REPLACE FUNCTION getVelocidadeMedia (id INTEGER) RETURNS REAL AS $$
    DECLARE
        pointA Geometry;
        pointB Geometry;

        timeA TIMESTAMP;
        timeB TIMESTAMP;

        result INTEGER;

        distance REAL;
        diffTime REAL;

        points CURSOR FOR SELECT ST_GeomFromText('POINT (' || lat || ' ' || long || ')', 4291) AS geom, time FROM localization WHERE id_onibus = id ORDER BY time DESC LIMIT 2;
    BEGIN
        OPEN points;
        FETCH points INTO pointA, timeA;
        FETCH points INTO pointB, timeB;

        distance = ST_Distance(ST_Transform(pointA, 26986), ST_Transform(pointB, 26986));

        WHILE distance = 0 LOOP
            FETCH points INTO pointB, timeB;
            distance = ST_Distance(ST_Transform(pointA, 26986), ST_Transform(pointB, 26986));
        END LOOP;

        CLOSE points;

        diffTime = EXTRACT(EPOCH FROM (timeA - timeB));

        RETURN ( distance / diffTime );

    END;
    $$ LANGUAGE plpgsql;