# FR-07 – Step 4: Boundary value analysis

Input: the classes in `FR-07_2_equivalence_classes.md` and the test cases in `FR-07_3_test_cases.md`. Method: lecture S04, step 4.

## Method
- BVA applies to **ordered** domains (quantities, counts, prices, IDs, displayed numbers). For each ordered class, test **LB−1, LB, LB+1, UB−1, UB, UB+1**, plus the smallest/largest value the UI allows (slide 26, points 8* and 9*).
- A boundary point already hit by a step 3 test case is **reused, not duplicated**.
- Valid boundary points may share a test case; each invalid boundary point gets its own.
- **M** = the largest quantity accepted, found by FR-07_TC_24. **N** = the number of products in the catalog (count them on the home page after seeding).
- Test data and setups P1–P4 are the same as in step 3 (A = iPhone 15 Pro Max, 30.000.000 ₫).

## Variables with no ordered domain (no BVA)
| Variable | Why no BVA |
|---|---|
| IN_03 Add-to-cart source, IN_07 Delete, IN_08 Dialog answer, IN_09 Continue shopping | Buttons and choices: sets, not ordered. |
| IN_11 Login state, IN_12 Navigation type | Sets. |
| IN_14 `name` via API | Text with no length rule; the server must ignore it (D7). |
| IN_17 Auth token | Set {valid, missing, tampered}. |

## Boundary table
V = expected accepted, I = expected rejected.

### B1. Quantity on the detail page (IN_02) – valid range [1, M]
| Point | Value | V / I | Test case |
|---|---|---|---|
| Smallest via UI (8*) | `-99999999999` | I | **FR-07_BVA_02** |
| LB−1 | `0` | I | FR-07_TC_22 |
| LB | `1` | V | **FR-07_BVA_01** |
| LB+1 | `2` | V | FR-07_TC_01 |
| UB−1 | M − 1 | V | **FR-07_BVA_03** |
| UB | M | V | **FR-07_BVA_04** |
| UB+1 | M + 1 (first rejected value) | I | FR-07_TC_24 |
| Largest via UI (9*) | up to `1e21` | I | FR-07_TC_24 |

### B2. Quantity typed in the cart (IN_18) – valid range [1, M]
| Point | Value | V / I | Test case |
|---|---|---|---|
| LB−1 | `0` | I | FR-07_TC_28 |
| LB | `1` | V | **FR-07_BVA_05** |
| LB+1 | `2` | V | **FR-07_BVA_05** |
| UB−1 | M − 1 | V | **FR-07_BVA_06** |
| UB | M | V | **FR-07_BVA_06** |
| UB+1 | M + 1 | I | FR-07_TC_30 |

### B3. + and − buttons (IN_05, IN_06) – result must stay in [1, M]
| Point | Action | V / I | Test case |
|---|---|---|---|
| "+" at LB | 1 → 2 | V | **FR-07_BVA_07** |
| "−" at LB+1 | 2 → 1 | V | **FR-07_BVA_07** |
| "−" at LB | at 1 (must be disabled) | I | FR-07_TC_26 |
| "+" at UB−1 | M − 1 → M | V | **FR-07_BVA_08** |
| "+" at UB | at M | I | FR-07_TC_25 |

### B4. `quantity` in `POST /api/cart` (IN_15) – valid range [1, M]
| Point | Value | V / I | Test case |
|---|---|---|---|
| LB−1 | `0` | I | FR-07_TC_40 |
| LB | `1` | V | **FR-07_BVA_09** |
| LB+1 | `2` | V | FR-07_TC_15 |
| UB−1 | M − 1 | V | **FR-07_BVA_10** |
| UB | M | V | **FR-07_BVA_10** |
| UB+1 | M + 1 | I | FR-07_TC_42 |

### B5. Number of distinct products in the cart (IN_10) – range [0, N]
| Point | Value | V / I | Test case |
|---|---|---|---|
| LB | 0 (empty state) | V | FR-07_TC_07 |
| LB+1 | 1 | V | FR-07_TC_01 |
| LB+2 | 2 | V | FR-07_TC_03 |
| UB−1 | N − 1 | V | **FR-07_BVA_11** |
| UB (9*) | N (every product in the catalog) | V | **FR-07_BVA_11** |

UB+1 is impossible: there is no (N+1)-th product to add.

