SELECT
    ct.transaction_gmt AS "Transaction Date",
    ct.op_code AS "Transaction Type",
    ct.application_name AS "Portal",
    ct.due_date_gmt AS "Due Date",
    ct.loanrule_code_num AS "Loan Rule #",
    bv.record_num AS "Bib #",
    bv.title AS "Title",
    iv.record_num AS "Item #",
    iv.barcode AS "Barcode",
    ct.item_location_code AS "Location",
    ct.patron_home_library_code AS "Home Library"
FROM sierra_view.circ_trans AS ct
LEFT JOIN sierra_view.bib_view AS bv
    ON ct.bib_record_id = bv.id
LEFT JOIN sierra_view.item_view AS iv
    ON ct.item_record_id = iv.id
WHERE ct.patron_record_id = (
    SELECT pv.id
    FROM sierra_view.patron_view AS pv
    WHERE pv.barcode = '[insert patron barcode]'
)
AND ct.transaction_gmt >= '[insert start date]'
AND ct.transaction_gmt < '[insert end date]'
ORDER BY ct.transaction_gmt DESC;
