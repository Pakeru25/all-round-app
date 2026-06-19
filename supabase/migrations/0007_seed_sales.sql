-- =============================================================================
-- 0007_seed_sales.sql — historical sales import (header-only)
-- Loads the "2025 Sales.csv" / "2026 Sales.csv" exports into the sales table.
-- The sheets are one-row-per-line-item; rows sharing an ORDER ID are combined
-- into a single sale (2026 rows have no order id, so each is its own sale).
--
-- These are HEADER-ONLY sales: the sheets' SKUs (T-shirts, Caps, ...) are
-- finished goods that don't exist in inventory, and sale_items.inventory_item_id
-- is NOT NULL, so per-line items can't be linked. The product / SKU / units and
-- sales channel are preserved in each sale's notes instead.
--
-- Money: subtotal = Σ GROSS SALE, total_amount = Σ NET SALES,
--        discount = subtotal − total_amount  (NET = GROSS + ADJUSTMENTS in the
--        source, so a surcharge shows as a negative discount). payment defaults
--        to cash / paid. The customer is matched by name; unmatched -> null
--        (the name is still in the notes).
--
-- Safe to re-run: each sale is matched on (organization_id, sale_date, notes),
-- and the notes carry a unique "Imported ..." tag per source row/order.
-- =============================================================================

-- Silence the per-sale activity-log + owner-notification trigger for this bulk
-- historical load (otherwise every imported sale pings every owner). No
-- sale_items are inserted, so the stock trigger never fires.
alter table sales disable trigger trg_new_sale;

insert into sales
  (organization_id, customer_id, sale_date, subtotal, discount, total_amount,
   payment_method, payment_status, notes)
select o.id, c.id, v.sale_date::date, v.subtotal, v.discount, v.total_amount,
       'cash', 'paid', v.notes
