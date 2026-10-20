# FR-07 – Step 1: Identify input & output variables

## Spec used
Source: `eshop-sut/README.md` (FR-07, plus the related FR-06, FR-21, FR-23, FR-24) and `api_specification.md` (4.1, 4.2). Black-box: spec documents only, no source code.

> **FR-07: Shopping cart**
>
> - Shows the product list with columns **Product (Sản phẩm)**, **Unit price (Đơn giá)**, **Quantity (Số lượng)** with +/− buttons, **Line total (Thành tiền)**, **Actions (Thao tác)**.
> - Adding the same product again increases its quantity; it does not create a new row.
> - The **Delete** button must show a confirmation dialog first.
> - A **Continue shopping (Tiếp tục mua sắm)** button returns to the home page.
> - The total is labelled exactly **"Tổng cộng"** (not "Tổng tạm tính").
> - An empty cart shows an illustration and a clear message.
>
> **FR-06:** the product detail page has a **Quantity** input that accepts **positive integers only, minimum 1**, and an **Add to cart** button that gives visual feedback (toast or badge update).
>
>
> **FR-21:** money always uses `₫` with thousand separators; destructive buttons are red; exactly one `<h1>` per page.
>
> **FR-23:** the "Giỏ hàng" navbar link shows a **badge with the number of products in the cart**; breadcrumb required on the Cart page.
>
> **FR-24:** visual feedback after "Add to cart"; confirmation dialog when deleting; empty state with icon/illustration and a friendly message.
>
> **API 4.1 / 4.2:** `GET /api/cart` and `POST /api/cart` require `Authorization: Bearer <token>`. `POST /api/cart` body: `{"id", "name", "price", "quantity"}`.

## Defaults applied (change any you disagree with)
1. FR-06's quantity rule (positive integer, min 1) is applied to the cart: quantity in the cart must also stay ≥ 1.
2. Variables from FR-06, FR-21, FR-23 and FR-24 are included only where they concern the cart.
3. UI variables first; API-only variables (price, name and quantity sent by the client, auth token) are included and marked as assumptions.
4. Each distinct message, redirect or display is its own output row; wording is an assumption where the spec gives none.

## Input variables

| ID | Variable | Condition / constraint | Type | From spec or Assumption |
|---|---|---|---|---|
| FR-07_IN_01 | Product being added | Must be a product that exists in the catalog | Set | Spec |
| FR-07_IN_02 | Quantity entered on the product detail page | Whole number ≥ 1 (no decimals); maximum not specified, probed from 99999999999 upward | Number | Spec (FR-06) + Tester decision (D2, D9) |
| FR-07_IN_03 | Where "Add to cart" is clicked | Set: {product detail page (uses IN_02), home page (quantity 1)} | Set | Spec (detail page) + Assumption (home page button) |
| FR-07_IN_04 | Product already in the cart when added | Set: {not in cart, already in cart} | Set | Spec |
| FR-07_IN_05 | "+" button on a cart row | Clicked n times | Number | Spec |
| FR-07_IN_06 | "−" button on a cart row | Clicked n times; disabled at quantity 1 (rows have a Delete button) | Number | Spec + Tester decision (D3) |
| FR-07_IN_07 | Delete button on a cart row | Set: {clicked, not clicked} | Set | Spec |
| FR-07_IN_08 | Answer to the delete confirmation dialog | Set: {confirm, cancel} | Set | Spec (dialog) + Assumption (cancel option) |
| FR-07_IN_09 | "Continue shopping" button | Set: {clicked, not clicked} | Set | Spec |
| FR-07_IN_10 | Number of distinct products in the cart | Integer ≥ 0 | Number | Spec (empty state) + Assumption |
| FR-07_IN_11 | Login state when using the cart | Set: {guest, logged in}; guests must be able to use the cart | Set | Tester decision (D1) |
| FR-07_IN_12 | Page reload / leaving and returning to the cart | Set: {no reload, reload, navigate away and back, log out and in} | Set | Assumption |
| FR-07_IN_13 | `price` sent in `POST /api/cart` | Ignored: the server must use the catalog price | Number | Tester decision (D7); field from API 4.2 |
| FR-07_IN_14 | `name` sent in `POST /api/cart` | Ignored: the server must use the catalog name | Text | Tester decision (D7); field from API 4.2 |
| FR-07_IN_15 | `quantity` sent in `POST /api/cart` | Whole number ≥ 1 | Number | Assumption (FR-06 rule applied to the API) |
| FR-07_IN_16 | `id` sent in `POST /api/cart` | Must be an existing product ID | Number | Assumption (field from API 4.2) |
| FR-07_IN_17 | Auth token on cart API requests | Set: {valid, missing, invalid/expired} | Set | Spec (API 4 header) |
| FR-07_IN_18 | Quantity typed directly into a cart row | Whole number ≥ 1; same maximum as IN_02 | Number | Tester decision (D6) |

