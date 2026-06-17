-- =============================================================================
-- 0005_views_and_segments.sql — customer 360 stats (derived live from sales)
-- Run this ONCE in the Supabase SQL Editor (it is incremental — do NOT re-run
-- the whole schema). Safe to re-run on its own.
--
-- customer_stats is the single source of truth for lifetime value, order count
-- and last/first purchase. Because it is derived from `sales`, the moment a sale
-- is recorded every customer page, tier and total updates automatically.
-- security_invoker = true keeps each organization's row-level isolation intact.
-- =============================================================================

alter table customers add column if not exists preferences text;

drop view if exists customer_stats;
create view customer_stats with (security_invoker = true) as
select
  c.*,
  coalesce(sum(s.total_amount), 0)::numeric as total_spent,
  count(s.id)                                as order_count,
  max(s.sale_date)                           as last_purchase,
  min(s.sale_date)                           as first_purchase
from customers c
left join sales s on s.customer_id = c.id
group by c.id;

grant select on customer_stats to authenticated;
