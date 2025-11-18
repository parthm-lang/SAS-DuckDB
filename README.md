**SAS DuckDB:**

**Proc SQL (multi table wildcard):**
This code demonstrates how to perform multi-table SQL queries in SAS using both the traditional SAS engine and the newer sasioduk engine. The first section shows the pre-2025.07 workflow, where 12 monthly SAS datasets must be manually combined into a single annual dataset before running a query. The second section showcases the post-2025.07 approach, where sasioduk reads Parquet files directly and supports wildcard paths, allowing SQL queries to span multiple months or years without data-step consolidation. Together, the code highlights the differences in setup and workflow between SAS dataset processing and the more streamlined, multi-file querying capabilities of sasioduk.