## Output variables

| ID | Variable | Condition / constraint | Type | From spec or Assumption |
|---|---|---|---|---|
| FR-07_OUT_01 | Cart table columns | Exactly: Sản phẩm, Đơn giá, Số lượng, Thành tiền, Thao tác | Set | Spec |
| FR-07_OUT_02 | Unit price shown on a row | Equals the catalog price; `₫` with thousand separators | Number | Spec (FR-07, FR-21) |
| FR-07_OUT_03 | Quantity shown on a row | Equals the total quantity added for that product, adjusted by +/− or typing | Number | Spec + Tester decision (D6) |
| FR-07_OUT_04 | Line total shown on a row | Unit price × quantity; `₫` with thousand separators | Number | Spec (column) + Assumption (formula) |
| FR-07_OUT_05 | Cart total value | Sum of all line totals; `₫` with thousand separators | Number | Spec + Assumption (formula) |
| FR-07_OUT_06 | Cart total label | Exactly "Tổng cộng" | Text | Spec |
| FR-07_OUT_07 | Number of rows for one product | Exactly 1 | Number | Spec |
| FR-07_OUT_08 | Delete confirmation dialog | Set: {shown before deleting, not shown} | Set | Spec (FR-07, FR-24) |
| FR-07_OUT_09 | Row after a delete action | Set: {removed (confirm), kept (cancel)} | Set | Spec + Assumption (cancel) |
| FR-07_OUT_10 | Redirect after "Continue shopping" | Home page | Set | Spec |
| FR-07_OUT_11 | "Continue shopping" button label | Exactly "Tiếp tục mua sắm" | Text | Spec |
| FR-07_OUT_12 | Empty cart state | Illustration/icon + clear message | Set | Spec (FR-07, FR-24) |
| FR-07_OUT_13 | Feedback after "Add to cart" | Toast or badge update shown | Set | Spec (FR-06, FR-24) |
| FR-07_OUT_14 | Cart badge number in navbar | Equals the total number of units in the cart | Number | Spec (FR-23) + Tester decision (D4) |
| FR-07_OUT_15 | Error: invalid quantity | Shown when IN_02 or IN_18 is not a whole number ≥ 1, or is above the maximum | Text | Assumption (wording; rule from FR-06) |
| FR-07_OUT_16 | Cart contents after reload / navigation / re-login | Set: {kept, lost}; expected lost (provisional) | Set | Tester decision (D5, provisional) |
| FR-07_OUT_17 | Response to cart API without a valid token | Rejected (e.g. HTTP 401/403); cart unchanged | Set | Spec (token required) + Assumption (status code) |
| FR-07_OUT_18 | Cart API response to client-supplied data | Price and name: catalog values used, client values ignored. Invalid quantity or id: request rejected | Set | Tester decision (D7) + Assumption |
| FR-07_OUT_22 | "−" button state at quantity 1 | Disabled; row not removed | Set | Tester decision (D3) |
| FR-07_OUT_19 | Delete button colour | Red | Set | Spec (FR-21) |
| FR-07_OUT_20 | Breadcrumb on the Cart page | Present | Set | Spec (FR-23) |
| FR-07_OUT_21 | Page heading | Exactly one `<h1>` | Number | Spec (FR-21) |

## Decision log (spec silent, decided by the tester)
Bugs raised from these decisions must say they rest on a tester decision, not on the spec.

| # | Question | Decision |
|---|---|---|
| D1 | Must the user be logged in to use the cart? | No. **Valid:** a guest can use the cart. **Invalid:** a guest is blocked. (IN_11) |
| D2 | Maximum quantity? | Not specified. Probe the ceiling: start at `99999999999` and increase until the system rejects or breaks. (IN_02, IN_18) |
| D3 | "−" at quantity 1? | Each row has a Delete button (FR-07), so "−" must be **disabled at 1**; it must not remove the row. (New output OUT_22) |
| D4 | What does the badge count? | **Total units** (sum of quantities). (OUT_14) |
| D5 | Should the cart survive reload / re-login? | **Provisional: no** (cart is expected to be lost). To revisit: API 4.1 (`GET /api/cart`) suggests a server-side cart, which would imply it should survive. (OUT_16) |
| D6 | Can quantity be typed directly in the cart? | **Yes**, both typing and +/− must work. (New input IN_18) |
| D7 | Client-supplied price/name in `POST /api/cart`? | Only **backend recalculation** is acceptable: the server must use catalog values. (IN_13, IN_14, OUT_18) |
| D8 | Merge when adding from home page and detail page? | Depends on whether the cart survives page changes (D5). **Decided at execution.** |
| D9 | Quantity edge forms? | Quantity must be a **whole number**; decimals (`1.5`) are invalid. Leading zeros (`007`), signs (`+3`) and scientific notation (`1e2`) are handled as classes in step 2. |
