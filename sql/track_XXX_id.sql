# Add XXX_id to a GL transaction.
# The XXX_id refers to a transaction line
# in the corresponding transaction table
# (.e.g 0_debtor_trans_details)
# This field will allow us to filter gl_trans
# by XXX_id by joining to the corresponding table.
# Therefore, we need an index.
 
ALTER TABLE 0_gl_trans
ADD `XXX_id` VARCHAR(20)
,ADD KEY `XXX_id` (`XXX_id`(20))
;

