SELECT 
  pv.barcode AS "PBarcode", 
  pv.record_type_code||pv.record_num||
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
 bv.record_type_code||bv.record_num||
  COALESCE(
      CAST(
          NULLIF(
          (
        ( bv.record_num % 10 ) * 2 +
        ( bv.record_num / 10 % 10 ) * 3 +
        ( bv.record_num / 100 % 10 ) * 4 +
        ( bv.record_num / 1000 % 10 ) * 5 +
        ( bv.record_num / 10000 % 10 ) * 6 +
        ( bv.record_num / 100000 % 10 ) * 7 +
        ( bv.record_num / 1000000 % 10  ) * 8 +
        ( bv.record_num / 10000000 ) * 9
       ) % 11,
       10
       )
    AS CHAR(1)
    ),
    'x'
 ) AS "Bib #",
COALESCE(TO_CHAR(h.placed_gmt,'YYYY-mm-dd'),'N/A') AS "Date placed",
COALESCE(TO_CHAR(h.on_holdshelf_gmt,'YYYY-mm-dd'),'N/A') AS "On Holdshelf",
COALESCE(TO_CHAR(h.expire_holdshelf_gmt,'YYYY-mm-dd'),'N/A') AS "P/U Expiration", 
CASE
  WHEN cir.application_name = 'circ' THEN 'Sierra'
  WHEN cir.application_name = 'circa' THEN 'Circa Inventory'
  WHEN cir.application_name = 'milcirc' THEN 'Millenium Circ'
  WHEN cir.application_name = 'milmyselfcheck' THEN 'MIL SelfCheck'
  WHEN cir.application_name = 'readreq' THEN 'Catalog'
  WHEN cir.application_name = 'selfcheck' THEN 'SelfCheck'
  ELSE  'N/A'
  END AS "Application",
CASE
  WHEN cir.source_code = 'local' THEN 'LOCAL'
  WHEN cir.source_code = 'INN-Reach' THEN 'IR'
  WHEN cir.source_code = 'ILL' THEN 'ILL ???'
  ELSE 'N/A'
  END AS "Source",
CASE
  WHEN cir.op_code = 'o' THEN ''
  WHEN cir.op_code = 'n' THEN ''
  WHEN cir.op_code = 'nb' THEN ''
  WHEN cir.op_code = 'ni' THEN ''
  WHEN cir.op_code = 'nv' THEN ''
  WHEN cir.op_code = 'f' THEN ''
  WHEN cir.op_code = 'b' THEN ''
  WHEN cir.op_code = 'i' THEN ''
  WHEN cir.op_code = 'h' THEN ''
  WHEN cir.op_code = 'hb' THEN ''
  WHEN cir.op_code = 'hi' THEN ''
  WHEN cir.op_code = 'hv' THEN ''
  WHEN cir.op_code = 'r' THEN ''
  WHEN cir.op_code = 'u' THEN ''
  ELSE 'N/A'
  END AS "OP Code",
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

  h.is_frozen AS "Frozen"

FROM 
  sierra_view.hold h

JOIN
  sierra_view.record_metadata rm
ON
  h.record_id = rm.id

  
JOIN
  sierra_view.circ_trans cir
ON
  cir.bib_record_id = h.record_id  OR cir.item_record_id = h.record_id OR cir.patron_record_id = h.patron_record_id

JOIN
  sierra_view.bib_record_item_record_link l
ON
  rm.id = l.item_record_id OR rm.id = l.bib_record_id
  
JOIN
  sierra_view.bib_record br
ON
  l.bib_record_id = br.record_id
  
  JOIN
  sierra_view.bib_view bv
ON
  br.record_id = bv.id

  
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
  h.placed_gmt BETWEEN '05-01-2024' AND '07-16-2024'
