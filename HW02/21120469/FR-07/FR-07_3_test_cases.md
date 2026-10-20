# FR-07 – Step 3: Select test cases (best representative of each class)

Input: the classes in `FR-07_2_equivalence_classes.md`. Method: lecture S04, step 3:
- Choose **at least one** test case from each equivalence class.
- **Valid** classes: each test case covers as many valid classes as possible.
- **Invalid** classes: each test case covers **one and only one** invalid class. All its other inputs come from valid classes.

Columns follow the course template `Test cases_Template_En.xlsx`. Actual result, status, tester and date are filled in at step 5 (execution).

## Test data
Products as listed on the EShop home page after seeding (visible in the UI):

| Name | Product | Unit price |
|---|---|---|
| **A** | iPhone 15 Pro Max | 30.000.000 ₫ |
| **B** | Samsung Galaxy S24 Ultra | 28.000.000 ₫ |
| **C** | MacBook Pro M3 | 45.000.000 ₫ |

Product IDs (for the API) are read from the product detail URL `/product/<id>`; below they are assumed to be A = 1, B = 2, C = 3.
Money may be shown with `.` or `,` as the thousand separator; either satisfies FR-21 as long as it is consistent.

## Common setup

| ID | Setup |
|---|---|
| P1 | Backend (`:3000`) and frontend-web (`:5173`) running; database freshly seeded (`node database.js`). Cart is empty. |
| P2 | Logged in as `test@eshop.com` / `Test1234!`. |
| P3 | Guest: not logged in (log out, or use a private window). |
| P4 | **M is known.** M is the largest quantity the detail page accepts, found by FR-07_TC_24. Test cases marked P4 run after TC_24. |
| API | Postman or curl. Get a token with `POST http://localhost:3000/api/login` (`test@eshop.com` / `Test1234!`). `POST /api/cart` adds an item; `GET /api/cart` shows the server-side cart. Header: `Authorization: Bearer <token>`. |
| Cleanup | After each test case, empty the cart (delete every row) so the next one starts from an empty cart. |

## Valid test cases

