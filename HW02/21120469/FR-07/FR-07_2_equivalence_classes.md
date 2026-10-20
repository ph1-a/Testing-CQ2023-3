# FR-07 – Step 2: Identify equivalence classes for each input & output

Input: the variables and decisions (D1–D9) in `FR-07_1_variables.md`. Method: lecture S04 *Domain Testing*, step 2.

## Guidelines applied (S04, slides 8–11)

| Condition kind | Rule | Example in this feature |
|---|---|---|
| **Range** | 1 valid class + 2 invalid classes (below, above) | Quantity 1 … M (M = maximum, probed at execution per D2) |
| **Set** | 1 valid class per element (if handled differently) + 1 invalid class | Where "Add to cart" is clicked, dialog answer, reload type |
| **Must be** | 1 valid class + 1 invalid class | Quantity is a whole number, product ID exists, token valid |
| **Split** | Split a class when its members may not be handled the same way | Quantity 0 vs negative, price 0/negative vs other wrong price, name with HTML |

**Legend:** V = valid, I = invalid, TBD = expected result decided at execution. "Tester decision" = the spec is silent; the expected result was chosen by the tester (see the decision log).
**M** = the maximum quantity. The spec has none; per D2 it is found at execution by probing from `99999999999` upward.
Representative values are **not** chosen here; that is step 3.

## Input equivalence classes

### FR-07_IN_01 – Product being added

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_01 | C1 Exists in catalog (must be) | Product exists in the catalog | V | Spec |
| FR-07_EC_02 | C1 (split) | Product was deleted from the catalog (by admin) after being added to the cart | I | Tester decision: row removed or marked unavailable |

In the UI a user can only add products that are listed, so "non-existent product" is tested through the API (IN_16).

### FR-07_IN_02 – Quantity on the product detail page

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_03 | C1 Required (must be) | Not empty | V | Assumption |
| FR-07_EC_04 | C1 Required (must be) | Empty | I | Assumption |
| FR-07_EC_05 | C2 Whole number (must be) | Plain whole number (digits only) | V | Spec (FR-06) + D9 |
| FR-07_EC_06 | C2 (split) | Decimal (e.g. `1.5`) | I | D9 |
| FR-07_EC_07 | C2 (split) | Non-numeric text (letters, symbols) | I | Spec (FR-06) |
| FR-07_EC_08 | C2 (split) | Leading zeros (e.g. `007`) | V | Tester decision: accepted as 7 |
| FR-07_EC_09 | C2 (split) | With a plus sign (e.g. `+3`) | I | Tester decision: rejected |
| FR-07_EC_10 | C2 (split) | Scientific notation (e.g. `1e2`) | I | Tester decision: rejected |
| FR-07_EC_11 | C3 Range 1 … M | 1 ≤ quantity ≤ M | V | Spec (FR-06: min 1) + D2 |
| FR-07_EC_12 | C3 Range, below (split) | Quantity = 0 | I | Spec (FR-06) |
| FR-07_EC_13 | C3 Range, below (split) | Quantity < 0 | I | Spec (FR-06) |
| FR-07_EC_14 | C3 Range, above | Quantity > M | I | D2 |

"Below the range" is split into 0 and negative: a negative quantity could be handled differently, for example by subtracting from the cart.

### FR-07_IN_03 – Where "Add to cart" is clicked

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_15 | C1 Source (set) | Product detail page (quantity from IN_02) | V | Spec (FR-06) |
| FR-07_EC_16 | C1 Source (set) | Home page (quantity 1) | V | Assumption |

No invalid class: there are no other "Add to cart" buttons.

### FR-07_IN_04 – Product already in the cart

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_17 | C1 In cart (set) | Not yet in the cart | V | Spec |
| FR-07_EC_18 | C1 In cart (set) | Already in the cart, added again from the same page | V | Spec |
| FR-07_EC_19 | C1 In cart (split) | Already in the cart, added again from the other page (home ↔ detail) | TBD | D8 |

### FR-07_IN_05 – "+" button

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_20 | C1 Result ≤ M (range) | Clicked when quantity < M | V | Spec |
| FR-07_EC_21 | C1 Result ≤ M (range) | Clicked when quantity = M | I | D2 |

### FR-07_IN_06 – "−" button

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_22 | C1 Result ≥ 1 (range) | Clicked when quantity ≥ 2 | V | Spec |
| FR-07_EC_23 | C1 Result ≥ 1 (range) | Clicked when quantity = 1 (button must be disabled) | I | D3 |

### FR-07_IN_07 – Delete button

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_24 | C1 Clicked (set) | Delete clicked on a row | V | Spec |

### FR-07_IN_08 – Answer to the delete confirmation

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_25 | C1 Answer (set) | Confirm | V | Spec |
| FR-07_EC_26 | C1 Answer (set) | Cancel | V | Assumption |

