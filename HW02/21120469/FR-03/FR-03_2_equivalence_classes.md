# FR-03 – Step 2: Identify equivalence classes for each input & output

Input: the variables from `FR-03_1_variables.md`. Method: lecture S04 *Domain Testing*, step 2.

## Guidelines applied (S04, slides 8–11)

| Condition kind | Rule | Example in this feature |
|---|---|---|
| **Range** | 1 valid class + 2 invalid classes (below, above) | OTP length = 6, password length ≥ 8, OTP age < T |
| **Set** | 1 valid class per element (if handled differently) + 1 invalid class | "Back to login" step, confirm field in API |
| **Must be** | 1 valid class + 1 invalid class | Email registered, OTP digits only, password has uppercase |
| **Split** | Split a class when its members may not be handled the same way | Email without TLD, OTP with leading zero, confirm differing only in case |

**Legend:** V = valid, I = invalid, TBD = expected result decided during execution. "Tester decision" = the spec is silent; the expected result was chosen by the tester (see the decision log).
Representative values are **not** chosen here; that is step 3.

## Input equivalence classes

### FR-03_IN_01 – Email (step 1)

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_01 | C1 Required (must be) | Email is not empty | V | Assumption |
| FR-03_EC_02 | C1 Required (must be) | Email is empty or whitespace only | I | Assumption |
| FR-03_EC_03 | C2 Format `user@domain.com` (must be) | Email is well-formed | V | Assumption (FR-01) |
| FR-03_EC_04 | C2 Format (split) | No `@` | I | Assumption (FR-01) |
| FR-03_EC_05 | C2 Format (split) | Empty local part (nothing before `@`) | I | Assumption (FR-01) |
| FR-03_EC_06 | C2 Format (split) | No top-level domain (`user@domain`); browser `type="email"` accepts this, spec format does not | I | Assumption (FR-01) |
| FR-03_EC_07 | C3 Registered (must be) | Registered email, typed exactly as stored | V | Spec |
| FR-03_EC_08 | C3 Registered (must be) | Well-formed but not registered | I | Spec |
| FR-03_EC_09 | C3 Registered (split) | Registered email in different letter case | I | Tester decision: case-sensitive |
| FR-03_EC_10 | C3 Registered (split) | Registered email with leading/trailing spaces | I | Tester decision: not trimmed |

### FR-03_IN_02 – "Back to login" button

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_11 | C1 Where clicked (set) | Clicked on step 1 | V | Spec |
| FR-03_EC_12 | C1 Where clicked (set) | Clicked on step 2 (assumes the button is also there) | V | Assumption |

No invalid class: a button has no out-of-set value.

### FR-03_IN_03 – OTP (step 2)

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_13 | C1 Required (must be) | OTP is not empty | V | Assumption |
| FR-03_EC_14 | C1 Required (must be) | OTP is empty | I | Assumption |
| FR-03_EC_15 | C2 Length = 6 (range) | Length = 6 | V | Spec |
| FR-03_EC_16 | C2 Length = 6 (range) | Length < 6 | I | Spec |
| FR-03_EC_17 | C2 Length = 6 (range) | Length > 6 | I | Spec |
| FR-03_EC_18 | C3 Digits only (must be) | All characters are digits 0–9 | V | Spec |
| FR-03_EC_19 | C3 Digits only (must be) | Contains a letter or symbol | I | Spec |
| FR-03_EC_20 | C3 Digits only (split) | 6 digits with leading/trailing spaces | V | Tester decision: trimmed |
| FR-03_EC_21 | C4 Matches issued OTP (must be) | Equals the OTP issued for this email | V | Spec |
| FR-03_EC_22 | C4 Matches issued OTP (must be) | 6 digits but not the issued OTP | I | Spec |
| FR-03_EC_23 | C4 Matches issued OTP (split) | Correct OTP that starts with `0` (risk: treated as a number, zero dropped) | V | Spec |

