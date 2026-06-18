-- =============================================================================
-- 0007_seed_inventory.sql — load the owner's stock sheet into inventory
--
-- Generated from scripts/migrate/data/inventory.csv (66 items, 23 categories)
-- via the app's own parser (src/lib/inventory-import.ts). Run AFTER
-- 0006_inventory_type.sql (it needs the inventory_type column/enum).
--
-- Idempotent: categories are guarded by name and items by name, so re-running
-- inserts nothing new. Scoped to the seeded 'Pakeru' organization.
-- =============================================================================

-- ---- Categories referenced by the sheet -------------------------------------
insert into inventory_categories (organization_id, name)
select o.id, c.name
from organizations o
cross join (values
    ('Box'),
    ('Paper bag'),
    ('Card'),
    ('Tag'),
    ('Wrapper'),
    ('Envelope'),
    ('Poly Mailer bag'),
    ('Plain T-shirt'),
    ('Cap'),
    ('tote bag'),
    ('Linen Shirts — Long Sleeve'),
    ('Linen Shirts — Short Sleeve'),
    ('Overshirts'),
    ('Trousers & Tailored Pants'),
    ('Signature T-Shirts'),
    ('Volume & Cargo Pants'),
    ('Shorts'),
    ('Textured Tees & Polo'),
    ('Female Tops'),
    ('Skirts'),
    ('Tanks'),
    ('Artisan Woven'),
    ('Essential Formal')
) as c(name)
where o.name = 'Pakeru'
  and not exists (
    select 1 from inventory_categories i
    where i.organization_id = o.id and i.name = c.name
  );

-- ---- Items ------------------------------------------------------------------
insert into inventory_items
  (organization_id, category_id, name, description, inventory_type, unit,
   quantity_in_stock, cost_price, selling_price)
select o.id, cat.id, v.name, v.description, v.inventory_type::inventory_type, v.unit,
       v.quantity_in_stock, v.cost_price, v.selling_price
