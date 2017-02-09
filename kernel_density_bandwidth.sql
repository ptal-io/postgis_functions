CREATE OR REPLACE FUNCTION kernel_density_bandwidth(tablename varchar) RETURNS double precision AS 
$$
DECLARE
  standard_distance double precision;
  median_dist_sqrt double precision;
  clng double precision;
  clat double precision;
  tmp double precision;
  cnt int;
BEGIN

	-- http://pro.arcgis.com/en/pro-app/tool-reference/spatial-statistics/h-how-standard-distance-spatial-statistic-works.htm
	-- http://pro.arcgis.com/en/pro-app/tool-reference/spatial-analyst/how-kernel-density-works.htm

	EXECUTE 'SELECT st_x(st_centroid(st_union(geom))) FROM '||tablename into clng;
	EXECUTE 'SELECT st_y(st_centroid(st_union(geom))) FROM '||tablename into clat;

	EXECUTE 'SELECT sqrt(sum(c.y)/count(c.y) + sum(c.x)/count(c.x))::float8 FROM 
		(SELECT power(lat - '||clat||', 2) as y, power(lng - '||clng||', 2) as x FROM '||tablename||') c' into standard_distance;

	EXECUTE 'SELECT median(st_distance((select st_centroid(st_union(geom)) as geom from '||tablename||'), geom))*sqrt(1/ln(2)) from '||tablename into median_dist_sqrt;
  	
  	EXECUTE 'SELECT count(*) FROM '||tablename into cnt;

  	tmp := 0.9* least(standard_distance, median_dist_sqrt) * power(cnt,-0.2);

	RETURN tmp;
END;
$$ 
LANGUAGE 'plpgsql' IMMUTABLE;



