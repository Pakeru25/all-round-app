-- ==========================================================
-- All Round App — full two-year data import
-- Generated 2026-06-18T15:13:48.013Z
-- Paste the entire block into Supabase SQL Editor and run.
-- Requires 0006_admin.sql to have been applied first.
-- ==========================================================

DO $$
DECLARE
  v_org_id uuid;
  v_sale_id uuid;
BEGIN
  SELECT id INTO v_org_id FROM organizations ORDER BY created_at LIMIT 1;
  PERFORM set_transaction_triggers(false);

  -- ── Expense categories (16) ────────────────────────────
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Photography', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Transport', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Production', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Marketing & Advertisement', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Delivery', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Website Hosting', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Website Hosting'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Marketing', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Other', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Asset', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Asset'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'AI Tools (Pakeru)', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Production (Pakeru)', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Meta Ads (Pakeru)', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Utilities', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Personal Subs', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Personal Subs'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Insurance', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Insurance'));
  INSERT INTO expense_categories (id, organization_id, name, created_at)
  SELECT gen_random_uuid(), v_org_id, 'Office', now()
  WHERE NOT EXISTS (SELECT 1 FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Office'));

  -- ── Customers (49) ──────────────────────────────────────────
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Abeiku', '552818283', NULL, NULL, 'Male, 30-40, COO of pizzaman, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Abeiku'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Joshua Danjuma', '599222746', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Joshua Danjuma'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'AbdulMatin Mohammed', '542617632', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('AbdulMatin Mohammed'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Twig', '543033659', NULL, NULL, 'Male, 20-30, Not married, CEO blackbox', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Twig'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Tina', '203534310', NULL, NULL, 'Female, 25-35, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Tina'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Eleazer Asenso', '592935308', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Eleazer Asenso'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Adwoa Siaw', NULL, NULL, NULL, 'Female, 10-18, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Adwoa Siaw'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Kingsley', NULL, NULL, NULL, 'Male, 20-30, Not married, UK', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Kingsley'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Paul', NULL, NULL, NULL, 'Male, 25-35, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Paul'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Jojo Siaw', NULL, NULL, NULL, 'Male, below 18, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Jojo Siaw'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Theophilus Amakye', '531925144', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Theophilus Amakye'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Prince', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Prince'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Gladys Marfo', '597640819', NULL, NULL, 'Female, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gladys Marfo'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Osei Tutu Prince', '559154947', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Osei Tutu Prince'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Herbert', '553729657', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Herbert'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Emmanuel Kofi Asante', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Emmanuel Kofi Asante'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Diana Asante', '595903674', NULL, NULL, 'Female, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Diana Asante'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Derrick', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Derrick'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Solomon', '595384212', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Solomon'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Storm', '594007279', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Storm'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Lamar', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Lamar'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Bordom Edwin', '544671142', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bordom Edwin'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Mawuko', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Mawuko'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Theophelus Opey', '545702527', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Theophelus Opey'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Samuel Sarfo Sarpong', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Samuel Sarfo Sarpong'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Loshi', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Loshi'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, '(Owner) Paajoe', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('(Owner) Paajoe'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Bernice', NULL, NULL, NULL, 'Female, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Ohene Gyan', '532735626', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Ohene Gyan'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Derrick Kwesi Owusu', '548240317', NULL, NULL, 'Male, 30-40, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Derrick Kwesi Owusu'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Ibrahim', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Ibrahim'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, '(Owner) Kwadwo Siaw', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('(Owner) Kwadwo Siaw'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Mr. Silas', '246630215', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Mr. Silas'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Ernest Akwasi Boakye', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Ernest Akwasi Boakye'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Gyima', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gyima'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Maxwel', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Maxwel'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Kukujay', NULL, NULL, NULL, 'Male, 30-40, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Kukujay'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Randy', NULL, NULL, NULL, 'Male, 30-40, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Randy'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Philip Yemoah', '544344305', NULL, NULL, 'Male, 30-40, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Philip Yemoah'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Dr. Phil', '207823680', NULL, NULL, 'Male, 30-40, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Dr. Phil'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'George Adinkra', '556056154', NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('George Adinkra'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Opoku Christian', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Opoku Christian'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Anastasia Frimpong Boakye', NULL, NULL, NULL, 'Female, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Anastasia Frimpong Boakye'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Nana Anim', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Nana Anim'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Tony', NULL, NULL, NULL, 'Male, 20-30, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Tony'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Christian Boakye Yiadom', NULL, NULL, NULL, 'Male, 30-40, CEO of pizzaman, Not married', 'Retail', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Christian Boakye Yiadom'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Chris B', NULL, NULL, NULL, NULL, NULL, now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Chris B'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Bernice Mawuena Siame', NULL, NULL, NULL, NULL, NULL, now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice Mawuena Siame'));
  INSERT INTO customers (id, organization_id, name, phone, email, address, notes, preferences, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Prince Edison', NULL, NULL, NULL, NULL, NULL, now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Prince Edison'));

  -- ── Inventory items (26 derived from sales) ──────────────────────
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'TSH-WH-L', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Cap', 'C-C', 50, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'TSH-C-L', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-C-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Cap', 'C-B', 50, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'TSH-BK-L', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Cap', 'C-B, C-C', 50, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Tote Bag', 'T-B', 100, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-B');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'C-C,CB', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C,CB');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'TSH-B-L', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-B-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Shirts', 'S-L,S-S', 500, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-L,S-S');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'TSH-BK-L,TSH-WH-L', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L,TSH-WH-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'GYM-WH-L', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'GYM-WH-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Cap', 'C_B&C', 50, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C_B&C');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Shirt', 'S-S', 500, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-S');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Tank-Top', 'T-T B', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-T B');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Cap', 'C-C&B', 50, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C&B');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirts', 'TSH-WH-L, TSH-BK-L', 250, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L, TSH-BK-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Shirts', 'S-Y,S-S', 500, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-Y,S-S');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'T-shirt', 'TSH-WH-XXL', 300, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-XXL');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Shirts', 'S-L', 1000, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-L');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Nomad LS', 'N-LS', 1200, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'N-LS');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Meridian stripe LS', 'M-S-LS', 1060, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'M-S-LS');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Grandad SL', 'G-LS', 1060, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'G-LS');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Drawstring Linen Trouser', 'D-LS', 1110, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'D-LS');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Column tee', 'T-C', 550, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-C');
  INSERT INTO inventory_items (id, organization_id, name, sku, selling_price, cost_price, quantity_in_stock, unit, created_at, updated_at)
  SELECT gen_random_uuid(), v_org_id, 'Other', 'OTHER', 840, 0, 0, 'pieces', now(), now()
  WHERE NOT EXISTS (SELECT 1 FROM inventory_items WHERE organization_id = v_org_id AND sku = 'OTHER');

  -- ── Numbered sales (103) ─────────────────────────────────────────
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Abeiku') LIMIT 1),
    '2025-1', '2025-03-17', 500, 400, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-1');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Abeiku') LIMIT 1),
    '2025-2', '2025-03-17', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-2');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Joshua Danjuma') LIMIT 1),
    '2025-3', '2025-03-17', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-3');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Joshua Danjuma') LIMIT 1),
    '2025-4', '2025-03-17', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-4');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('AbdulMatin Mohammed') LIMIT 1),
    '2025-5', '2025-03-17', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-5');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Tina') LIMIT 1),
    '2025-7', '2025-03-17', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-7');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Twig') LIMIT 1),
    '2025-6', '2025-03-18', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-6');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Theophilus Amakye') LIMIT 1),
    '2025-17', '2025-04-02', 150, 0, 150, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-17');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gladys Marfo') LIMIT 1),
    '2025-20', '2025-04-02', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-20');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gladys Marfo') LIMIT 1),
    '2025-21', '2025-04-02', 70, 0, 70, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-21');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Prince') LIMIT 1),
    '2025-18', '2025-04-03', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-18');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Prince') LIMIT 1),
    '2025-19', '2025-04-03', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-19');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Herbert') LIMIT 1),
    '2025-23', '2025-04-14', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-23');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Herbert') LIMIT 1),
    '2025-24', '2025-04-14', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-24');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Emmanuel Kofi Asante') LIMIT 1),
    '2025-26', '2025-04-21', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-26');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Diana Asante') LIMIT 1),
    '2025-28', '2025-04-22', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-28');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Diana Asante') LIMIT 1),
    '2025-29', '2025-04-22', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-29');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Theophilus Amakye') LIMIT 1),
    '2025-25', '2025-04-23', 150, 0, 150, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-25');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Derrick') LIMIT 1),
    '2025-30', '2025-04-23', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-30');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Twig') LIMIT 1),
    '2025-27', '2025-04-25', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-27');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Solomon') LIMIT 1),
    '2025-31', '2025-04-28', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-31');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Eleazer Asenso') LIMIT 1),
    '2025-8', '2025-05-03', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-8');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Eleazer Asenso') LIMIT 1),
    '2025-9', '2025-05-03', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-9');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Adwoa Siaw') LIMIT 1),
    '2025-10', '2025-05-04', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-10');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Kingsley') LIMIT 1),
    '2025-11', '2025-05-05', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-11');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Kingsley') LIMIT 1),
    '2025-12', '2025-05-05', 150, 0, 150, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-12');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Paul') LIMIT 1),
    '2025-13', '2025-05-06', 150, 0, 150, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-13');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Jojo Siaw') LIMIT 1),
    '2025-14', '2025-05-07', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-14');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Joshua Danjuma') LIMIT 1),
    '2025-15', '2025-05-08', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-15');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Abeiku') LIMIT 1),
    '2025-16', '2025-05-09', 1000, 0, 1000, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-16');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Osei Tutu Prince') LIMIT 1),
    '2025-32', '2025-05-17', 500, -50, 550, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-32');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Storm') LIMIT 1),
    '2025-33', '2025-05-19', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-33');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Lamar') LIMIT 1),
    '2025-34', '2025-05-19', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-34');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Lamar') LIMIT 1),
    '2025-35', '2025-05-19', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-35');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Solomon') LIMIT 1),
    '2025-36', '2025-05-21', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-36');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Solomon') LIMIT 1),
    '2025-37', '2025-05-21', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-37');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bordom Edwin') LIMIT 1),
    '2025-38', '2025-05-25', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-38');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Mawuko') LIMIT 1),
    '2025-39', '2025-05-25', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-39');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Theophelus Opey') LIMIT 1),
    '2025-40', '2025-05-26', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-40');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Theophelus Opey') LIMIT 1),
    '2025-41', '2025-05-26', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-41');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Samuel Sarfo Sarpong') LIMIT 1),
    '2025-42', '2025-05-27', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-42');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Loshi') LIMIT 1),
    '2025-43', '2025-05-27', 70, 0, 70, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-43');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Diana Asante') LIMIT 1),
    '2025-44', '2025-06-11', 500, -20, 520, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-44');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Osei Tutu Prince') LIMIT 1),
    '2025-47', '2025-06-15', 1000, 0, 1000, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-47');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Abeiku') LIMIT 1),
    '2025-50', '2025-06-19', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-50');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Osei Tutu Prince') LIMIT 1),
    '2025-22', '2025-07-04', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-22');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice') LIMIT 1),
    '2025-45', '2025-07-06', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-45');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice') LIMIT 1),
    '2025-46', '2025-07-06', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-46');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice') LIMIT 1),
    '2025-48', '2025-07-06', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-48');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice') LIMIT 1),
    '2025-49', '2025-07-06', 70, 0, 70, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-49');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Ohene Gyan') LIMIT 1),
    '2025-51', '2025-07-06', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-51');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('(Owner) Paajoe') LIMIT 1),
    '2025-52', '2025-07-06', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-52');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Ibrahim') LIMIT 1),
    '2025-53', '2025-07-09', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-53');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Derrick Kwesi Owusu') LIMIT 1),
    '2025-54', '2025-07-09', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-54');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Derrick Kwesi Owusu') LIMIT 1),
    '2025-55', '2025-07-09', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-55');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Diana Asante') LIMIT 1),
    '2025-56', '2025-07-10', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-56');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Twig') LIMIT 1),
    '2025-57', '2025-07-12', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-57');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Abeiku') LIMIT 1),
    '2025-58', '2025-07-13', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-58');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Mr. Silas') LIMIT 1),
    '2025-59', '2025-07-14', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-59');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('(Owner) Kwadwo Siaw') LIMIT 1),
    '2025-60', '2025-07-24', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-60');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Ernest Akwasi Boakye') LIMIT 1),
    '2025-61', '2025-07-25', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-61');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gyima') LIMIT 1),
    '2025-62', '2025-07-30', 1000, 0, 1000, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-62');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gyima') LIMIT 1),
    '2025-63', '2025-07-30', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-63');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gyima') LIMIT 1),
    '2025-64', '2025-07-30', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-64');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Maxwel') LIMIT 1),
    '2025-65', '2025-07-31', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-65');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Chris B') LIMIT 1),
    '2025-66', '2025-08-05', 500, 100, 400, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-66');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Kukujay') LIMIT 1),
    '2025-67', '2025-08-12', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-67');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Kukujay') LIMIT 1),
    '2025-68', '2025-08-12', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-68');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gyima') LIMIT 1),
    '2025-69', '2025-08-30', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-69');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Gyima') LIMIT 1),
    '2025-70', '2025-08-30', 1000, 0, 1000, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-70');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Kukujay') LIMIT 1),
    '2025-71', '2025-08-31', 250, 0, 250, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-71');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Mr. Silas') LIMIT 1),
    '2025-72', '2025-10-03', 100, 0, 100, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-72');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Randy') LIMIT 1),
    '2025-73', '2025-10-27', 300, 0, 300, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-73');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Philip Yemoah') LIMIT 1),
    '2025-74', '2025-10-29', 1000, 0, 1000, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-74');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Philip Yemoah') LIMIT 1),
    '2025-75', '2025-10-29', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-75');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Dr. Phil') LIMIT 1),
    '2025-76', '2025-11-04', 500, 0, 500, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-76');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Mr. Silas') LIMIT 1),
    '2025-77', '2025-12-04', 150, 0, 150, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-77');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('George Adinkra') LIMIT 1),
    '2025-78', '2025-12-05', 50, 0, 50, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-78');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-79', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-79');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-80', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-80');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-81', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-81');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-82', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-82');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-83', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-83');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-84', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-84');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-85', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-85');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-86', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-86');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-87', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-87');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-88', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-88');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-89', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-89');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-90', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-90');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-91', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-91');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-92', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-92');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-93', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-93');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-94', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-94');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-95', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-95');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-96', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-96');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-97', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-97');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-98', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-98');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-99', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-99');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-100', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-100');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-101', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-101');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-102', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-102');
  INSERT INTO sales (id, organization_id, customer_id, sale_number, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  SELECT gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower(NULL) LIMIT 1),
    '2025-103', '2026-06-18', 0, 0, 0, 'cash', 'paid', NULL, now()
  WHERE NOT EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-103');

  -- ── Sale items for numbered sales ────────────────────────────────────
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-1' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-1');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-2' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-2');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-3' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-C-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-3');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-4' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-4');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-5' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-5');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-7' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-7');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-6' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-6');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-17' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    3, 50, 150
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-17');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-20' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-20');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-21' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-B' LIMIT 1),
    1, 70, 70
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-21');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-18' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-18');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-19' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-19');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-23' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C,CB' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-23');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-24' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-24');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-26' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C,CB' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-26');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-28' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-28');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-29' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-29');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-25' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    3, 50, 150
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-25');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-30' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-30');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-27' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-27');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-31' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-31');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-8' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-8');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-9' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-9');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-10' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-10');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-11' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-11');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-12' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    3, 50, 150
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-12');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-13' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    3, 50, 150
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-13');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-14' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-14');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-15' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-B-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-15');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-16' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-L,S-S' LIMIT 1),
    2, 500, 1000
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-16');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-32' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    10, 50, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-32');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-33' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-33');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-34' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-34');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-35' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-35');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-36' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-36');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-37' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-37');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-38' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-38');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-39' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-39');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-40' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-40');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-41' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L,TSH-WH-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-41');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-42' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-42');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-43' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-B' LIMIT 1),
    1, 70, 70
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-43');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-44' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-44');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-47' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    20, 50, 1000
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-47');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-50' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'GYM-WH-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-50');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-22' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-22');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-45' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-45');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-46' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C_B&C' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-46');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-48' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-S' LIMIT 1),
    1, 500, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-48');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-49' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-B' LIMIT 1),
    1, 70, 70
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-49');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-51' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C,CB' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-51');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-52' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-52');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-53' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-53');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-54' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-54');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-55' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-T B' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-55');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-56' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-56');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-57' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-57');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-58' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-58');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-59' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C&B' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-59');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-60' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-60');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-61' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-61');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-62' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-L,S-S' LIMIT 1),
    2, 500, 1000
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-62');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-63' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L, TSH-BK-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-63');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-64' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-64');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-65' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-B' LIMIT 1),
    1, 100, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-65');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-66' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-66');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-67' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-67');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-68' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-68');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-69' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-69');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-70' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-Y,S-S' LIMIT 1),
    2, 500, 1000
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-70');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-71' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-BK-L' LIMIT 1),
    1, 250, 250
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-71');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-72' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    2, 50, 100
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-72');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-73' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-XXL' LIMIT 1),
    1, 300, 300
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-73');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-74' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'S-L' LIMIT 1),
    1, 1000, 1000
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-74');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-75' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-75');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-76' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'TSH-WH-L, TSH-BK-L' LIMIT 1),
    2, 250, 500
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-76');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-77' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B, C-C' LIMIT 1),
    3, 50, 150
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-77');
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  SELECT gen_random_uuid(),
    (SELECT id FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-78' LIMIT 1),
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50
  WHERE EXISTS (SELECT 1 FROM sales WHERE organization_id = v_org_id AND sale_number = '2025-78');

  -- ── Numberless 2026 sales (12) — each gets an auto SAL- number ──────
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Opoku Christian') LIMIT 1),
    '2026-02-07', 50, 0, 50, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-B' LIMIT 1),
    1, 50, 50);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Anastasia Frimpong Boakye') LIMIT 1),
    '2026-02-15', 50, 0, 50, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice Mawuena Siame') LIMIT 1),
    '2026-03-07', 50, 0, 50, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Prince Edison') LIMIT 1),
    '2026-03-19', 50, 0, 50, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Christian Boakye Yiadom') LIMIT 1),
    '2026-05-17', 1200, 0, 1200, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'N-LS' LIMIT 1),
    1, 1200, 1200);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Christian Boakye Yiadom') LIMIT 1),
    '2026-05-18', 2120, 0, 2120, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'M-S-LS' LIMIT 1),
    2, 1060, 2120);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Christian Boakye Yiadom') LIMIT 1),
    '2026-05-19', 1060, 0, 1060, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'G-LS' LIMIT 1),
    1, 1060, 1060);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Christian Boakye Yiadom') LIMIT 1),
    '2026-05-20', 1110, 0, 1110, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'D-LS' LIMIT 1),
    1, 1110, 1110);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Nana Anim') LIMIT 1),
    '2026-05-18', 550, 0, 550, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'T-C' LIMIT 1),
    1, 550, 550);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Bernice Mawuena Siame') LIMIT 1),
    '2026-05-24', 50, 0, 50, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'C-C' LIMIT 1),
    1, 50, 50);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Tony') LIMIT 1),
    '2026-05-31', 660, 0, 660, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'OTHER' LIMIT 1),
    1, 660, 660);
  INSERT INTO sales (id, organization_id, customer_id, sale_date, subtotal, discount, total_amount, payment_method, payment_status, notes, created_at)
  VALUES (gen_random_uuid(), v_org_id,
    (SELECT id FROM customers WHERE organization_id = v_org_id AND lower(name) = lower('Tony') LIMIT 1),
    '2026-05-31', 840, 0, 840, 'cash', 'paid', NULL, now())
  RETURNING id INTO v_sale_id;
  INSERT INTO sale_items (id, sale_id, inventory_item_id, quantity, unit_price, total_price)
  VALUES (gen_random_uuid(), v_sale_id,
    (SELECT id FROM inventory_items WHERE organization_id = v_org_id AND sku = 'OTHER' LIMIT 1),
    1, 840, 840);

  -- ── Expenses (407) ────────────────────────────────────────────────
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 200, 'Nyamedo''s Issue — Vendor: Nyamedo', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 100, 'Fuel — Vendor: Goil', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 610, 'Cap production — Vendor: Morris', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 60, 'Crop top sample — Vendor: Dzifa', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 150, 'Magazine — Vendor: Bonnyface', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1020, 'T-shirts — Vendor: Super', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 70, 'Newspaper — Vendor: Total prints', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 60, 'Bulk sms — Vendor: Hubtel', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 100, 'Brunch — Vendor: Icy cup', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 40, 'Efo sew — Vendor: Efo', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 30, 'Embroidery — Vendor: Morris', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'Stencils cut out — Vendor: Pex print', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 85, 'Brunch — Vendor: Icy cup', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 70, 'Caps — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 14, 'Cards — Vendor: Vytal prints', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 391, 'Fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 400, 'Studio — Vendor: Milan', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 130, 'T-shirts — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 40, 'Stickers — Vendor: Vytal prints', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 80, 'Fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 't-shirt — Vendor: Segoe lane', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 375, 'Caps — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 250, 'Waza fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'T-shirts — Vendor: Segoe lane', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'Dtf — Vendor: NAKON', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 125, 'Crop tops — Vendor: Bus', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 300, 'Editing — Vendor: Obededom', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 270, 'T-shirt — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 40, 'Dtf — Vendor: Asafo', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1042, 'Fabrics — Vendor: Woodin', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 900, 'T-shirts — Vendor: Segoe lane', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 1000, 'Box — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 450, 'Tag — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 300, 'label — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 200, 'Tissue wrapper — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 170, 'Prototype Fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 320, 'Poly Bags — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 150, 'Boxes — Vendor: OA', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 30, 'Poly bags — Vendor: VIP', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Tote bag board — Vendor: MR Owusu', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 91, 'Dtf — Vendor: NAKON', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Cardboard & Sample — Vendor: MK', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 90, 'Tote bags — Vendor: Angela', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 40, 'Ropes — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 490, 'Caps — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 460, 'T-shirts — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 90, 'Gildan — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 98, 'Cards — Vendor: Vytal prints', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 67, 'Dtf — Vendor: Nakon', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 400, 'Photographer — Vendor: Nyamedo', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 300, 'Studio Space — Vendor: Confirmed media', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 320, 'polymailer & Delivery — Vendor: VIP, Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 350, 'Fuel — Vendor: Goil', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 250, 'Food — Vendor: Shawarma boiz', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 100, 'Sarah Transport — Vendor: Sarah', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Pattern fee — Vendor: MK', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 900, 'Sewing — Vendor: MK', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Crop tops Samples — Vendor: Fidouse', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 120, 'T-shirt top up — Vendor: Super', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 150, 'Board — Vendor: Commercial Area', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1760, 'T-shirt — Vendor: Super', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 180, 'Jeans — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 55, 'Efo sew & tnt — Vendor: Efo', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 450, 'Crop tops — Vendor: Fidouse', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 300, 'Fuel — Vendor: Goil', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 400, 'Food — Vendor: Pizzaman', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 300, 'Photos — Vendor: Dankwah', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 300, 'Tote bags — Vendor: Angela', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 300, 'Leather tags — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 40, 'Tags — Vendor: Bus', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 120, 'Studio — Vendor: 3Dstudio', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 24, 'Tote Bag print — Vendor: Asafo', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 42, 'Cards — Vendor: Vytal prints', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 320, 'Caps — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 750, 'stamp — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 480, 'Fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 400, 'Chess board — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Fabrics and Dtf — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 194, 'Fabrics and Dtf — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 150, 'chess delivery — Vendor: OA', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 250, 'caps embroidery — Vendor: Morris', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 687.5, 'Fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 500, 'Photographer — Vendor: Osei Amoah', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 1000, 'Boxes — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 288, 'Leather — Vendor: Town, Dubai', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 60, 'Jeans — Vendor: Rails', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 150, 'Board and print — Vendor: Asafo', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 300, 'Fabrics — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 280, 'Leather — Vendor: Town, dubai', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 340, 'Jeans fabric — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 80, 'Fabric — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 25, 'Delivery — Vendor: Bus', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 50, 'Leather sample — Vendor: Town, dubai', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 30, 'Sample, cap — Vendor: Town, Dubai', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 250, 'caps embroidery — Vendor: Morris', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Jeans button — Vendor: Joe', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 84, 'Cards — Vendor: Vytal prints', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 800, 'Leather and ribbon — Vendor: Accra', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Zip and Buttons — Vendor: Town', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Website Hosting') LIMIT 1), 2500, 'Quarter payment of Website — Vendor: Louis', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1000, 'Sewing — Vendor: Bismark', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 400, 'Black khaki — Vendor: Rails', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 945, 'Jeans — Vendor: Rails', '2025-07-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 70, 'Leather and ribbon — Vendor: Bus', '2025-07-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 540, 'T-shirts — Vendor: Segoe lane', '2025-07-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 180, 'T-shirts — Vendor: Segoe lane', '2025-07-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 30, 'Dtf — Vendor: Asafo', '2025-07-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 175, 'Ingredients — Vendor: Town, Dubai', '2025-07-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 300, 'Ingredients — Vendor: Town, Dubai', '2025-07-13', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 50, 'Delivery — Vendor: Bus', '2025-07-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 609, 'Stickers and Cards — Vendor: Vytal prints', '2025-07-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 71, 'Cards — Vendor: Vytal prints', '2025-07-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 300, 'T-shirts — Vendor: Segoe lane', '2025-07-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 140, 'Caps — Vendor: Town', '2025-07-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 40, 'Dtf — Vendor: Asafo', '2025-07-24', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 720, 'fabrics — Vendor: Town', '2025-07-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 500, 'Flyers — Vendor: Scratch', '2025-07-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 1000, 'Images — Vendor: Kaymora', '2025-07-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 35, 'Board — Vendor: Asafo', '2025-07-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 180, 't-shirts — Vendor: Segoe lane', '2025-07-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 40, 'Tote bag — Vendor: Asafo', '2025-07-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'dtf — Vendor: Asafo', '2025-07-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 300, 'Fuel — Vendor: Goil', '2025-08-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 200, 'Fuel — Vendor: Goil', '2025-08-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 650, 'food — Vendor: Pizzaman', '2025-08-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 500, 'make-up — Vendor: Jessica', '2025-08-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 50, 'Suit lining — Vendor: Town', '2025-08-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 50, 'laces — Vendor: Town', '2025-08-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 450, 'Tote bags — Vendor: Angela', '2025-08-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 200, 'Rounds — Vendor: Joe, kotei', '2025-08-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 15, 'Tote bags — Vendor: Rider', '2025-08-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 40, 'Food — Vendor: Bismark', '2025-08-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 26, 'Cardboard — Vendor: Ayeduase', '2025-08-06', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 50, 'Zippers — Vendor: Town', '2025-08-06', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'Press on buttons — Vendor: Town', '2025-08-06', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 90, 'T-shirt — Vendor: Segoe lane', '2025-08-09', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 300, 'Fabrics — Vendor: Rails', '2025-08-12', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'T-shirt — Vendor: Segoe lane', '2025-08-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'dtf — Vendor: Asafo', '2025-08-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1000, 'Sewing — Vendor: Bismark', '2025-08-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 400, 't-shirt — Vendor: Segoe lane', '2025-09-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'dtf — Vendor: Asafo', '2025-09-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 500, 'Boxes — Vendor: Accra', '2025-09-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 60, 'Box sample — Vendor: Accra', '2025-09-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 4000, 'Images — Vendor: Kaymora', '2025-09-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 2000, 'Images — Vendor: Kaymora', '2025-09-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'Threads — Vendor: Segoe lane', '2025-10-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Tailor tnt — Vendor: Sterling', '2025-10-24', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 5000, 'Tshirts — Vendor: Segoe lane', '2025-10-22', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 220, 'Fabrics — Vendor: Town', '2025-10-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1620, 'Fabrics — Vendor: Town', '2025-10-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 100, 'Food — Vendor: Santassi', '2025-10-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 200, 'Fuel — Vendor: Goil', '2025-10-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 470, 'Stickers — Vendor: Vytal prints', '2025-10-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 2000, 'fabrics — Vendor: Adum', '2025-10-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'fabrics — Vendor: Adum', '2025-10-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1500, 'fabrics — Vendor: Town', '2025-10-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 320, 't-shirts — Vendor: Segoe lane', '2025-10-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 80, 'dtf — Vendor: Asafo', '2025-10-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 150, 'fabrics — Vendor: Town', '2025-10-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 158, 'Fabrics — Vendor: Adum', '2025-10-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1475, 'Fabrics — Vendor: Adum', '2025-11-11', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 303, 'Fabrics — Vendor: Adum', '2025-11-11', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 150, 'Sewing — Vendor: Jabil', '2025-11-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 20, 'dtf — Vendor: Asafo', '2025-11-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 700, 'Food — Vendor: Pizzaman', '2025-11-19', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Photography') LIMIT 1), 2000, 'Images — Vendor: Osei Amoah', '2025-11-19', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 1500, 'UCC — Vendor: expenses', '2025-11-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 920, 'UCC — Vendor: expenses', '2025-11-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 130, 'UCC — Vendor: expenses', '2025-11-24', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Foam — Vendor: Town', '2025-11-22', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 150, 'Still — Vendor: Town', '2025-11-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 280, 'caps — Vendor: Town', '2025-11-24', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 353, 'Curves and fabrics — Vendor: Town', '2025-11-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 570, 'ads — Vendor: Instagram', '2025-11-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 100, 'Ai — Vendor: Higgsfield', '2025-11-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 300, 'Ai — Vendor: Higgsfield', '2025-11-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1000, 'Sewing — Vendor: Bismark', '2025-11-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1800, 'Sewing — Vendor: Bismark', '2025-11-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'caps — Vendor: Morrison', '2025-12-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 52, 'Ai — Vendor: Higgsfield', '2025-12-13', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 37, 'Thread, Zippers — Vendor: Town', '2025-12-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 882, 'labels — Vendor: Lasare', '2025-12-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 52, 'Ai — Vendor: Higgsfield', '2025-12-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 409, 'Ai — Vendor: Higgsfield', '2025-12-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing & Advertisement') LIMIT 1), 100, 'Ai — Vendor: Higgsfield', '2025-12-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1800, 'Paper bags — Vendor: all purpose', '2026-01-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1801, 'Paper bags — Vendor: all purpose', '2026-01-02', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 250, 'Envelope — Vendor: all purpose', '2026-01-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Signature card — Vendor: all purpose', '2026-01-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 64.96, 'Ads — Vendor: Instagram', '2026-01-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 150, 'Care Card — Vendor: all purpose', '2026-01-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1000, 'Boxes — Vendor: all purpose', '2026-01-06', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 64.96, 'Ads — Vendor: Instagram', '2026-01-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 196, 'Ads — Vendor: Instagram', '2026-01-08', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 64.96, 'Ads — Vendor: Instagram', '2026-01-09', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 270.67, 'Ads — Vendor: Instagram', '2026-01-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 129.92, 'Ads — Vendor: Instagram', '2026-01-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 522.03, 'Ai — Vendor: Higgsfield', '2026-01-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 14, 'Tape measure — Vendor: Town', '2026-01-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 70, 'Gloves — Vendor: Town', '2026-01-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 80, 'Leather Bag — Vendor: Town', '2026-01-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 40, 'Brown Envelope — Vendor: Town', '2026-01-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 40, 'cards — Vendor: Aseda House', '2026-01-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 14, 'Printing — Vendor: Vytal', '2026-01-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 240, 'Bus — Vendor: VIP', '2026-02-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 50, 'Transport — Vendor: Bolt', '2026-02-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 50, 'Food — Vendor: Linda dor', '2026-02-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 280, 'Transport — Vendor: Motor', '2026-02-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 240, 'Bus — Vendor: VIP', '2026-02-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 75, 'Food — Vendor: Mampong', '2026-02-06', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 75, 'Food — Vendor: Mampong', '2026-02-11', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 75, 'Food — Vendor: Mampong', '2026-02-12', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 220, 'Bus — Vendor: VIP', '2026-02-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 148, 'Transport — Vendor: Bolt', '2026-02-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 60, 'Food — Vendor: Queens', '2026-02-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 120, 'Bus — Vendor: VIP', '2026-02-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 320, 'Food — Vendor: Pizzaman', '2026-02-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 20, 'Transport — Vendor: Taxi', '2026-02-14', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Asset') LIMIT 1), 1000, 'Industrial cutter — Vendor: UT', '2026-02-17', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Asset') LIMIT 1), 80, 'buttos — Vendor: UT', '2026-02-17', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Asset') LIMIT 1), 6500, 'button hole machine — Vendor: UT', '2026-02-17', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Asset') LIMIT 1), 300, 'button hole machine — Vendor: UT', '2026-02-17', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: Mampong', '2026-02-18', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: Mampong', '2026-02-19', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 236.5, 'ChatGPT subscription — Vendor: OpenAI', '2026-02-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 212, 'Ads — Vendor: Instagram', '2026-02-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: Mampong', '2026-02-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 75, 'Delivery — Vendor: Paa', '2026-02-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: Mampong', '2026-02-24', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 240, 'Fabric purchase — Vendor: Fabric', '2026-02-24', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 240, 'Fabric — Vendor: Adamu', '2026-02-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: ayeduase', '2026-02-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: ayeduase', '2026-02-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'gift — Vendor: Pattern', '2026-02-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 40, 'Ads — Vendor: Instagram', '2026-02-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 220, 'Ad payment — Vendor: Paa', '2026-02-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 151.5, 'Boxes — Vendor: Vip', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 9820, 'Fabrics — Vendor: Fragroma', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 5890, 'Fabrics — Vendor: Aviwill Couture', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 407.03, 'Fabrics — Vendor: Elvis', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 205.53, 'Fabrics — Vendor: Transport', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 520, 'Ads — Vendor: Higgsfield', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 229.84, 'Claude sub — Vendor: Anthropic', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 950, 'Fabrics — Vendor: Paa', '2026-02-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 75, 'Food — Vendor: Asokore mampong', '2026-03-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 50, 'transport — Vendor: Wilson', '2026-03-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 170, 'Delivery — Vendor: VIP', '2026-03-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 200, 'Paint — Vendor: Paa', '2026-03-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 563.62, 'Higgsfield AI — Vendor: Higgsfield', '2026-03-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 200, 'Store purchase — Vendor: Paa', '2026-03-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: Ayeduase', '2026-03-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 1895, 'Sewing — Vendor: Bismark', '2026-03-08', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: Ayeduase', '2026-03-09', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Paint, brush — Vendor: Asokore mampong', '2026-03-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 400, 'Paint — Vendor: Patassi', '2026-03-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 818, 'Table — Vendor: Efo', '2026-03-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Delivery') LIMIT 1), 200, 'Table — Vendor: Motor', '2026-03-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Food — Vendor: Patassi', '2026-03-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 70, 'Gloves — Vendor: segoelane', '2026-03-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 50, 'Transport — Vendor: Wilson', '2026-03-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 100, 'Fuel — Vendor: Zen', '2026-03-11', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 250, 'button hole machine(service charge) — Vendor: Patasi', '2026-03-11', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 400, 'button hole machine(service charge) — Vendor: UT', '2026-03-11', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Foam maker — Vendor: Anloga', '2026-03-11', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 1393.08, 'Adobe Creative Cloud (refunded) — Vendor: Adobe', '2026-03-12', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, NULL, 800, 'Paid by Owner, Kwadwo Siaw — Vendor: Issah Abdulai', '2026-03-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 2000, 'Photography — Vendor: Kaymora', '2026-03-18', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 1000, 'Payment to Angela Adusu - Loan — Vendor: Angela Adusu', '2026-03-18', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 810, 'Ad payment - FG — Vendor: Paa', '2026-03-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 150, 'Busckets — Vendor: Ella Kusi', '2026-03-22', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 200, 'Ad payment - GUI — Vendor: Paa', '2026-03-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 353.62, 'FACEBK A9773JM2S2 (fb me) — Vendor: Facebook', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 235.75, 'FACEBK VQXGDHZCT2 (fb me) — Vendor: Facebook', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 60, 'FACEBK F3ACFKV2S2 — Vendor: Facebook', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.53, 'FACEBK NZ7A3LD2S2 — Vendor: Facebook', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.53, 'FACEBK V47ZBJR2S2 — Vendor: Facebook', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.53, 'FACEBK QMLLGJ92S2 — Vendor: Facebook', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.53, 'FACEBK SBXHGJ92S2 — Vendor: Facebook', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 234.57, 'HIGGSFIELD INC YK34BRNQ — Vendor: Higgsfield', '2026-03-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK PKY95LD2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK 448C5LD2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK ZZE7KKV2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK UPHAWLZZR2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK UYJ47JM2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK UF6FKKV2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 184.92, 'FACEBK FLVCFJR2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 227.42, 'FACEBK 3RB5SJH2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK DLNAJJ92S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK UYQH6JM2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK HGSK6JM2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK FAEPDJR2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK ZAW6ZJ52S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK Q2BT2MVZR2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK FNGU4JM2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK CXF8FJH2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK CBUY4JM2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK CGPL3LD2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK BFRKCJR2S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK CHLSZLVZR2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK BULGYJ52S2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK 6ETBVLZZR2 — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 28.53, 'Facebook/Instagram ads — Vendor: Facebook', '2026-03-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK K58R4LD2S2 — Vendor: Facebook', '2026-03-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 28.49, 'FACEBK BHHEDJR2S2 — Vendor: Facebook', '2026-03-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 235.86, 'Claude sub — Vendor: Anthropic', '2026-03-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 256.38, 'Facebook/Instagram ads — Vendor: Facebook', '2026-03-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 117.93, 'Higgsfield AI — Vendor: Higgsfield', '2026-03-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 199.41, 'Facebook/Instagram ads — Vendor: Facebook', '2026-03-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 199.41, 'Facebook/Instagram ads — Vendor: Facebook', '2026-03-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 270.52, 'FACEBK ZW299K52S2 — Vendor: Facebook', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 555.18, 'FACEBK NQ7VYJH2S2 — Vendor: Facebook', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 512.4, 'FACEBK VMXECLD2S2 — Vendor: Facebook', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 398.53, 'FACEBK HQLQBLD2S2 — Vendor: Facebook', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 199.41, 'FACEBK A5774K52S2 — Vendor: Facebook', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 199.41, 'FACEBK D2DSLKV2S2 — Vendor: Facebook', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 117.93, 'HIGGSFIELD INC YK34BRNQ — Vendor: Higgsfield', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 213.59, 'Facebook/Instagram ads — Vendor: Facebook', '2026-03-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 284.66, 'FACEBK ZSDDCK52S2 — Vendor: Facebook', '2026-03-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 284.66, 'FACEBK 7RQPUJ92S2 — Vendor: Facebook', '2026-03-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 526.78, 'FACEBK QGMJDLD2S2 — Vendor: Facebook', '2026-03-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 213.59, 'FACEBK NH997K52S2 — Vendor: Facebook', '2026-03-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 256.38, 'FACEBK PV49AJM2S2 — Vendor: Facebook', '2026-03-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 577.58, 'HIGGSFIELD INC YK34BRNQ — Vendor: Higgsfield', '2026-03-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 300, 'Fuel — Vendor: Goil', '2026-03-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 284.66, 'Facebook/Instagram ads — Vendor: Facebook', '2026-03-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 284.66, 'FACEBK UDFSYJ92S2 — Vendor: Facebook', '2026-03-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 284.66, 'FACEBK FMQHFMVZR2 — Vendor: Facebook', '2026-03-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 82.7, 'Render hosting — Vendor: Render', '2026-03-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 59.07, 'Anthropic API — Vendor: Anthropic', '2026-03-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 59.07, 'Anthropic API — Vendor: Anthropic', '2026-03-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 59.07, 'Anthropic API — Vendor: Anthropic', '2026-03-31', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 284.66, 'FACEBK UDFSYJ92S2 — Vendor: Facebook', '2026-04-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 55, 'Rider/dispatch fee — Vendor: Rider', '2026-04-02', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 236.5, 'Claude sub — Vendor: Anthropic', '2026-04-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities') LIMIT 1), 400, 'Electricity — Vendor: Electric guy', '2026-04-06', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Fuel — Vendor: Goil', '2026-04-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 82.5, 'Render hosting — Vendor: Render', '2026-04-08', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 300, 'Bank deposit to Pakeru Ltd account — Vendor: Pakeru Ltd', '2026-04-08', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 800, 'Electricity — Vendor: MK', '2026-04-09', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities') LIMIT 1), 60, 'Water — Vendor: Water bill', '2026-04-09', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 50, 'Delivery — Vendor: Seth', '2026-04-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 374.688, 'Ai — Vendor: Higgsfield', '2026-04-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 71.08, 'Anthropic API — Vendor: Anthropic', '2026-04-10', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 500, 'Fuel — Vendor: Goil', '2026-04-12', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 403.15, 'Higgsfield AI — Vendor: Higgsfield', '2026-04-12', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 71.08, 'Anthropic API — Vendor: Anthropic', '2026-04-12', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 200, 'Fuel — Vendor: Goil', '2026-04-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 80.5, 'Plastic band — Vendor: UT', '2026-04-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 54, 'Thread — Vendor: Segoe lane', '2026-04-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 10, 'Metal locks — Vendor: Segoe lane', '2026-04-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 162.5, 'Food — Vendor: Szning', '2026-04-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Personal Subs') LIMIT 1), 6, 'Google One storage — Vendor: Google', '2026-04-16', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 118, 'Knitting thread — Vendor: Dubai', '2026-04-17', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 142.67, 'Anthropic API — Vendor: Anthropic', '2026-04-18', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 71.34, 'Anthropic API — Vendor: Anthropic', '2026-04-18', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 71.34, 'Anthropic API — Vendor: Anthropic', '2026-04-18', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Personal Subs') LIMIT 1), 24, 'Spotify — Vendor: Spotify', '2026-04-20', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 400, 'Fuel — Vendor: Goil', '2026-04-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 7485, 'Linen Fabrics — Vendor: Awunsi', '2026-04-22', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production') LIMIT 1), 2515, 'Sewing — Vendor: MK', '2026-04-22', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 142.67, 'Anthropic API — Vendor: Anthropic', '2026-04-22', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 341.89, 'Facebook/Instagram ads — Vendor: Facebook', '2026-04-23', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Insurance') LIMIT 1), 565, 'Insurance payment — Vendor: Insurance', '2026-04-24', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 121.49, 'Hostinger hosting — Vendor: Hostinger', '2026-04-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 522, 'Ai — Vendor: Higgssfield', '2026-04-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 1000, 'Payment to Mr Kay - unclear purpose — Vendor: Mr Kay', '2026-04-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 286.64, 'Claude sub — Vendor: Anthropic', '2026-04-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities') LIMIT 1), 400, 'Fuel — Vendor: Goil', '2026-04-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 585.22, 'Higgsfield AI (image/video gen) — Vendor: Higgsfield', '2026-04-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 361.2, 'Facebook/Instagram ads — Vendor: Facebook', '2026-05-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 1820, 'Linen / fabric purchase — Vendor: Linen', '2026-05-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities') LIMIT 1), 60, 'Water — Vendor: Water bill', '2026-05-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 84.28, 'Render hosting — Vendor: Render', '2026-05-07', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 72.43, 'Anthropic API top-up — Vendor: Anthropic', '2026-05-08', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 205, 'Rider/VIP dispatch — Vendor: Rider VIP', '2026-05-09', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 364.43, 'Facebook/Instagram ads — Vendor: Facebook', '2026-05-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 205, 'Sunday measurements — Vendor: Sunday Measurements', '2026-05-15', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Personal Subs') LIMIT 1), 6, 'Google One storage — Vendor: Google', '2026-05-17', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 353.5, 'Poly mailer bags — Vendor: Poly Mailer Bags', '2026-05-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities') LIMIT 1), 56.56, 'Water — Vendor: Water', '2026-05-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 62.5, 'Food — Vendor: Food', '2026-05-21', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Meta Ads (Pakeru)') LIMIT 1), 521.89, 'Facebook/Instagram ads — Vendor: Facebook', '2026-05-25', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 88.52, 'Hostinger hosting — Vendor: Hostinger', '2026-05-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 305, 'Fuel — Vendor: Fuel', '2026-05-26', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 80, 'Food — Vendor: Food', '2026-05-27', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 301.09, 'Claude sub — Vendor: Anthropic', '2026-05-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities') LIMIT 1), 58.5, 'Water — Vendor: Water', '2026-05-28', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 75.27, 'Anthropic API — Vendor: Anthropic', '2026-05-29', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 75.27, 'Anthropic API — Vendor: Anthropic', '2026-05-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 614.72, 'Higgsfield AI (image/video gen) — Vendor: Higgsfield', '2026-05-30', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 500, 'Photoshoot - Pool Shoot — Vendor: Pool Shoot', '2026-06-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 303, 'Cash out to Eric Obeng — Vendor: Eric Obeng', '2026-06-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 200, 'Tailoring - Jabil — Vendor: Jabil', '2026-06-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 705, 'Fuel — Vendor: Fuel', '2026-06-01', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 164, 'Bolt ride — Vendor: Bolt', '2026-06-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Production (Pakeru)') LIMIT 1), 140, 'Food — Vendor: Food', '2026-06-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 606, 'Cash out to Ibrahim Akon Dawood — Vendor: Ibrahim Akon Dawood', '2026-06-03', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('AI Tools (Pakeru)') LIMIT 1), 303.67, 'Claude sub — Vendor: Anthropic', '2026-06-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 505, 'Payment to Elvis - Ride around — Vendor: Elvis', '2026-06-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Transport') LIMIT 1), 30, 'Rider/dispatch — Vendor: Rider', '2026-06-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 101, 'Cash out to Emelia Kumodzi — Vendor: Emelia Kumodzi', '2026-06-04', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Other') LIMIT 1), 100, 'Payment to Paa - Food — Vendor: Paa', '2026-06-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Office') LIMIT 1), 200, 'Welfare — Vendor: Abena', '2026-06-05', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Marketing') LIMIT 1), 612, 'LED board advertising — Vendor: KNUST URO', '2026-06-09', now());
  INSERT INTO expenses (id, organization_id, category_id, amount, description, expense_date, created_at)
  VALUES (gen_random_uuid(), v_org_id, (SELECT id FROM expense_categories WHERE organization_id = v_org_id AND lower(name) = lower('Utilities') LIMIT 1), 400, 'Fuel — Vendor: ZEN', '2026-06-09', now());

  PERFORM set_transaction_triggers(true);
END $$;