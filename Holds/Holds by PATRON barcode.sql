SELECT 
  pv.barcode AS "patron barcode", 
  iv.barcode AS "item barcode", 
  hld.placed_gmt AS "Date placed", 
  hld.is_ir_converted_request AS "IR Converted Rqst", 
  hld.pickup_location_code AS "P/U Location", 
  hld.is_ir AS "IR", 
  hld.status AS "Hold Status",
  ct.source_code  AS "Trans Source",
  ct.application_name AS "Method Placed",
  ct.op_code AS "Transaction Type",
  sgn.name  AS "Stat Group"
  
FROM 
  sierra_view.hold hld

JOIN sierra_view.circ_trans ct ON ct.patron_record_id = hld.patron_record_id 
JOIN sierra_view.statistic_group_myuser sgn ON ct.stat_group_code_num = sgn.code 
JOIN sierra_view.item_view iv ON iv.id = hld.record_id 
JOIN sierra_view.patron_view pv ON hld.patron_record_id = pv.id

WHERE 
pv.barcode = ''
;
