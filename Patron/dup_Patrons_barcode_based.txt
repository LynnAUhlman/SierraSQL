select count(patron_view.barcode) as numDups, patron_view.barcode, patron_view.home_library_code 
from sierra_view.patron_view
where patron_view.home_library_code like '%'
Group by barcode, patron_view.home_library_code
Having count(patron_view.barcode) > 1
  ;  
