# Add stock_id to a GL transaction.
# The stock_id refers to a transaction line
# in the corresponding transaction table
# (.e.g 0_debtor_trans_details)
# This field will allow us to filter gl_trans
# by stock_id by joining to the corresponding table.
# Therefore, we need an index.
 
ALTER TABLE 0_gl_trans
ADD `stock_id` VARCHAR(20)
,ADD KEY `stock_id` (`stock_id`(20))
;