### FR-07_IN_09 – "Continue shopping" button

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_27 | C1 Clicked (set) | Clicked | V | Spec |

### FR-07_IN_10 – Number of distinct products in the cart

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_28 | C1 Count (split) | 0 products (empty cart) | V | Spec |
| FR-07_EC_29 | C1 Count (split) | Exactly 1 product | V | Assumption |
| FR-07_EC_30 | C1 Count (split) | 2 or more products | V | Assumption |

The count cannot be negative, so there is no invalid class. It is split because an empty cart has its own display (FR-07) and totals over several rows are computed differently from a single row.

### FR-07_IN_11 – Login state

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_31 | C1 Login state (set) | Guest (must be able to use the cart) | V | D1 |
| FR-07_EC_32 | C1 Login state (set) | Logged in | V | Spec |

### FR-07_IN_12 – Reload / leaving and returning

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_33 | C1 Navigation type (set) | Navigate inside the app and come back (e.g. "Continue shopping", then Cart) | V | Spec (implied: FR-07 sends users shopping and merges re-added products) |
| FR-07_EC_34 | C1 Navigation type (set) | Full page reload (F5) | V | Tester decision (D5): kept for logged-in users; lost acceptable for guests |
| FR-07_EC_35 | C1 Navigation type (set) | Log out, then log in again | V | Tester decision (D5): kept |

### FR-07_IN_13 – `price` sent in `POST /api/cart`

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_36 | C1 Equals catalog price (must be) | Same as the catalog price | V | D7 |
| FR-07_EC_37 | C1 (split) | A different positive price | I | D7 |
| FR-07_EC_38 | C1 (split) | Zero or negative | I | D7 |
| FR-07_EC_39 | C1 (split) | Non-numeric or missing | I | D7 |

### FR-07_IN_14 – `name` sent in `POST /api/cart`

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_40 | C1 Equals catalog name (must be) | Same as the catalog name | V | D7 |
| FR-07_EC_41 | C1 (split) | Different plain text | I | D7 |
| FR-07_EC_42 | C1 (split) | Contains HTML or script | I | D7 + SEC-04 |

### FR-07_IN_15 – `quantity` sent in `POST /api/cart`

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_43 | C1 Range 1 … M | Whole number, 1 ≤ quantity ≤ M | V | Assumption (FR-06 rule) |
| FR-07_EC_44 | C1 Range, below (split) | 0 | I | Assumption |
| FR-07_EC_45 | C1 Range, below (split) | Negative | I | Assumption |
| FR-07_EC_46 | C1 Range, above | > M | I | D2 |
| FR-07_EC_47 | C2 Whole number (split) | Decimal | I | D9 |
| FR-07_EC_48 | C2 Whole number (split) | Non-numeric or missing | I | Assumption |

### FR-07_IN_16 – `id` sent in `POST /api/cart`

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_49 | C1 Existing product (must be) | Existing product ID | V | Assumption |
| FR-07_EC_50 | C1 (split) | Numeric ID of no product | I | Assumption |
| FR-07_EC_51 | C1 (split) | Non-numeric or missing | I | Assumption |

### FR-07_IN_17 – Auth token on cart API

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_52 | C1 Valid token (must be) | Valid token | V | Spec (API 4) |
| FR-07_EC_53 | C1 (split) | No token | I | Spec (API 4) |
| FR-07_EC_54 | C1 (split) | Invalid or tampered token | I | Spec (API 4) |

### FR-07_IN_18 – Quantity typed directly in a cart row

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-07_EC_55 | C1 Range 1 … M | Plain whole number, 1 ≤ quantity ≤ M | V | D6 |
| FR-07_EC_56 | C2 Required (must be) | Empty | I | D6 |
| FR-07_EC_57 | C1 Range, below (split) | 0 | I | D6 |
| FR-07_EC_58 | C1 Range, below (split) | Negative | I | D6 |
| FR-07_EC_59 | C1 Range, above | > M | I | D6 + D2 |
| FR-07_EC_60 | C3 Whole number (split) | Decimal | I | D6 + D9 |
| FR-07_EC_61 | C3 Whole number (split) | Non-numeric text | I | D6 |
| FR-07_EC_62 | C3 Whole number (split) | Leading zeros (e.g. `007`) | V | Tester decision: accepted (as EC_08) |
| FR-07_EC_88 | C3 Whole number (split) | Plus sign or scientific notation (`+3`, `1e2`) | I | Tester decision: rejected (as EC_09, EC_10) |

EC_88 was split from EC_62 after review: the tester accepted `007` but rejected `+3` and `1e2`, so one class could no longer hold both. It is numbered after the output classes to keep earlier IDs stable.

## Output equivalence classes

