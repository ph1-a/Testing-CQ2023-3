# FR-12 – Step 2: Identify equivalence classes for each input & output

**Feature:** FR-12 – Access control  
**Method:** S04 Domain Testing, Step 2.  
**Basis:** `FR-12_1_variables_With step 2 example.md` and `domain_testing_step2_guideline(1).md`.

## Guidelines applied

| Condition kind | Rule | Application in FR-12 |
|---|---|---|
| **Set** | Make one class per value when values may be handled differently; include an out-of-set class. | Account role, token/header states, HTTP method, endpoint, and browser-storage token. |
| **Must be** | One valid class and one invalid class, splitting further when behavior may differ. | Valid JWT, `Bearer` scheme, admin role, correct credentials, role unchanged by profile update. |
| **Range / date-time** | Partition values according to the stated constraint. | Token age is recorded only; the spec does not define an expiry threshold for FR-12. |
| **Split** | Split a class if the program may handle its members differently. | Missing token versus malformed/invalid token; admin versus non-admin role; protected versus public endpoints. |

**Legend:** V = valid/allowed for the stated condition; I = invalid/disallowed; TBD = the expected result is not specified and should be recorded during execution. “Tester decision” identifies behavior chosen because the specification is silent. This document identifies classes only; it does **not** select representative values or boundary tests.

## Input equivalence classes

### FR-12_IN_01 — Account role used to log in to the admin web app

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_01 | Role set | Account role is `admin` | V | Spec |
| FR-12_EC_02 | Role set | Account role is `user` / non-admin | I for admin access | Spec |
| FR-12_EC_03 | Role split | Account has a missing, unknown, or unsupported role | I for admin access | Assumption |

### FR-12_IN_02 — Credentials at the admin web login

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_04 | Credentials must be correct | Correct email/password pair belonging to an admin account | V | Assumption (FR-02 applies) |
| FR-12_EC_05 | Credentials must be correct | Correct email/password pair belonging to a non-admin account | I for admin access | Spec + Assumption |
| FR-12_EC_06 | Credentials must be correct | Incorrect email/password pair | I | Assumption |
| FR-12_EC_07 | Required fields (split) | Email or password is missing/empty | I | Assumption |
| FR-12_EC_08 | Account lookup (split) | Well-formed credentials refer to an account that does not exist | I | Assumption |

### FR-12_IN_03 — `Authorization` header on a protected API request

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_09 | Header state | Header is present and contains an authorization value | V for further token validation | Spec |
| FR-12_EC_10 | Header state | Header is missing | I | Spec (SEC-02) |

### FR-12_IN_04 — Header scheme

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_11 | Must be `Bearer <token>` | Scheme is exactly `Bearer` followed by a token | V | Spec format + Tester decision D6 |
| FR-12_EC_12 | Scheme split | Scheme is lowercase/mixed-case `bearer` | I | Tester decision D6 |
| FR-12_EC_13 | Scheme split | Token is supplied without the `Bearer` scheme | I | Tester decision D6 |
| FR-12_EC_14 | Scheme split | A different scheme is used | I | Tester decision D6 |
| FR-12_EC_15 | Scheme split | `Bearer` is present but the token portion is empty/missing | I | Assumption |

### FR-12_IN_05 — Token integrity

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_16 | Token must be valid | Token was issued by the server and has not been modified | V | Spec |
| FR-12_EC_17 | Token must be valid | Token is malformed, random, forged, or modified | I | Spec (SEC-02) |
| FR-12_EC_18 | Token split | Token is correctly formatted but signed by an untrusted/incorrect issuer or signature | I | Assumption |

### FR-12_IN_06 — `role` claim in the token

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_19 | Role must be admin | Valid token contains `role = 'admin'` | V | Spec (SEC-03) |
| FR-12_EC_20 | Role must be admin | Valid token contains `role = 'user'` / non-admin role | I for protected admin operations | Spec (SEC-03) |
| FR-12_EC_21 | Role split | Valid token has no role claim or an unsupported role value | I for protected admin operations | Assumption |

### FR-12_IN_07 — Token age

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_22 | Token age (record only) | Token is within its accepted lifetime, if expiry is implemented | V / TBD | Tester decision D4 |
| FR-12_EC_23 | Token age (record only) | Token is expired, if expiry is implemented | TBD for FR-12; record observed behavior | Tester decision D4 |

*The FR-12 spec does not define a token-expiry threshold. Do not treat expiry behavior as a firm FR-12 requirement.*

### FR-12_IN_08 — Token owner's current account state

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_24 | Account state | Token owner still exists and remains an admin | V | Tester decision D5 |
| FR-12_EC_25 | Account state | Token owner has been deleted after token issuance | I; token must stop working | Tester decision D5 |
| FR-12_EC_26 | Account state | Token owner has been demoted from admin after token issuance | I; token must stop working | Tester decision D5 |