from organizations o
cross join (values
    ('Regular Box', 'Black box with black logo', 'packaging_material', 'Box', 'Pcs', 4, 50, 0),
    ('Ribbon Paper bag', 'Black paper bag with ribbo handle', 'packaging_material', 'Paper bag', 'Pcs', 181, 18, 0),
    ('Wash Instructions', 'Washing instructions card', 'packaging_material', 'Card', 'Pcs', 94, 1.5, 0),
    ('Signature message', 'Signature message card', 'packaging_material', 'Card', 'Pcs', 96, 2, 0),
    ('Personal Message', 'Persnal note to customer', 'packaging_material', 'Card', 'Pcs', 88, 2, 0),
    ('String Tag', 'Hard tag as label', 'packaging_material', 'Tag', 'Pcs', 40, 4.5, 0),
    ('White wrapper', 'White Light translucent wrapper', 'packaging_material', 'Wrapper', 'Pcs', 0, 1, 0),
    ('Black Envelope', 'Black Envelope for cards', 'packaging_material', 'Envelope', 'Pcs', 29, 5, 0),
    ('Poly Mailer bag', 'Black Poly mailer bag', 'packaging_material', 'Poly Mailer bag', 'Pcs', 99, 3.5, 0),
    ('Black T-shirt L', 'Black t-shirt Large', 'raw_material', 'Plain T-shirt', 'Pcs', 12, 110, 0),
    ('Black T-shirt XL', 'Black t-shirt extra Large', 'raw_material', 'Plain T-shirt', 'Pcs', 2, 110, 0),
    ('Black T-shirt 2XL', 'Black t-shirt Double extra Large', 'raw_material', 'Plain T-shirt', 'Pcs', 2, 110, 0),
    ('White T-shirt L', 'White t-shirt Large', 'raw_material', 'Plain T-shirt', 'Pcs', 13, 110, 0),
    ('White T-shirt XL', 'White t-shirt extra Large', 'raw_material', 'Plain T-shirt', 'Pcs', 5, 110, 0),
    ('White T-shirt 2XL', 'White t-shirt double extra Large', 'raw_material', 'Plain T-shirt', 'Pcs', 2, 110, 0),
    ('Black Classic Cap', 'Black Classic Cap', 'finished_product', 'Cap', 'Pcs', 3, 25, 100),
    ('Beige Classic Cap', 'Beige Classic Cap', 'finished_product', 'Cap', 'Pcs', 1, 25, 100),
    ('Black tote Bag', 'Black tote Bag', 'finished_product', 'tote bag', 'Pcs', 3, 50, 150),
    ('Biege tote Bag', 'Biege tote Bag', 'finished_product', 'tote bag', 'Pcs', 5, 50, 150),
    ('Olive Linen', 'A relaxed long-sleeve linen shirt in a warm, earthy olive colorway.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1200),
    ('Coastal', 'A breezy long-sleeve linen shirt inspired by coastal aesthetics.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1200),
    ('Soleil', 'A sun-drenched long-sleeve linen shirt with a light, airy feel.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1060),
    ('Shore', 'A clean, minimal long-sleeve linen shirt with a shoreline-inspired palette.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1060),
    ('Sahel', 'An earthy long-sleeve linen shirt drawing from West African landscape tones.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1060),
    ('Traverse', 'A versatile long-sleeve linen shirt designed for effortless layering.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1100),
    ('Meridian Stripe', 'A refined long-sleeve linen shirt featuring a signature stripe detail.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1060),
    ('The Linear Heritage Shirt', 'A heritage-inspired short-sleeve linen shirt with linear graphic detailing.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 900),
    ('Linear Rebellion Linen', 'A statement long-sleeve linen shirt with bold linear graphic detailing.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 1200),
    ('Verdant Overshirt', 'A structured woven overshirt in rich verdant tones for a layered statement.', 'finished_product', 'Overshirts', 'Pcs', 0, 250, 960),
    ('Riviera Drawstring Trouser', 'A relaxed linen drawstring trouser with a refined, Riviera-inspired drape.', 'finished_product', 'Trousers & Tailored Pants', 'Pcs', 0, 360, 990),
    ('Essential Linen Trouser', 'A clean-cut tailored linen trouser built for everyday elegance.', 'finished_product', 'Trousers & Tailored Pants', 'Pcs', 0, 360, 1000),
    ('Nomad Essential Short Sleeve', 'A go-anywhere short-sleeve linen shirt with a clean, essential silhouette.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 960),
    ('Grandad Short Sleeve Linen', 'A classic grandad-collar short-sleeve linen shirt for effortless style.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 900),
    ('Grandad Rebellion Linen', 'A grandad-collar linen shirt with a rebellious graphic twist.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 1000),
    ('The Lido', 'A resort-ready short-sleeve linen shirt with a relaxed, poolside feel.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 660),
    ('The Capri', 'A short-sleeve linen shirt capturing the effortless elegance of island dressing.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 660),
    ('The Canopy', 'A relaxed short-sleeve linen shirt with a nature-inspired, open energy.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 600),
    ('The Terracotta', 'A short-sleeve linen shirt in warm, earthy terracotta tones.', 'finished_product', 'Linen Shirts — Short Sleeve', 'Pcs', 0, 340, 600),
    ('Sovereign Tailored Trouser', 'A sharp suiting-quality tailored trouser with a confident silhouette.', 'finished_product', 'Trousers & Tailored Pants', 'Pcs', 0, 360, 530),
    ('Pakeru Core', 'The brand''s foundational premium cotton tee with clean signature detailing.', 'finished_product', 'Signature T-Shirts', 'Pcs', 0, 250, 530),
    ('Aurea Volume Pants', 'Oversized volume pants with a sculptural silhouette and relaxed fit.', 'finished_product', 'Volume & Cargo Pants', 'Pcs', 0, 245, 560),
    ('Relaxed Volume Pants', 'Easy-wearing wide-leg volume pants with a casual, laid-back feel.', 'finished_product', 'Volume & Cargo Pants', 'Pcs', 0, 245, 570),
    ('Atlas Cargo Jeans', 'Heavy-duty cargo jeans with utility pockets and a rugged aesthetic.', 'finished_product', 'Volume & Cargo Pants', 'Pcs', 0, 245, 560),
    ('Forge Cargo Shorts', 'Durable cargo shorts with deep utility pockets and a rugged, workwear finish.', 'finished_product', 'Shorts', 'Pcs', 0, 200, 510),
    ('Column Tee', 'A structured textured tee with clean vertical column detailing.', 'finished_product', 'Textured Tees & Polo', 'Pcs', 0, 250, 550),
    ('Horizon Overshirt', 'A relaxed open-weave overshirt with a clean, horizon-inspired finish.', 'finished_product', 'Overshirts', 'Pcs', 0, 250, 660),
    ('Strata Overshirt', 'A textured, layered-look overshirt with a structured woven construction.', 'finished_product', 'Overshirts', 'Pcs', 0, 250, 660),
    ('Mesline', 'A textured jersey tee with a subtle mesh-line surface for added depth.', 'finished_product', 'Textured Tees & Polo', 'Pcs', 0, 250, 520),
    ('Niore Crop', 'A cropped woven top with a clean, architectural silhouette.', 'finished_product', 'Female Tops', 'Pcs', 0, 200, 570),
    ('Vierra Crop', 'A feminine cropped top with a soft drape and delicate finishing.', 'finished_product', 'Female Tops', 'Pcs', 0, 200, 580),
    ('Flow Tailored Pants', 'Wide-leg tailored pants with a fluid drape and effortless ease.', 'finished_product', 'Trousers & Tailored Pants', 'Pcs', 0, 360, 510),
    ('Axis Cargo Jeans', 'Slim-tapered cargo jeans blending streetwear edge with functional design.', 'finished_product', 'Volume & Cargo Pants', 'Pcs', 0, 245, 570),
    ('Vierra Skirt', 'A flowing woven skirt with a clean waistband and feminine, easy silhouette.', 'finished_product', 'Skirts', 'Pcs', 0, 200, 550),
    ('Spire Polo', 'A refined polo with a structured collar and premium knit construction.', 'finished_product', 'Textured Tees & Polo', 'Pcs', 0, 250, 550),
    ('Aegis Tank', 'A sleek knit tank with a shield-inspired design detail and clean lines.', 'finished_product', 'Tanks', 'Pcs', 0, 117, 400),
    ('Loma Tank', 'A soft, minimal knit tank with a clean, nature-inspired aesthetic.', 'finished_product', 'Tanks', 'Pcs', 0, 117, 400),
    ('Edge Tank', 'A sharp, streamlined knit tank with an edge-forward design attitude.', 'finished_product', 'Tanks', 'Pcs', 0, 117, 400),
    ('Verde Crop', 'A fresh cropped top in earthy green tones with a relaxed, effortless fit.', 'finished_product', 'Female Tops', 'Pcs', 0, 200, 570),
    ('Pakeru Spek', 'A handcrafted artisan woven shirt celebrating traditional textile techniques.', 'finished_product', 'Artisan Woven', 'Pcs', 0, 236, 520),
    ('Pakeru Yvan', 'An artisan woven piece with intricate pattern work and cultural depth.', 'finished_product', 'Artisan Woven', 'Pcs', 0, 236, 520),
    ('Signature Essential Linen', 'A foundational long-sleeve linen shirt in a clean, essential cut.', 'finished_product', 'Linen Shirts — Long Sleeve', 'Pcs', 0, 340, 660),
    ('Pakeru Livity', 'A specialist handwoven garment embodying Pakeru''s ethos of craft and identity.', 'finished_product', 'Artisan Woven', 'Pcs', 0, 236, 520),
    ('Pakeru Aegis', 'A signature tee with a protective, shield-inspired graphic and premium jersey build.', 'finished_product', 'Signature T-Shirts', 'Pcs', 0, 250, 450),
    ('Pakeru Loma', 'A soft premium tee with understated, nature-inspired graphic detailing.', 'finished_product', 'Signature T-Shirts', 'Pcs', 0, 250, 450),
    ('Pakeru Edge', 'A bold, edge-forward signature tee in premium jersey construction.', 'finished_product', 'Signature T-Shirts', 'Pcs', 0, 250, 450),
    ('Essential Formal', 'A meticulously tailored formal shirt in premium suiting fabric for elevated occasions.', 'finished_product', 'Essential Formal', 'Pcs', 0, 300, 570)
) as v(name, description, inventory_type, category, unit,
       quantity_in_stock, cost_price, selling_price)
left join inventory_categories cat
  on cat.organization_id = o.id and cat.name = v.category
where o.name = 'Pakeru'
  and not exists (
    select 1 from inventory_items i
    where i.organization_id = o.id and i.name = v.name
  );