### FR-03_IN_04 – New password

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_24 | C1 Required (must be) | Not empty | V | Assumption |
| FR-03_EC_25 | C1 Required (must be) | Empty | I | Assumption |
| FR-03_EC_26 | C2 Length ≥ 8 (range) | Length ≥ 8 | V | Spec (FR-01) |
| FR-03_EC_27 | C2 Length ≥ 8 (range) | Length < 8 | I | Spec (FR-01) |
| FR-03_EC_28 | C2 Length (range, upper side) | Very long (e.g. > 128 characters); no maximum in spec | I | Tester decision: too long is rejected |
| FR-03_EC_29 | C3 Uppercase (must be) | Has ≥ 1 uppercase letter | V | Spec (FR-01) |
| FR-03_EC_30 | C3 Uppercase (must be) | No uppercase letter | I | Spec (FR-01) |
| FR-03_EC_31 | C4 Lowercase (must be) | Has ≥ 1 lowercase letter | V | Spec (FR-01) |
| FR-03_EC_32 | C4 Lowercase (must be) | No lowercase letter | I | Spec (FR-01) |
| FR-03_EC_33 | C5 Digit (must be) | Has ≥ 1 digit | V | Spec (FR-01) |
| FR-03_EC_34 | C5 Digit (must be) | No digit | I | Spec (FR-01) |
| FR-03_EC_35 | C6 Special from `@$!%*?&` (must be) | Has ≥ 1 special character from the set | V | Spec (FR-01) |
| FR-03_EC_36 | C6 Special (must be) | No special character at all | I | Spec (FR-01) |
| FR-03_EC_37 | C6 Special (split) | Special characters only from outside the set (`#`, `_`, `-`, `.`) | I | Spec (strict reading) |
| FR-03_EC_38 | C7 Other characters (split) | Contains a space or non-ASCII letters (e.g. Vietnamese diacritics) | I | Tester decision: not allowed |
| FR-03_EC_39 | C8 Differs from current (split) | Same as the current password | V | Tester decision: allowed |

The 7 allowed special characters are kept as **one** valid class: there is no reason in the spec to expect them to be handled differently.

### FR-03_IN_05 – Confirm new password

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_40 | C1 Equals new password (must be) | Identical to new password | V | Spec |
| FR-03_EC_41 | C1 (must be) | Empty | I | Assumption |
| FR-03_EC_42 | C1 (split) | Completely different | I | Spec |
| FR-03_EC_43 | C1 (split) | Differs only in letter case | I | Spec |
| FR-03_EC_44 | C1 (split) | Differs only by a trailing space | I | Spec |

### FR-03_IN_06 – OTP age

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_45 | C1 Age < T (range) | 0 ≤ age < T | V | Spec (SEC-07) + Assumption (T) |
| FR-03_EC_46 | C1 Age < T (range) | Age ≥ T (expired) | I | Spec (SEC-07) + Assumption (T) |

Only one invalid class: age cannot be negative.

### FR-03_IN_07 – OTP use count

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_47 | C1 Unused (must be) | Never used (count = 0) | V | Spec (SEC-07) |
| FR-03_EC_48 | C1 Unused (must be) | Already used in a successful reset (count ≥ 1) | I | Spec (SEC-07) |
| FR-03_EC_49 | C1 Unused (split) | Submitted before, but that reset failed validation (e.g. weak password) | I | Tester decision: failed reset consumes OTP |

### FR-03_IN_08 – Email sent with the reset request (API)

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_50 | C1 Same as requesting email (must be) | Same email that requested the OTP | V | Spec (rule) |
| FR-03_EC_51 | C1 (split) | A different, registered email | I | Spec (rule) |
| FR-03_EC_52 | C1 (split) | An unregistered email | I | Assumption |
| FR-03_EC_53 | C1 (split) | Missing or empty | I | Assumption |

### FR-03_IN_09 – Number of OTP requests for the same email

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_54 | C1 Latest OTP only (set) | Only one OTP requested; use it | V | Assumption |
| FR-03_EC_55 | C1 (set) | Several requested; use the latest | V | Assumption |
| FR-03_EC_56 | C1 (set) | Several requested; use an older one | I | Assumption |

### FR-03_IN_10 – Confirm-password field in the reset API request

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_57 | C1 Field state (set) | Present and matching | V | Assumption |
| FR-03_EC_58 | C1 (set) | Present and not matching | I | Assumption |
| FR-03_EC_59 | C1 (set) | Absent (as in API spec 1.4) | TBD | Decide after execution |

### FR-03_IN_11 – Step 1 completed before step 2

| Class ID | Condition (guideline) | Equivalence class | V / I | Source |
|---|---|---|---|---|
| FR-03_EC_60 | C1 Step order (must be) | Step 1 completed, then step 2 | V | Assumption |
| FR-03_EC_61 | C1 Step order (must be) | Step 2 submitted for an email that never requested an OTP | I | Assumption |

## Output equivalence classes

As in the lecture's SUM / Error example, each distinct output is one class. "Triggered by" links each output to the input classes expected to produce it; step 3 uses this to pick test cases.

