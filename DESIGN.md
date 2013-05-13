How books are represented
=========================

* Books are represented by a title, which has editions, each of which has copies.
* Titles are a container for basic metadata, and have authors
* Editions have isbns and covers, and publishers
* Copies track individual physical books, their status and source (distributors).



How books enter the system
==========================

Suggestions, special orders, tabling and event orders are tracked via Asana, aka out of the purview of this system.

Purchase orders vs invoices
---------------------------

* When we order books, we make a PO. This has line items which associate an edition with a quantity, but do not actually generate a record corresponding to any actual copy of the edition
* Invoices, when entered, should decrement the outstanding_quantity field on the corresponding PO line item, and add an individual record for each copy received. 
* Returns mark associated physical copies as returned