### FR-12_IN_09 — Protected endpoint path

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_27 | Endpoint set | Existing `/api/admin/*` endpoint | Protected; admin token required | Spec |
| FR-12_EC_28 | Endpoint set | Product write endpoint: `POST /api/products` or `PUT/DELETE /api/products/:id` | Protected; admin token required | Spec |
| FR-12_EC_29 | Endpoint set | Category write endpoint: `POST /api/categories` or `PUT/DELETE /api/categories/:id` | Protected; admin token required | Spec |
| FR-12_EC_30 | Endpoint split | Coupon write endpoint `/api/admin/coupons` | Protected; admin token required | Spec |
| FR-12_EC_31 | Endpoint split | Coupon write endpoint `/api/coupons` | Protected under tester decision | Tester decision D1 |
| FR-12_EC_32 | Endpoint split | `GET /api/coupons` | Admin-only under tester decision | Tester decision D2 |
| FR-12_EC_33 | Endpoint set | Public read endpoint: `GET /api/products` or `GET /api/products/:id` | Public; token not required | Spec |
| FR-12_EC_34 | Endpoint set | Public read endpoint: `GET /api/categories` | Public; token not required | Spec |
| FR-12_EC_35 | Endpoint split | Unknown/non-existent admin path | Protected-area behavior; non-admin may receive 403 or 404 | Tester decision D8 |
| FR-12_EC_36 | Endpoint split | Other endpoint not listed as protected or public in the FR-12 scope | Out of this feature's defined endpoint set; expected behavior TBD | Assumption |

### FR-12_IN_10 — HTTP method

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_37 | Method set | `GET` on an admin endpoint or admin-only `GET /api/coupons` | Protected; admin token required | Spec + Tester decision D2 |
| FR-12_EC_38 | Method set | `POST` on a protected data-changing endpoint | Protected; admin token required | Spec |
| FR-12_EC_39 | Method set | `PUT` on a protected data-changing endpoint | Protected; admin token required | Spec |
| FR-12_EC_40 | Method set | `DELETE` on a protected data-changing endpoint | Protected; admin token required | Spec |
| FR-12_EC_41 | Method split | `GET` on a public read endpoint | Public; token not required | Spec |
| FR-12_EC_42 | Method split | Method not defined for the selected path, or an unsupported method | Expected routing/method response TBD; must not bypass access control | Assumption |

*Method classes depend on the endpoint. For example, `GET /api/products` is public, while `POST /api/products` is protected.*

### FR-12_IN_11 — Public read endpoint (control group)

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_43 | Public endpoint set | `GET /api/products` without a token | V / allowed | Spec |
| FR-12_EC_44 | Public endpoint set | `GET /api/products/:id` without a token | V / allowed | Spec |
| FR-12_EC_45 | Public endpoint set | `GET /api/categories` without a token | V / allowed | Spec |
| FR-12_EC_46 | Scope split | A non-public or write endpoint is treated as if it were public | I; must still enforce its access rule | Spec |

### FR-12_IN_12 — Admin web page opened without logging in

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_47 | Login state | User is logged in as an admin | V | Assumption |
| FR-12_EC_48 | Login state | User is not logged in and opens/refreshes an admin URL directly | I for viewing admin content | Assumption |

### FR-12_IN_13 — Token stored in the admin web app's browser storage

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_49 | Stored token set | Valid admin token | V | Assumption |
| FR-12_EC_50 | Stored token set | Valid non-admin/user token | I for admin access | Assumption |
| FR-12_EC_51 | Stored token set | Random, malformed, or otherwise invalid text | I | Assumption |
| FR-12_EC_52 | Stored token split | No token is stored | I for admin access until authenticated | Assumption |

### FR-12_IN_14 — `role` field sent in `PUT /api/users/me`

| Class ID | Condition | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-12_EC_53 | Role field must be ignored | Request includes `role = 'admin'` while updating the user's profile | V as a request to test; role must remain unchanged | Spec (SEC-06 / FR-04) |
| FR-12_EC_54 | Role field split | Request includes another role value, such as `user` | V as a request to test; role must remain unchanged | Spec (SEC-06 / FR-04) |
| FR-12_EC_55 | Role field split | Request omits the `role` field | V; ordinary profile update must not change role | Spec (SEC-06 / FR-04) |

## Output equivalence classes

Each distinct result or error response is a separate output class. Exact message wording and some HTTP status codes are not defined in the spec, so those details are marked as assumptions or tester decisions.