| Class ID | Output variable | Equivalence class | Triggered by | Source |
|---|---|---|---|---|
| FR-03_EC_62 | OUT_01 Step indicator | "Bước 1 / 2" shown on step 1 | Opening the page | Spec |
| FR-03_EC_63 | OUT_01 Step indicator | "Bước 2 / 2" shown on step 2 | EC_01 + EC_03 + EC_07 | Spec |
| FR-03_EC_64 | OUT_02 Generated OTP | 6-digit OTP displayed | EC_01 + EC_03 + EC_07 | Spec |
| FR-03_EC_65 | OUT_03 Error: email not registered | Message shown | EC_08, EC_09 | Assumption |
| FR-03_EC_66 | OUT_04 Error: invalid email format | Message shown | EC_04, EC_05, EC_06, EC_10 | Assumption |
| FR-03_EC_67 | OUT_05 Error: required field | Message shown | EC_02, EC_14, EC_25, EC_41 | Assumption |
| FR-03_EC_68 | OUT_06 Error: incorrect OTP | Message shown | EC_16, EC_17, EC_19, EC_22, EC_56 | Assumption |
| FR-03_EC_69 | OUT_07 Error: OTP expired | Message shown | EC_46 | Spec (SEC-07) |
| FR-03_EC_70 | OUT_08 Error: OTP already used | Message shown | EC_48, EC_49 | Spec (SEC-07) |
| FR-03_EC_71 | OUT_09 Error: OTP not valid for this email | Message shown | EC_51, EC_52, EC_53, EC_61 | Spec |
| FR-03_EC_72 | OUT_10 Error: weak password | Message shown | EC_27, EC_28, EC_30, EC_32, EC_34, EC_36, EC_37, EC_38 | Spec (FR-01) |
| FR-03_EC_73 | OUT_11 Error: passwords don't match | Message shown | EC_42, EC_43, EC_44, EC_58, (EC_59 if the server enforces matching) | Spec |
| FR-03_EC_74 | OUT_12 Success message | Message shown | All step 2 inputs in valid classes | Assumption |
| FR-03_EC_75 | OUT_13 Redirect after success | Redirected to login | Same as EC_74 | Assumption |
| FR-03_EC_76 | OUT_14 Redirect via "Back to login" | Redirected to login | EC_11, EC_12 | Spec |
| FR-03_EC_77 | OUT_15 Account password | Changed: new password logs in, old one is rejected | Same as EC_74 | Assumption |
| FR-03_EC_78 | OUT_15 Account password | Unchanged: old password still logs in | Any invalid step 2 class | Assumption |
| FR-03_EC_79 | OUT_16 Required-field marker | `*` next to every required field label | Page shown (both steps) | Spec (FR-22) |
| FR-03_EC_80 | OUT_17 Email input type | `type="email"` | Step 1 shown | Spec (FR-22) |
| FR-03_EC_81 | OUT_18 Password inputs type | `type="password"`, input masked | Step 2 shown | Spec (FR-22) |
| FR-03_EC_82 | OUT_19 Error position | Error shown above the submit button | Any error output (EC_65–EC_73) | Spec (FR-22) |
| FR-03_EC_83 | OUT_20 Page heading | Exactly one `<h1>` | Each step shown | Spec (FR-21) |
| FR-03_EC_84 | OUT_21 Language | All text in Vietnamese | Each step shown, including messages | Spec (FR-21) |
| FR-03_EC_85 | OUT_22 Submit button colour | Blue | Each step shown | Spec (FR-21) |
| FR-03_EC_86 | OUT_23 Tab order | Top to bottom, left to right | Each step shown | Spec (FR-21) |

EC_79–EC_86 were added after review, together with OUT_16–OUT_23 in step 1.

## Summary

| | Count |
|---|---|
| Valid input classes | 26 |
| Invalid input classes | 34 |
| TBD input classes (decided at execution) | 1 |
| Output classes | 25 |
| **Total** | **86** |

## Decision log (spec silent, decided by the tester)
Bugs raised from these classes must say they rest on a tester decision, not on the spec.

| Class | Question | Decision | Expected output |
|---|---|---|---|
| EC_09 | Is the email case-insensitive? | No: different case is **invalid** | OUT_03 (not registered) |
| EC_10 | Are spaces around the email trimmed? | No: **invalid** | OUT_04 (invalid format) |
| EC_20 | Are spaces around the OTP trimmed? | Yes: **valid** | Proceeds as a correct OTP |
| EC_28 | Very long password (> 128 characters) | **Invalid**: must be rejected | OUT_10 (password rule error) |
| EC_38 | Spaces / non-ASCII letters in password | **Invalid** | OUT_10 (password rule error) |
| EC_39 | New password equal to current one | **Valid** | OUT_12 (success) |
| EC_49 | Does a failed reset consume the OTP? | Yes: the OTP is **no longer valid** | OUT_08 (already used) |
| EC_59 | Reset API request without a confirm field | **Decided during execution** (step 5) | Recorded with the result |