| TC ID | Test case name | Classes covered | Precondition | Test steps (with data) | Expected result |
|---|---|---|---|---|---|
| FR-07_TC_01 | Add a product with quantity 2 and view the cart (logged in) | EC_01, 03, 05, 11, 15, 17, 29, 32; outputs EC_63, 64, 65, 66, 67, 68, 74, 76, 77, 84, 85, 86 | P1, P2 | 1. Open A's detail page.<br>2. Quantity `2`, click "Add to cart".<br>3. Open the Cart page. | 2. Toast or badge update shown; badge = 2.<br>3. One row. Columns exactly Sản phẩm, Đơn giá, Số lượng, Thành tiền, Thao tác. Unit price 30.000.000 ₫; quantity 2; line total 60.000.000 ₫. Total labelled "Tổng cộng" = 60.000.000 ₫. Button "Tiếp tục mua sắm". Delete button red. Breadcrumb present. Exactly one `<h1>`. |
| FR-07_TC_02 | Add the same product again from the same page | EC_18; outputs EC_65, 69, 77 | P1, P2; cart has A × 2 (from the detail page) | 1. Open A's detail page, quantity `1`, "Add to cart".<br>2. Open the Cart. | Still **one** row for A, quantity 3, line total 90.000.000 ₫; badge = 3. |
| FR-07_TC_03 | Guest adds two products from the home page | EC_16, 30, 31; output EC_67 | P1, P3 | 1. On the home page click "Add to cart" for A, then for B.<br>2. Open the Cart. | Guest is allowed (D1). Two rows, quantity 1 each. Total 58.000.000 ₫; badge = 2. |
| FR-07_TC_04 | Increase and decrease quantity with + and − | EC_20, 22; outputs EC_65, 66, 67, 77 | P1, P2; cart has A × 2 | 1. Click "+".<br>2. Click "−". | 1. Quantity 3; line total and total 90.000.000 ₫; badge 3.<br>2. Quantity 2; totals 60.000.000 ₫; badge 2. |
| FR-07_TC_05 | Delete a row and confirm | EC_24, 25; outputs EC_70, 71 | P1, P2; cart has A × 1 and B × 1 | 1. Click Delete on A.<br>2. Confirm. | 1. Confirmation dialog shown.<br>2. A removed; B remains; total 28.000.000 ₫; badge 1. |
| FR-07_TC_06 | Delete a row and cancel | EC_26; output EC_72 | P1, P2; cart has A × 1 | 1. Click Delete on A.<br>2. Cancel. | A still in the cart, unchanged. |
| FR-07_TC_07 | Delete the last row | EC_28; outputs EC_75, 86 | P1, P2; cart has A × 1 | 1. Delete A and confirm. | Empty state: illustration/icon and a clear message; exactly one `<h1>`; badge 0 or hidden. |
| FR-07_TC_08 | "Continue shopping", then come back | EC_27, 33; outputs EC_73, 79 | P1, P2; cart has A × 2 | 1. Click "Tiếp tục mua sắm".<br>2. Open the Cart from the navbar. | 1. Home page shown.<br>2. A × 2 still in the cart. |
| FR-07_TC_09 | Type a quantity in the cart | EC_55 | P1, P2; cart has A × 2 | Type `5` in A's quantity field, confirm (Enter / leave the field). | Quantity 5; line total and total 150.000.000 ₫; badge 5. |
| FR-07_TC_10 | Type a quantity with leading zeros in the cart | EC_62 | P1, P2; cart has A × 2 | Type `007` in A's quantity field, confirm. | Quantity 7 (tester decision); totals 210.000.000 ₫. |
| FR-07_TC_11 | Detail page quantity with leading zeros | EC_08 | P1, P2 | On A's detail page enter `007`, "Add to cart". | A × 7 added (tester decision). |
| FR-07_TC_12 | Full page reload, logged in | EC_34 (logged in); output EC_79 | P1, P2; cart has A × 2 | Press F5 on the Cart page. | A × 2 still in the cart (tester decision D5). |
| FR-07_TC_13 | Full page reload, guest | EC_34 (guest); output EC_80 | P1, P3; cart has A × 1 | Press F5 on the Cart page. | Cart kept or emptied; **both acceptable** for a guest (D5). Record which. |
| FR-07_TC_14 | Log out and log in again | EC_35; output EC_79 | P1, P2; cart has A × 2 | 1. Log out.<br>2. Log in as `test@eshop.com`.<br>3. Open the Cart. | A × 2 still in the cart (tester decision D5). |
| FR-07_TC_15 | Add to cart through the API with correct data | EC_36, 40, 43, 49, 52 | P1, API | `POST /api/cart` `{"id":1,"name":"iPhone 15 Pro Max","price":30000000,"quantity":2}`, then `GET /api/cart`. | HTTP 200; the cart contains A × 2 at 30.000.000 ₫. |
| FR-07_TC_16 | Same product from the home page, then the detail page | EC_19 (decided at execution) | P1, P2 | 1. Home page: "Add to cart" for A.<br>2. A's detail page: quantity `2`, "Add to cart".<br>3. Open the Cart. | **Decided at execution (D8).** Expected if the cart is kept between pages: one row, A × 3. Record what happens. |

## Invalid test cases – quantity on the detail page
Precondition for all: P1, P2, on A's detail page, empty cart. Each test enters one quantity and clicks "Add to cart". The field uses `type="number"` on many browsers; if the browser blocks the value from being typed at all, record that: it also counts as rejected.

| TC ID | Test case name | Class covered | Quantity entered | Expected result |
|---|---|---|---|---|
| FR-07_TC_17 | Empty quantity | EC_04; output EC_78 | `""` | Invalid-quantity error; cart and badge unchanged. |
| FR-07_TC_18 | Decimal quantity | EC_06 | `1.5` | Invalid-quantity error; cart unchanged. |
| FR-07_TC_19 | Non-numeric quantity | EC_07 | `abc` | Rejected (error, or cannot be typed); cart unchanged. |
| FR-07_TC_20 | Quantity with plus sign | EC_09 | `+3` | Invalid-quantity error (tester decision); cart unchanged. |
| FR-07_TC_21 | Quantity in scientific notation | EC_10 | `1e2` | Invalid-quantity error (tester decision); cart unchanged. |
| FR-07_TC_22 | Quantity 0 | EC_12 | `0` | Invalid-quantity error; cart unchanged. |
| FR-07_TC_23 | Negative quantity | EC_13 | `-1` | Invalid-quantity error; cart unchanged. |
| FR-07_TC_24 | Quantity above the maximum (find M) | EC_14 | `99999999999`; if accepted, empty the cart and try ×10 (`999999999990`, …) until rejected or `1e21` is reached | A maximum exists: the first rejected value shows an invalid-quantity error. **Record M** = the largest value accepted. If nothing is rejected up to `1e21`, record "no limit" as the finding (D2). |

