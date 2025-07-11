\c disaster
  
COPY Site (data) FROM program 'sed -e ''s/\\/\\\\/g'' /tmp/m2bench/disaster/json/Site.json';
CREATE INDEX Site_geometry_idx ON Site USING GIST(ST_GeomFromGeoJSON(data ->> 'geometry'::text));
CREATE UNIQUE INDEX Site_id_idx ON Site USING btree (((data->>'site_id')::int));
CREATE INDEX Site_type_idx On Site USING btree (((data->'properties'->>'type')::text));


-- COPY Site_centroid (data) FROM program 'sed -e ''s/\\/\\\\/g'' /home/agens/m2bench/Datasets/disaster/json/Site_centroid.json';
COPY Site_centroid (data) FROM '/tmp/m2bench/disaster/json/Site_centroid_mod.json';
CREATE INDEX Site_centroid_geometry_idx ON Site_centroid USING GIST((ST_GeomFromGeoJSON(data ->> 'centroid'::text)::geography));
CREATE UNIQUE INDEX Site_centroid_id_idx ON Site_centroid USING btree (((data->>'site_id')::int));
CREATE INDEX Site_centroid_type_idx On Site_centroid USING btree (((data->'properties'->>'type')::text));
