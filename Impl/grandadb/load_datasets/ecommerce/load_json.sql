\c ecommerce;
  
COPY "order" (data) FROM '/tmp/m2bench/ecommerce/json/order.json';
CREATE INDEX order_customer_id_idx ON "order"((data->>'customer_id'));
CREATE INDEX order_order_id_idx ON "order"((data->>'order_id'));
-- can't support this index
-- CREATE INDEX order_orderline_product_id_idx ON "order"((data->'order_line'->>'product_id'));
CREATE INDEX order_orderline_product_id_idx2 ON "order"((data->'order_line'));

COPY review (data) FROM '/tmp/m2bench/ecommerce/json/review.json';
CREATE INDEX review_order_id_idx ON review((data->>'order_id'));
CREATE INDEX review_product_id_idx ON review((data->>'product_id'));
CREATE INDEX ON review(CAST(data->>'rating' AS INT));
CREATE INDEX ON review(CAST(data->>'rating' AS INT), (data->>'order_id'));