from organizations o
cross join (values
  ('Abeiku', '2025-03-17', 500, -400, 900, 'T-shirt (TSH-WH-L) x2 — retail — Imported 2025 order #1'),
  ('Abeiku', '2025-03-17', 100, 0, 100, 'Cap (C-C) x2 — retail — Imported 2025 order #2'),
  ('Joshua Danjuma', '2025-03-17', 250, 0, 250, 'T-shirt (TSH-C-L) x1 — retail — Imported 2025 order #3'),
  ('Joshua Danjuma', '2025-03-17', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2025 order #4'),
  ('AbdulMatin Mohammed', '2025-03-17', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2025 order #5'),
  ('Tina', '2025-03-17', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #7'),
  ('Twig', '2025-03-18', 500, 0, 500, 'T-shirt (TSH-BK-L) x2 — retail — Imported 2025 order #6'),
  ('Theophilus Amakye', '2025-04-02', 150, 0, 150, 'Cap (C-B, C-C) x3 — retail — Imported 2025 order #17'),
  ('Gladys Marfo', '2025-04-02', 250, 0, 250, 'T-shirt (TSH-WH-L) x1 — retail — Imported 2025 order #20'),
  ('Gladys Marfo', '2025-04-02', 70, 0, 70, 'Tote Bag (T-B) x1 — retail — Imported 2025 order #21'),
  ('Prince', '2025-04-03', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #18'),
  ('Prince', '2025-04-03', 100, 0, 100, 'Cap (C-B) x2 — retail — Imported 2025 order #19'),
  ('Herbert', '2025-04-14', 250, 0, 250, 'T-shirt (C-C,CB) x1 — retail — Imported 2025 order #23'),
  ('Herbert', '2025-04-14', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2025 order #24'),
  ('Emmanuel Kofi Asante', '2025-04-21', 100, 0, 100, 'Cap (C-C,CB) x2 — retail — Imported 2025 order #26'),
  ('Diana Asante', '2025-04-22', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #28'),
  ('Diana Asante', '2025-04-22', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #29'),
  ('Theophilus Amakye', '2025-04-23', 150, 0, 150, 'Cap (C-B, C-C) x3 — retail — Imported 2025 order #25'),
  ('Derrick', '2025-04-23', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2025 order #30'),
  ('Twig', '2025-04-25', 250, 0, 250, 'T-shirt (TSH-WH-L) x1 — retail — Imported 2025 order #27'),
  ('Solomon', '2025-04-28', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2025 order #31'),
  ('Eleazer Asenso', '2025-05-03', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #8'),
  ('Eleazer Asenso', '2025-05-03', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #9'),
  ('Adwoa Siaw', '2025-05-04', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #10'),
  ('Kingsley', '2025-05-05', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #11'),
  ('Kingsley', '2025-05-05', 150, 0, 150, 'Cap (C-B, C-C) x3 — retail — Imported 2025 order #12'),
  ('Paul', '2025-05-06', 150, 0, 150, 'Cap (C-B, C-C) x3 — retail — Imported 2025 order #13'),
  ('Jojo Siaw', '2025-05-07', 100, 0, 100, 'Cap (C-B, C-C) x2 — retail — Imported 2025 order #14'),
  ('Joshua Danjuma', '2025-05-08', 250, 0, 250, 'T-shirt (TSH-B-L) x1 — retail — Imported 2025 order #15'),
  ('Abeiku', '2025-05-09', 1000, 0, 1000, 'Shirts (S-L,S-S) x2 — retail — Imported 2025 order #16'),
  ('Osei Tutu Prince', '2025-05-17', 500, 50, 450, 'Cap (C-B) x10 — retail — Imported 2025 order #32'),
  ('Storm', '2025-05-19', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #33'),
  ('Lamar', '2025-05-19', 100, 0, 100, 'Cap (C-B) x2 — retail — Imported 2025 order #34'),
  ('Lamar', '2025-05-19', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #35'),
  ('Solomon', '2025-05-21', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #36'),
  ('Solomon', '2025-05-21', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #37'),
  ('Bordom Edwin', '2025-05-25', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #38'),
  ('Mawuko', '2025-05-25', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #39'),
  ('Theophelus Opey', '2025-05-26', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #40'),
  ('Theophelus Opey', '2025-05-26', 500, 0, 500, 'T-shirt (TSH-BK-L,TSH-WH-L) x2 — retail — Imported 2025 order #41'),
  ('Samuel Sarfo Sarpong', '2025-05-27', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2025 order #42'),
  ('Loshi', '2025-05-27', 70, 0, 70, 'Tote Bag (T-B) x1 — retail — Imported 2025 order #43'),
  ('Diana Asante', '2025-06-11', 500, 20, 480, 'T-shirt (TSH-WH-L) x2 — retail — Imported 2025 order #44'),
  ('Osei Tutu Prince', '2025-06-15', 1000, 0, 1000, 'Cap (C-B) x20 — retail — Imported 2025 order #47'),
  ('Abeiku', '2025-06-19', 250, 0, 250, 'T-shirt (GYM-WH-L) x1 — retail — Imported 2025 order #50'),
  ('Osei Tutu Prince', '2025-07-04', 100, 0, 100, 'Cap (C-B, C-C) x2 — retail — Imported 2025 order #22'),
  ('Bernice', '2025-07-06', 500, 0, 500, 'T-shirt (TSH-WH-L) x2 — retail — Imported 2025 order #45'),
  ('Bernice', '2025-07-06', 100, 0, 100, 'Cap (C_B&C) x2 — retail — Imported 2025 order #46'),
  ('Bernice', '2025-07-06', 500, 0, 500, 'Shirt (S-S) x1 — retail — Imported 2025 order #48'),
  ('Bernice', '2025-07-06', 70, 0, 70, 'Tote Bag (T-B) x1 — retail — Imported 2025 order #49'),
  ('Ohene Gyan', '2025-07-06', 100, 0, 100, 'Cap (C-C,CB) x2 — retail — Imported 2025 order #51'),
  ('(Owner) Paajoe', '2025-07-06', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #52'),
  ('Ibrahim', '2025-07-09', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #53'),
  ('Derrick Kwesi Owusu', '2025-07-09', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #54'),
  ('Derrick Kwesi Owusu', '2025-07-09', 500, 0, 500, 'Tank-Top (T-T B) x2 — retail — Imported 2025 order #55'),
  ('Diana Asante', '2025-07-10', 250, 0, 250, 'T-shirt (TSH-WH-L) x1 — retail — Imported 2025 order #56'),
  ('Twig', '2025-07-12', 250, 0, 250, 'T-shirt (TSH-WH-L) x1 — retail — Imported 2025 order #57'),
  ('Abeiku', '2025-07-13', 500, 0, 500, 'T-shirt (TSH-WH-L) x2 — retail — Imported 2025 order #58'),
  ('Mr. Silas', '2025-07-14', 100, 0, 100, 'Cap (C-C&B) x2 — retail — Imported 2025 order #59'),
  ('(Owner) Kwadwo Siaw', '2025-07-24', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2025 order #60'),
  ('Ernest Akwasi Boakye', '2025-07-25', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #61'),
  ('Gyima', '2025-07-30', 1000, 0, 1000, 'Shirts (S-L,S-S) x2 — retail — Imported 2025 order #62'),
  ('Gyima', '2025-07-30', 500, 0, 500, 'T-shirts (TSH-WH-L, TSH-BK-L) x2 — retail — Imported 2025 order #63'),
  ('Gyima', '2025-07-30', 100, 0, 100, 'Cap (C-B, C-C) x2 — retail — Imported 2025 order #64'),
  ('Maxwel', '2025-07-31', 100, 0, 100, 'Tote Bag (T-B) x1 — retail — Imported 2025 order #65'),
  ('Chris B', '2025-08-05', 500, -100, 600, 'T-shirt (TSH-BK-L) x2 — retail — Imported 2025 order #66'),
  ('Kukujay', '2025-08-12', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #67'),
  ('Kukujay', '2025-08-12', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #68'),
  ('Gyima', '2025-08-30', 250, 0, 250, 'T-shirt (TSH-WH-L) x1 — retail — Imported 2025 order #69'),
  ('Gyima', '2025-08-30', 1000, 0, 1000, 'Shirts (S-Y,S-S) x2 — retail — Imported 2025 order #70'),
  ('Kukujay', '2025-08-31', 250, 0, 250, 'T-shirt (TSH-BK-L) x1 — retail — Imported 2025 order #71'),
  ('Mr. Silas', '2025-10-03', 100, 0, 100, 'Cap (C-B) x2 — retail — Imported 2025 order #72'),
  ('Randy', '2025-10-27', 300, 0, 300, 'T-shirt (TSH-WH-XXL) x1 — retail — Imported 2025 order #73'),
  ('Philip Yemoah', '2025-10-29', 1000, 0, 1000, 'Shirts (S-L) x1 — retail — Imported 2025 order #74'),
  ('Philip Yemoah', '2025-10-29', 500, 0, 500, 'T-shirt (TSH-WH-L) x2 — retail — Imported 2025 order #75'),
  ('Dr. Phil', '2025-11-04', 500, 0, 500, 'T-shirt (TSH-WH-L, TSH-BK-L) x2 — retail — Imported 2025 order #76'),
  ('Mr. Silas', '2025-12-04', 150, 0, 150, 'Cap (C-B, C-C) x3 — retail — Imported 2025 order #77'),
  ('George Adinkra', '2025-12-05', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2025 order #78'),
  ('Opoku Christian', '2026-02-07', 50, 0, 50, 'Cap (C-B) x1 — retail — Imported 2026 #1'),
  ('Anastasia Frimpong Boakye', '2026-02-15', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2026 #2'),
  ('Bernice Mawuena Siame', '2026-03-07', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2026 #3'),
  ('Prince Edison', '2026-03-19', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2026 #4'),
  ('Christian Boakye Yiadom', '2026-05-17', 1200, 0, 1200, 'Nomad LS (N-LS) x1 — retail — Imported 2026 #5'),
  ('Christian Boakye Yiadom', '2026-05-18', 2120, 0, 2120, 'Meridian stripe LS (M-S-LS) x2 — retail — Imported 2026 #6'),
  ('Christian Boakye Yiadom', '2026-05-19', 1060, 0, 1060, 'Grandad SL (G-LS) x1 — retail — Imported 2026 #7'),
  ('Christian Boakye Yiadom', '2026-05-20', 1110, 0, 1110, 'Drawstring Linen Trouser (D-LS) x1 — retail — Imported 2026 #8'),
  ('Nana Anim', '2026-05-18', 550, 0, 550, 'Column tee (T-C) x1 — retail — Imported 2026 #9'),
  ('Bernice Mawuena Siame', '2026-05-24', 50, 0, 50, 'Cap (C-C) x1 — retail — Imported 2026 #10'),
  ('Tony', '2026-05-31', 660, 0, 660, 'Other (OTHER) x1 — retail — Imported 2026 #11'),
  ('Tony', '2026-05-31', 840, 0, 840, 'Other (OTHER) x1 — retail — Imported 2026 #12')
) as v(customer_name, sale_date, subtotal, discount, total_amount, notes)
left join customers c
  on c.organization_id = o.id and lower(c.name) = lower(v.customer_name)
where o.name = 'Pakeru'
  and not exists (
    select 1 from sales s
    where s.organization_id = o.id
      and s.sale_date = v.sale_date::date
      and s.notes = v.notes
  );

alter table sales enable trigger trg_new_sale;
