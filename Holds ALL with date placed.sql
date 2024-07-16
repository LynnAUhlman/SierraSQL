SELECT 
  pv.barcode AS "PBarcode", 
  COALESCE(
    CAST(
        NULLIF(
        (
            ( pv.record_num % 10 ) * 2 +
            ( pv.record_num / 10 % 10 ) * 3 +
            ( pv.record_num / 100 % 10 ) * 4 +
            ( pv.record_num / 1000 % 10 ) * 5 +
            ( pv.record_num / 10000 % 10 ) * 6 +
            ( pv.record_num / 100000 % 10 ) * 7 +
            ( pv.record_num / 1000000 % 10  ) * 8 +
            ( pv.record_num / 10000000 ) * 9
         ) % 11,
         10
         )
  AS CHAR(1)
  ),
  'x'
 ) AS  "Patron #",
  pv.home_library_code AS "Home Library",
  iv.barcode AS "IBarcode",
   iv.record_type_code||iv.record_num||
	COALESCE(
    	CAST(
        	NULLIF(
        	(
				( iv.record_num % 10 ) * 2 +
				( iv.record_num / 10 % 10 ) * 3 +
				( iv.record_num / 100 % 10 ) * 4 +
				( iv.record_num / 1000 % 10 ) * 5 +
				( iv.record_num / 10000 % 10 ) * 6 +
				( iv.record_num / 100000 % 10 ) * 7 +
				( iv.record_num / 1000000 % 10  ) * 8 +
				( iv.record_num / 10000000 ) * 9
			 ) % 11,
			 10
			 )
	  AS CHAR(1)
	  ),
	  'x'
 ) AS "Item #",
  h.placed_gmt AS "Date placed",
  h.expires_gmt AS "Hold Expires",
  h.on_holdshelf_gmt AS "Put on Holdshelf",
  h.location_code AS "Branch Location", 
  h.pickup_location_code AS "P/U Location", 
  h.is_ir  AS "IR", 
  h.ir_pickup_location_code AS "IR P/U Location",
  h.is_ir_converted_request AS "IR Converted Rqst",
  h.ir_print_name AS "IR Print Name",
  h.ir_delivery_stop_name AS "IR Delivery Stop Name",
  CASE
	WHEN h.status = '0' THEN 'on hold'
	WHEN h.status = 't' THEN 'in transit'
	WHEN h.status = 'b' THEN 'bib hold ready for pick up'
	WHEN h.status = 'i' THEN 'item hold ready for pick up'
	WHEN h.status = 't' THEN 'in transit to pickup loc'
	ELSE 'on holdshelf'
  END AS "Hold Status",
CASE  
	WHEN iv.item_status_code = '-' THEN 'AVAILABLE'
	WHEN iv.item_status_code = 'm' THEN 'MISSING'
	WHEN iv.item_status_code = 'z' THEN 'CL RETURNED'
	WHEN iv.item_status_code = 'o' THEN 'LIB USE ONLY'
	WHEN iv.item_status_code = 'n' THEN 'BILLED NOTPAID'
	WHEN iv.item_status_code = '$' THEN 'BILLED PAID'
	WHEN iv.item_status_code = 't' THEN 'IN TRANSIT'
	WHEN iv.item_status_code = '!' THEN 'ON HOLDSHELF'
	WHEN iv.item_status_code = 'l' THEN 'LOST'
	WHEN iv.item_status_code = '@' THEN 'OFF SITE'
	WHEN iv.item_status_code = '#' THEN 'RECEIVED'
	WHEN iv.item_status_code = '%' THEN 'RETURNED'
	WHEN iv.item_status_code = '_' THEN 'REREQUEST'
	WHEN iv.item_status_code = '(' THEN 'PAGED'
	WHEN iv.item_status_code = ')' THEN 'CANCELLED'
	WHEN iv.item_status_code = '1' THEN 'LOAN REQUESTED'
  END AS "Item Status",
COALESCE(TO_CHAR(h.on_holdshelf_gmt,'YYYY-mm-dd'),'N/A') AS "On Holdshelf",
COALESCE(TO_CHAR(h.expire_holdshelf_gmt,'YYYY-mm-dd'),'N/A') AS "P/U Expiration",
CASE
	WHEN hr.holdshelf_status = 'c' THEN 'cancelled'
	WHEN hr.holdshelf_status = 'p' THEN 'picked up'
	WHEN hr.holdshelf_status = '!' THEN 'on holdshelf'
	WHEN hr.holdshelf_status = '-' THEN 'available'
	WHEN hr.holdshelf_status = 'm' THEN 'missing'
	ELSE 'N/A'
  END AS "Holdshelf status",
  h.is_frozen AS "Frozen"

FROM 
  sierra_view.hold h
  
JOIN
  sierra_view.hold_removed hr
ON
  h.record_id = hr.record_id

JOIN
	sierra_view.record_metadata rm
ON
	h.record_id = rm.id

JOIN
  sierra_view.item_view iv
ON
  h.record_id = iv.id

JOIN
  sierra_view.item_record ir
ON
  h.record_id = ir.record_id

JOIN
  sierra_view.patron_record pr
ON
  h.patron_record_id = pr.record_id

JOIN
  sierra_view.patron_view pv
ON
  h.patron_record_id = pv.id
  
WHERE
  h.placed_gmt BETWEEN '05-01-2024' AND '07-15-2024'