### B6. Size of the displayed totals (OUT_04, OUT_05) – output must stay exact and in `₫` format
Line totals and the cart total are outputs computed from price × quantity. Very large results are where systems lose precision (digits rounded) or switch format (for example to `3e+18`). Expected values are computed with exact arithmetic (e.g. Python or Windows Calculator), never with a spreadsheet, which rounds after 15 digits.

| Point | Quantity of A | Exact expected line total | Test case |
|---|---|---|---|
| Quantity = M | M | M × 30.000.000 ₫ | **FR-07_BVA_04** |
| The D2 starting probe | `99999999999` | 2.999.999.999.970.000.000 ₫ | **FR-07_BVA_12** |
| Just below 10²¹ | `33333333333333` | 999.999.999.999.990.000.000 ₫ | **FR-07_BVA_13** |
| Just above 10²¹ | `33333333333334` | 1.000.000.000.000.020.000.000 ₫ | **FR-07_BVA_13** |

BVA_12 and BVA_13 only apply if M is at least that large; otherwise they are "Not executed".

### B7. Cart badge number (OUT_14) – display width
The badge shows total units (D4). The number of digits is an ordered output: a badge built for one or two digits can be cut off or replaced by "99+".

| Point | Total units | Test case |
|---|---|---|
| 0 | 0 | FR-07_TC_07 |
| 1 digit, upper | 9 | **FR-07_BVA_14** |
| 2 digits, lower | 10 | **FR-07_BVA_14** |
| 2 digits, upper | 99 | **FR-07_BVA_14** |
| 3 digits, lower | 100 | **FR-07_BVA_14** |

### B8. `price` in `POST /api/cart` (IN_13) – only the catalog price (30.000.000) is accepted as-is
D7: whatever price the client sends, the cart must use the catalog price. Values just around the catalog price test whether the server compares exactly or only roughly.

| Point | Value | V / I | Test case |
|---|---|---|---|
| Lowest non-negative | `0` | I | **FR-07_BVA_15** |
| Catalog − 1 | `29999999` | I | **FR-07_BVA_16** |
| Catalog | `30000000` | V | FR-07_TC_15 |
| Catalog + 1 | `30000001` | I | **FR-07_BVA_17** |

### B9. `id` in `POST /api/cart` (IN_16) – valid range [1, N]
| Point | Value | V / I | Test case |
|---|---|---|---|
| LB−1 | `0` | I | **FR-07_BVA_18** |
| LB | `1` | V | FR-07_TC_15 |
| UB | N | V | **FR-07_BVA_19** |
| UB+1 | N + 1 | I | **FR-07_BVA_20** |

Assumes IDs run 1 … N without gaps after seeding; check with the detail-page URLs.

## New BVA test cases
Cleanup after each: empty the cart. "Exact" totals: compare every digit, not just the first few.

