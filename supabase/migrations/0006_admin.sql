-- =============================================================================
-- 0006_admin.sql — migration helper for the one-time Google Sheets import
--
-- Run this ONCE in the Supabase SQL Editor before bulk-importing historical
-- data with scripts/migrate. It is incremental — do NOT re-run the whole schema.
--
-- The transactional triggers from 0002 are great for live use (they adjust
-- stock, write the audit trail and notify owners) but wrong for a historical
-- bulk load: they would double-count stock and create a notification per row.
-- This SECURITY DEFINER helper lets the service-role migration script switch
-- just those side-effect triggers off for the load and back on afterwards. The
-- document-numbering triggers are deliberately left untouched so any imported
-- record without a number still gets a SAL-/PUR-/EXP- value.
-- =============================================================================

create or replace function public.set_transaction_triggers(p_enabled boolean)
  returns void language plpgsql security definer set search_path = public as $$
begin
  if p_enabled then
    alter table sales          enable trigger trg_new_sale;
    alter table sale_items     enable trigger trg_sale_item;
    alter table purchases      enable trigger trg_new_purchase;
    alter table purchase_items enable trigger trg_purchase_item;
    alter table expenses       enable trigger trg_new_expense;
  else
    alter table sales          disable trigger trg_new_sale;
    alter table sale_items     disable trigger trg_sale_item;
    alter table purchases      disable trigger trg_new_purchase;
    alter table purchase_items disable trigger trg_purchase_item;
    alter table expenses       disable trigger trg_new_expense;
  end if;
end $$;

-- Only the service role (used by the migration script) should ever call this.
revoke all on function public.set_transaction_triggers(boolean) from public;
revoke all on function public.set_transaction_triggers(boolean) from anon, authenticated;