## Invalid test cases – + and − buttons

| TC ID | Test case name | Class covered | Precondition | Test steps | Expected result |
|---|---|---|---|---|---|
| FR-07_TC_25 | "+" at the maximum | EC_21 | P1, P2, P4; cart has A × M | Click "+". | Quantity stays M; error shown or "+" disabled. |
| FR-07_TC_26 | "−" at quantity 1 | EC_23; output EC_87 | P1, P2; cart has A × 1 | Look at "−", then try to click it. | "−" is disabled; the row stays with quantity 1 (tester decision D3). |

## Invalid test cases – quantity typed in the cart
Precondition for all: P1, P2, cart has A × 2. Each test types one value in A's quantity field and confirms.

| TC ID | Test case name | Class covered | Value typed | Expected result |
|---|---|---|---|---|
| FR-07_TC_27 | Empty | EC_56 | `""` | Invalid-quantity error; quantity goes back to 2; totals unchanged. |
| FR-07_TC_28 | Zero | EC_57 | `0` | Invalid-quantity error; quantity stays 2 (row is not deleted). |
| FR-07_TC_29 | Negative | EC_58 | `-1` | Invalid-quantity error; quantity stays 2. |
| FR-07_TC_30 | Above the maximum | EC_59 | M + 1 (needs P4) | Invalid-quantity error; quantity stays 2. |
| FR-07_TC_31 | Decimal | EC_60 | `2.5` | Invalid-quantity error; quantity stays 2. |
| FR-07_TC_32 | Non-numeric | EC_61 | `abc` | Rejected; quantity stays 2. |
| FR-07_TC_33 | Plus sign | EC_88 | `+3` | Invalid-quantity error (tester decision); quantity stays 2. |

## Invalid test case – product removed from the catalog

| TC ID | Test case name | Class covered | Precondition | Test steps | Expected result |
|---|---|---|---|---|---|
| FR-07_TC_34 | Product in the cart is deleted by admin | EC_02 | P1, P2; cart has C × 1; admin web app running | 1. In the admin app, delete product C.<br>2. As the user, open (or reload) the Cart. | C's row is removed or marked unavailable and cannot be checked out (tester decision). |

## Invalid test cases – cart API
Precondition for all: P1, API (valid token unless stated). Each request is the valid body from TC_15, `{"id":1,"name":"iPhone 15 Pro Max","price":30000000,"quantity":2}`, with **one** field changed. After each request, check `GET /api/cart`.

| TC ID | Test case name | Class covered | Change from the valid request | Expected result |
|---|---|---|---|---|
| FR-07_TC_35 | Lower price | EC_37; output EC_82 | `"price":1` | Cart shows A at the catalog price 30.000.000 ₫, not 1 (D7). |
| FR-07_TC_36 | Negative price | EC_38 | `"price":-30000000` | Catalog price used; no negative total. |
| FR-07_TC_37 | Non-numeric price | EC_39 | `"price":"abc"` | Catalog price used, or request rejected; never `NaN`. |
| FR-07_TC_38 | Different name | EC_41 | `"name":"Free iPhone"` | Cart shows the catalog name "iPhone 15 Pro Max". |
| FR-07_TC_39 | Name with HTML | EC_42 | `"name":"<img src=x onerror=alert(1)>"` | Catalog name shown; in the cart page no image tag is rendered and no script runs (SEC-04). |
| FR-07_TC_40 | Quantity 0 | EC_44; output EC_83 | `"quantity":0` | Request rejected (HTTP 4xx); cart unchanged. |
| FR-07_TC_41 | Negative quantity | EC_45 | `"quantity":-5` | Rejected; cart unchanged. |
| FR-07_TC_42 | Quantity above the maximum | EC_46 | `"quantity":` M + 1 (needs P4) | Rejected; cart unchanged. |
| FR-07_TC_43 | Decimal quantity | EC_47 | `"quantity":1.5` | Rejected; cart unchanged. |
| FR-07_TC_44 | Non-numeric quantity | EC_48 | `"quantity":"abc"` | Rejected; cart unchanged. |
| FR-07_TC_45 | Non-existent product ID | EC_50 | `"id":99999` | Rejected; cart unchanged. |
| FR-07_TC_46 | Non-numeric product ID | EC_51 | `"id":"abc"` | Rejected; cart unchanged. |
| FR-07_TC_47 | No token | EC_53; output EC_81 | Remove the `Authorization` header | HTTP 401/403; cart unchanged. |
| FR-07_TC_48 | Tampered token | EC_54 | Change one character in the token's signature part | HTTP 401/403; cart unchanged. |