| Class ID | Output variable | Equivalence class | Triggered by | Source |
|---|---|---|---|---|
| FR-07_EC_63 | OUT_01 Table columns | Exactly Sản phẩm, Đơn giá, Số lượng, Thành tiền, Thao tác | Any non-empty cart (EC_29, EC_30) | Spec |
| FR-07_EC_64 | OUT_02 Unit price | Catalog price, `₫` with thousand separators | Any add; EC_37–EC_39 via API | Spec |
| FR-07_EC_65 | OUT_03 Quantity shown | Sum of quantities added, adjusted by +/− or typing | EC_11, EC_18, EC_20, EC_22, EC_55 | Spec |
| FR-07_EC_66 | OUT_04 Line total | Unit price × quantity, `₫` format | Any non-empty cart | Spec + Assumption |
| FR-07_EC_67 | OUT_05 Cart total | Sum of line totals, `₫` format | EC_29, EC_30 | Spec + Assumption |
| FR-07_EC_68 | OUT_06 Total label | Exactly "Tổng cộng" | Any non-empty cart | Spec |
| FR-07_EC_69 | OUT_07 Rows per product | Exactly 1 row | EC_18 (EC_19 if merge is decided) | Spec |
| FR-07_EC_70 | OUT_08 Delete dialog | Shown before deleting | EC_24 | Spec |
| FR-07_EC_71 | OUT_09 Row after delete | Removed | EC_24 + EC_25 | Spec |
| FR-07_EC_72 | OUT_09 Row after delete | Kept, unchanged | EC_24 + EC_26 | Assumption |
| FR-07_EC_73 | OUT_10 After "Continue shopping" | Home page shown | EC_27 | Spec |
| FR-07_EC_74 | OUT_11 Button label | Exactly "Tiếp tục mua sắm" | Cart page shown | Spec |
| FR-07_EC_75 | OUT_12 Empty state | Illustration/icon + clear message | EC_28 (including after deleting the last row) | Spec |
| FR-07_EC_76 | OUT_13 Add feedback | Toast or badge update | EC_15, EC_16 | Spec |
| FR-07_EC_77 | OUT_14 Badge | Equals total units in the cart | Any cart change | Spec + D4 |
| FR-07_EC_78 | OUT_15 Invalid quantity error | Message shown; cart unchanged | EC_04, 06, 07, 09, 10, 12, 13, 14, 21, 56–61, 88 | Assumption |
| FR-07_EC_79 | OUT_16 Cart after navigation | Kept | EC_33, EC_34 (logged in), EC_35 | Spec (implied) + D5 |
| FR-07_EC_80 | OUT_16 Cart after navigation | Lost | EC_34 (guest; acceptable, not a bug) | D5 |
| FR-07_EC_81 | OUT_17 API without valid token | Rejected (401/403); cart unchanged | EC_53, EC_54 | Spec (API 4) |
| FR-07_EC_82 | OUT_18 API with client price/name | Catalog values used; client values ignored | EC_37–EC_39, EC_41, EC_42 | D7 |
| FR-07_EC_83 | OUT_18 API with invalid quantity/id | Request rejected; cart unchanged | EC_44–EC_48, EC_50, EC_51 | Assumption |
| FR-07_EC_84 | OUT_19 Delete button colour | Red | Cart page shown | Spec (FR-21) |
| FR-07_EC_85 | OUT_20 Breadcrumb | Present on the Cart page | Cart page shown | Spec (FR-23) |
| FR-07_EC_86 | OUT_21 Page heading | Exactly one `<h1>` | Cart page shown (empty and non-empty) | Spec (FR-21) |
| FR-07_EC_87 | OUT_22 "−" at quantity 1 | Disabled; row not removed | EC_23 | D3 |

## Summary

| | Count |
|---|---|
| Valid input classes | 30 |
| Invalid input classes | 32 |
| TBD input classes (decided at execution) | 1 (EC_19) |
| Output classes | 25 |
| **Total** | **88** |

## Decision log (spec silent, decided by the tester)
Bugs raised from these classes must say they rest on a tester decision, not on the spec.

| Class | Question | Decision | Expected output |
|---|---|---|---|
| EC_02 | A product in the cart is deleted from the catalog | **Invalid** | Row removed or marked unavailable; cannot be checked out |
| EC_08 | Quantity `007` | **Valid**, accepted as 7 | Quantity 7 added |
| EC_09 | Quantity `+3` | **Invalid** | EC_78 (invalid quantity error) |
| EC_10 | Quantity `1e2` | **Invalid** | EC_78 |
| EC_19 | Same product from home page, then detail page (D8) | **Decided at execution** | Recorded with the result |
| EC_34 | Full page reload (D5) | **Valid**: kept for logged-in users; lost is acceptable for guests | EC_79 (logged in) / EC_80 (guest) |
| EC_35 | Log out and log in again (D5) | **Valid**: kept | EC_79 |
| EC_62 / EC_88 | Non-standard notation typed in the cart | Split: `007` **valid**; `+3`, `1e2` **invalid** | EC_65 / EC_78 |