| Class ID | Output variable | Equivalence class | Triggered by | Source |
|---|---|---|---|---|
| FR-12_EC_56 | FR-12_OUT_01 — Protected API with valid admin token | Protected request is authorized and completes with HTTP 2xx | Protected endpoint + valid token + admin role + account still admin | Spec |
| FR-12_EC_57 | FR-12_OUT_02 — Protected API without a valid token | Request rejected with HTTP 401 | Missing header, malformed scheme, invalid/modified token, or missing token | Spec (SEC-02) + Tester decision D3/D6 |
| FR-12_EC_58 | FR-12_OUT_03 — Protected API with valid non-admin token | Request rejected with HTTP 403; 403 or 404 is acceptable for a non-existent admin path | Valid token with `user`/non-admin role, or unsupported/missing role claim | Spec (SEC-03) + Tester decision D3/D8 |
| FR-12_EC_59 | FR-12_OUT_04 — Data after rejected request | No protected data is created, edited, or deleted | Any rejected data-changing request | Spec (implied) |
| FR-12_EC_60 | FR-12_OUT_05 — Rejected response body | No protected resource data or internal details such as stack traces/secrets are exposed | Any rejected protected request | Assumption |
| FR-12_EC_61 | FR-12_OUT_06 — Public read endpoint without token | Public read request is allowed, normally HTTP 200 when the resource/request is valid | Public `GET /api/products`, `GET /api/products/:id`, or `GET /api/categories` without token | Spec |
| FR-12_EC_62 | FR-12_OUT_07 — Admin web login with admin account | Admin dashboard is shown | Correct credentials for an admin account | Spec |
| FR-12_EC_63 | FR-12_OUT_08 — Admin web login with user account | Login is refused and no admin page is shown | Correct credentials for a non-admin account | Spec (FR-12) + Assumption (message wording) |
| FR-12_EC_64 | FR-12_OUT_09 — Admin web login with wrong credentials | Error is shown and no admin page is shown | Incorrect, missing, or unknown-account credentials | Assumption |
| FR-12_EC_65 | FR-12_OUT_10 — Admin web page without login | Redirected to admin login; no admin data is shown | Direct URL or refresh while unauthenticated | Assumption |
| FR-12_EC_66 | FR-12_OUT_11 — Admin web app with non-admin/random token in storage | No admin data is shown; protected API calls are rejected | User token, random/invalid token, or no stored token | Assumption |
| FR-12_EC_67 | FR-12_OUT_12 — Account role after profile update | Role remains unchanged after `PUT /api/users/me` includes a `role` field | Profile update request attempts to set or alter role | Spec (SEC-06 / FR-04) |

## Notes on overlapping conditions

- **Token and role are separate dimensions.** A valid token with a non-admin role belongs to a different class from an invalid token; the expected rejection is 403 versus 401 under tester decision D3.
- **Endpoint and method must be considered together.** A public `GET` does not make the corresponding `POST`, `PUT`, or `DELETE` public.
- **A rejected write must not change data.** This output is checked separately from the rejection status/body.
- **Deleted/demoted token owners:** the token is expected to stop working under tester decision D5. The exact HTTP status should be recorded; the decision log does not explicitly settle whether this is 401 or 403.
- **Token expiry:** expiry is not specified as an FR-12 requirement (D4), so record the behavior rather than classifying it as a confirmed requirement failure.
- **Role escalation:** the profile API must ignore client-supplied role changes (SEC-06 / FR-04). This is included because it can undermine FR-12 access control.

## Decision log carried forward from Step 1

| Decision | Tester choice | Impact on Step 2 |
|---|---|---|
| D1 | Test coupon writes at both `/api/coupons` and `/api/admin/coupons` | Separate endpoint classes FR-12_EC_30 and FR-12_EC_31 |
| D2 | Treat `GET /api/coupons` as admin-only | FR-12_EC_32 and FR-12_EC_37 |
| D3 | 401 for missing/bad token; 403 for valid token with wrong role | Output classes FR-12_EC_57 and FR-12_EC_58 |
| D4 | Token expiry is recorded, not an FR-12 requirement | FR-12_EC_22 and FR-12_EC_23 are TBD |
| D5 | Token must stop working after owner deletion or demotion | FR-12_EC_25 and FR-12_EC_26 |
| D6 | Accept only exact `Bearer <token>` scheme | FR-12_EC_11 to FR-12_EC_15 |
| D8 | Non-admin on a non-existent admin path may receive 403 or 404 | FR-12_EC_35 and FR-12_EC_58 |

## Summary

| Category | Count |
|---|---:|
| Input equivalence classes | 55 |
| Output equivalence classes | 12 |
| **Total equivalence classes** | **67** |