## Coverage check

Every class from step 2 is covered by at least one test case, and each invalid test case targets exactly one invalid input class.

| Class | Test case | | Class | Test case | | Class | Test case |
|---|---|---|---|---|---|---|---|
| EC_01 | TC_01 | | EC_31 | TC_03 | | EC_61 | TC_32 |
| EC_02 | TC_34 | | EC_32 | TC_01 | | EC_62 | TC_10 |
| EC_03 | TC_01 | | EC_33 | TC_08 | | EC_63 | TC_01 |
| EC_04 | TC_17 | | EC_34 | TC_12, TC_13 | | EC_64 | TC_01 |
| EC_05 | TC_01 | | EC_35 | TC_14 | | EC_65 | TC_01 |
| EC_06 | TC_18 | | EC_36 | TC_15 | | EC_66 | TC_01 |
| EC_07 | TC_19 | | EC_37 | TC_35 | | EC_67 | TC_01 |
| EC_08 | TC_11 | | EC_38 | TC_36 | | EC_68 | TC_01 |
| EC_09 | TC_20 | | EC_39 | TC_37 | | EC_69 | TC_02 |
| EC_10 | TC_21 | | EC_40 | TC_15 | | EC_70 | TC_05 |
| EC_11 | TC_01 | | EC_41 | TC_38 | | EC_71 | TC_05 |
| EC_12 | TC_22 | | EC_42 | TC_39 | | EC_72 | TC_06 |
| EC_13 | TC_23 | | EC_43 | TC_15 | | EC_73 | TC_08 |
| EC_14 | TC_24 | | EC_44 | TC_40 | | EC_74 | TC_01 |
| EC_15 | TC_01 | | EC_45 | TC_41 | | EC_75 | TC_07 |
| EC_16 | TC_03 | | EC_46 | TC_42 | | EC_76 | TC_01 |
| EC_17 | TC_01 | | EC_47 | TC_43 | | EC_77 | TC_01 |
| EC_18 | TC_02 | | EC_48 | TC_44 | | EC_78 | TC_17 |
| EC_19 | TC_16 | | EC_49 | TC_15 | | EC_79 | TC_08 |
| EC_20 | TC_04 | | EC_50 | TC_45 | | EC_80 | TC_13 |
| EC_21 | TC_25 | | EC_51 | TC_46 | | EC_81 | TC_47 |
| EC_22 | TC_04 | | EC_52 | TC_15 | | EC_82 | TC_35 |
| EC_23 | TC_26 | | EC_53 | TC_47 | | EC_83 | TC_40 |
| EC_24 | TC_05 | | EC_54 | TC_48 | | EC_84 | TC_01 |
| EC_25 | TC_05 | | EC_55 | TC_09 | | EC_85 | TC_01 |
| EC_26 | TC_06 | | EC_56 | TC_27 | | EC_86 | TC_01 |
| EC_27 | TC_08 | | EC_57 | TC_28 | | EC_87 | TC_26 |
| EC_28 | TC_07 | | EC_58 | TC_29 | | EC_88 | TC_33 |
| EC_29 | TC_01 | | EC_59 | TC_30 | | | |
| EC_30 | TC_03 | | EC_60 | TC_31 | | | |

## Summary

| | Count |
|---|---|
| Valid test cases | 15 |
| Test case with expected result decided at execution | 1 (TC_16) |
| Invalid test cases | 32 |
| **Total test cases** | **48** |
| Classes covered | 88 / 88 |

## Notes for review
1. **TC_01 checks 12 outputs at once** (columns, labels, colours, breadcrumb, heading, prices). If it fails, list each failing output separately in the bug reports.
2. **TC_24 finds M.** TC_25, TC_30 and TC_42 depend on it. If no limit is found, those three are "Not executed" and "no upper limit" is the finding.
3. **The API test cases check the server-side cart** (`GET /api/cart`). Whether the cart page in the browser shows the same data is itself worth recording at execution.
4. **TC_34 needs the admin app** (FR-15 product delete). If deleting fails, mark TC_34 "Not executed" with the reason.
5. **Expected error wording** is not in the spec; "invalid-quantity error" means "a message with that meaning".
6. **Test data comes from what the home page shows after seeding.** If the products or prices differ on your machine, update the totals before executing.