| TC ID | Test case name | Boundary | Precondition | Test steps (with data) | Expected result |
|---|---|---|---|---|---|
| FR-07_BVA_01 | Detail page quantity 1 | B1 LB | P1, P2 | A's detail page, quantity `1`, "Add to cart". | A × 1 in the cart; total 30.000.000 ₫; badge 1. |
| FR-07_BVA_02 | Detail page, very large negative | B1 8* | P1, P2 | A's detail page, quantity `-99999999999`, "Add to cart". | Invalid-quantity error; cart unchanged; no negative total. |
| FR-07_BVA_03 | Detail page quantity M − 1 | B1 UB−1 | P1, P2, P4 | Quantity M − 1, "Add to cart". | Accepted; line total exactly (M − 1) × 30.000.000 ₫. |
| FR-07_BVA_04 | Detail page quantity M | B1 UB; B6 | P1, P2, P4 | Quantity M, "Add to cart". | Accepted; line total and total exactly M × 30.000.000 ₫, in `₫` format with separators. |
| FR-07_BVA_05 | Cart: type 1, then 2 | B2 LB, LB+1 | P1, P2; cart has A × 5 | 1. Type `1`, confirm.<br>2. Type `2`, confirm. | 1. Quantity 1; total 30.000.000 ₫.<br>2. Quantity 2; total 60.000.000 ₫. |
| FR-07_BVA_06 | Cart: type M − 1, then M | B2 UB−1, UB | P1, P2, P4; cart has A × 2 | 1. Type M − 1, confirm.<br>2. Type M, confirm. | Both accepted; totals exact. |
| FR-07_BVA_07 | "+" from 1, then "−" back to 1 | B3 "+" at LB, "−" at LB+1 | P1, P2; cart has A × 1 | 1. Click "+".<br>2. Click "−". | 1. Quantity 2; "−" enabled.<br>2. Quantity 1; "−" now disabled (D3). |
| FR-07_BVA_08 | "+" from M − 1 to M | B3 "+" at UB−1 | P1, P2, P4; cart has A × (M − 1) | Click "+". | Quantity M; total exact; "+" now disabled or blocked. |
| FR-07_BVA_09 | API quantity 1 | B4 LB | P1, API | `POST /api/cart` with `"quantity":1`. | HTTP 200; cart has A × 1. |
| FR-07_BVA_10 | API quantity M − 1 and M | B4 UB−1, UB | P1, API, P4 | 1. `POST /api/cart` with `"quantity":` M − 1; check, then empty the cart.<br>2. Same with M. | Both accepted; `GET /api/cart` shows the exact quantity each time. |
| FR-07_BVA_11 | Every product in the cart | B5 UB−1, UB | P1, P2 | 1. Add every product except one (quantity 1 each); check the cart.<br>2. Add the last one; check again. | N − 1 rows, then N rows; total = sum of all catalog prices; badge N; page still readable. |
| FR-07_BVA_12 | Total at quantity 99.999.999.999 | B6 | P1, P2; M ≥ 99999999999 | A's detail page, quantity `99999999999`, "Add to cart"; open the Cart. | Line total and total exactly **2.999.999.999.970.000.000 ₫**: every digit correct, no exponent. |
| FR-07_BVA_13 | Totals around 10²¹ | B6 | P1, P2; M ≥ 33333333333334 | 1. Quantity `33333333333333`; check the cart; empty it.<br>2. Quantity `33333333333334`; check the cart. | 1. Exactly **999.999.999.999.990.000.000 ₫**.<br>2. Exactly **1.000.000.000.000.020.000.000 ₫**, shown as digits (not `1e+21`). |
| FR-07_BVA_14 | Badge with 9, 10, 99, 100 units | B7 | P1, P2; cart has A × 1 | Type `9`, then `10`, `99`, `100` in A's quantity field, checking the badge after each. | Badge shows 9, 10, 99, 100 exactly; not cut off and not "99+". |
| FR-07_BVA_15 | API price 0 | B8 | P1, API | `POST /api/cart` with `"price":0`. | Cart uses 30.000.000 ₫ (D7); total is not 0. |
| FR-07_BVA_16 | API price just below catalog | B8 | P1, API | `POST /api/cart` with `"price":29999999`. | Cart uses 30.000.000 ₫. |
| FR-07_BVA_17 | API price just above catalog | B8 | P1, API | `POST /api/cart` with `"price":30000001`. | Cart uses 30.000.000 ₫. |
| FR-07_BVA_18 | API product ID 0 | B9 LB−1 | P1, API | `POST /api/cart` with `"id":0`. | Rejected; cart unchanged. |
| FR-07_BVA_19 | API product ID N | B9 UB | P1, API | `POST /api/cart` with `"id":` N and that product's name and price. | HTTP 200; cart has product N. |
| FR-07_BVA_20 | API product ID N + 1 | B9 UB+1 | P1, API | `POST /api/cart` with `"id":` N + 1. | Rejected; cart unchanged. |

## Summary

| | Count |
|---|---|
| Ordered domains analysed | 9 (B1–B9) |
| Boundary points identified | 47 |
| Points already hit by step 3 test cases (reused) | 17 |
| Points needing new test cases | 30 |
| New BVA test cases (several valid points share one) | 20 |
| **Total FR-07 test cases (step 3 + step 4)** | **48 + 20 = 68** |

## Notes for review
1. **Seven test cases depend on M** (BVA_03, 04, 06, 08, 10, 12, 13). If TC_24 finds no limit, record "no upper limit" as the finding and mark those that cannot be run as "Not executed".
2. **B6 and B7 are output boundaries:** they check numbers the system displays, not numbers the user types. BVA_12 starts from D2's probe value, so it should run even if M turns out to be larger.
3. **Use exact arithmetic for expected totals.** Excel and Google Sheets round after 15 significant digits, so they would give wrong expected values for BVA_12 and BVA_13.
4. **B8 is an interpretation of D7.** The spec only says nothing about client prices; the tester decided the server must always use the catalog price, so any difference, even ±1 ₫, is a bug under that decision.
5. **B9 assumes IDs 1 … N without gaps.** If the detail-page URLs show gaps, use the lowest and highest real IDs instead.
