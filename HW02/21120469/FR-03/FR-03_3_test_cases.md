# FR-03 – Step 3: Select test cases (best representative of each class)

Input: the classes in `FR-03_2_equivalence_classes.md`. Method: lecture S04, step 3:
- Choose **at least one** test case from each equivalence class.
- **Valid** classes: each test case covers as many valid classes as possible.
- **Invalid** classes: each test case covers **one and only one** invalid class. All its other inputs come from valid classes, so a failure points to exactly one cause.

Columns follow the course template `Test cases_Template_En.xlsx`. Actual result, status, tester and date are filled in at step 5 (execution).

## Common setup

| ID | Setup |
|---|---|
| P1 | Backend (`:3000`) and frontend-web (`:5173`) running. Database freshly seeded with `node database.js`, so `test@eshop.com` / `Test1234!` exists. |
| P2 | A second account, **user B**, registered through the Register page: `userb@eshop.com` / `UserB123!`. |
| P3 | **Step 2 ready:** open `http://localhost:5173/forgot-password`, enter `test@eshop.com`, submit. The page shows step 2 and an OTP; call it **X**. |
| API | API test cases use Postman or curl. `POST http://localhost:3000/api/forgot-password` returns the OTP in `resetToken` (API spec 1.3). `POST http://localhost:3000/api/reset-password` takes `email`, `resetToken`, `newPassword` (API spec 1.4). |
| Cleanup | After any test case that changes the password (expected or not), re-seed the database and redo P2. This keeps every test case independent of the others. |

Default valid values used whenever a test case doesn't target that field: email `test@eshop.com`, OTP = **X**, new password `NewPass1!`, confirm `NewPass1!`.

## Valid test cases

| TC ID | Test case name | Classes covered | Precondition | Test steps (with data) | Expected result |
|---|---|---|---|---|---|
| FR-03_TC_01 | Reset password with all-valid inputs (happy path) | EC_01, 03, 07, 13, 15, 18, 21, 24, 26, 29, 31, 33, 35, 40, 45, 47, 50, 54, 60; outputs EC_62, 63, 64, 74, 75, 77 | P1 | 1. Open forgot-password page; check the step indicator.<br>2. Email `test@eshop.com`, submit.<br>3. Note OTP X; check the step indicator.<br>4. OTP `X`, new password `NewPass1!`, confirm `NewPass1!`, submit within 1 minute.<br>5. Log in with `NewPass1!`.<br>6. Log out, log in with `Test1234!`. | 1. "Bước 1 / 2" shown.<br>3. 6-digit OTP shown; "Bước 2 / 2" shown.<br>4. Success message; redirected to login.<br>5. Login succeeds.<br>6. Login fails. |
| FR-03_TC_02 | "Back to login" on step 1 | EC_11; output EC_76 | P1 | 1. Open forgot-password page.<br>2. Click "Back to login". | Login page is shown. |
| FR-03_TC_03 | "Back to login" on step 2 | EC_12; output EC_76 | P3 | 1. On step 2, click "Back to login". | Login page is shown. |
| FR-03_TC_04 | Use the latest of two OTPs; new password equals current | EC_55, EC_39 | P1 | 1. Request an OTP for `test@eshop.com` (OTP X1).<br>2. Request again (OTP X2).<br>3. OTP `X2`, new password `Test1234!`, confirm `Test1234!`, submit. | Success message; login with `Test1234!` works. |
| FR-03_TC_05 | OTP typed with surrounding spaces | EC_20 | P3 | 1. OTP `" X "` (one space before and after), defaults for the rest, submit. | Success (spaces are trimmed). |
| FR-03_TC_06 | Correct OTP that starts with 0 | EC_23 | P1 | 1. Repeat step 1 until the OTP shown starts with `0` (about 1 try in 10).<br>2. Enter that OTP exactly, defaults for the rest, submit. | Success. |
| FR-03_TC_07 | Reset API with a matching confirm field | EC_57 | P1 | 1. Get OTP X via API.<br>2. `POST /api/reset-password` `{"email":"test@eshop.com","resetToken":"X","newPassword":"NewPass1!","confirmPassword":"NewPass1!"}` | HTTP 200; password changed. |

## Invalid test cases – step 1 (email)
Precondition for all: P1. Each submits only the email shown.

| TC ID | Test case name | Class covered | Test steps (with data) | Expected result |
|---|---|---|---|---|
| FR-03_TC_08 | Empty email | EC_02; output EC_67 | Email `""` (also try `"   "`), submit. | Required-field error; stays on step 1; no OTP. |
| FR-03_TC_09 | Email without `@` | EC_04; output EC_66 | Email `testeshop.com`, submit. | Invalid-format error; no OTP. |
| FR-03_TC_10 | Email with empty local part | EC_05 | Email `@eshop.com`, submit. | Invalid-format error; no OTP. |
| FR-03_TC_11 | Email without top-level domain | EC_06 | Email `test@eshop`, submit. | Invalid-format error; no OTP. |
| FR-03_TC_12 | Well-formed but unregistered email | EC_08; output EC_65 | Email `nobody@eshop.com`, submit. | "Not registered" error; no OTP. |
| FR-03_TC_13 | Registered email in different case | EC_09 | Email `Test@eshop.com`, submit. | "Not registered" error (tester decision). |
| FR-03_TC_14 | Registered email with surrounding spaces | EC_10 | Email `" test@eshop.com "`, submit. | Invalid-format error (tester decision). |

## Invalid test cases – step 2 (OTP)
Precondition for all: P3. New password and confirm are `NewPass1!` unless stated.

| TC ID | Test case name | Class covered | Test steps (with data) | Expected result |
|---|---|---|---|---|
| FR-03_TC_15 | Empty OTP | EC_14 | OTP `""`, submit. | Required-field error. |
| FR-03_TC_16 | OTP shorter than 6 | EC_16; output EC_68 | OTP = first 5 digits of X, submit. | Incorrect-OTP error. |
| FR-03_TC_17 | OTP longer than 6 | EC_17 | OTP = X followed by `1` (7 digits), submit. | Incorrect-OTP error. |
| FR-03_TC_18 | OTP containing a letter | EC_19 | OTP = X with its 3rd digit replaced by `a`, submit. | Incorrect-OTP error. |
| FR-03_TC_19 | Wrong 6-digit OTP; password unchanged | EC_22; output EC_78 | 1. OTP = X with its last digit changed (e.g. +1, 9→0), submit.<br>2. Log in with `Test1234!`. | 1. Incorrect-OTP error.<br>2. Login succeeds (password unchanged). |
| FR-03_TC_20 | Expired OTP | EC_46; output EC_69 | Wait **15 minutes** after getting X, then submit with OTP X. (T is not in the spec; 15 min is assumed to be past any reasonable expiry.) | OTP-expired error. |
| FR-03_TC_21 | Reuse an OTP after a successful reset | EC_48; output EC_70 | 1. Submit OTP X with `NewPass1!` (succeeds).<br>2. Request nothing new; open step 2 again (or use the API) with OTP X, password `Other123!`. | 2. OTP-already-used error; `Other123!` does not log in. |
| FR-03_TC_22 | Reuse an OTP after a failed reset | EC_49 | 1. Submit OTP X with password `short1!` (fails, too weak).<br>2. Submit OTP X again with `NewPass1!`. | 2. OTP-already-used error (tester decision). |
| FR-03_TC_23 | Older OTP after a newer one was requested | EC_56 | 1. Request OTP X1, then request OTP X2.<br>2. Submit OTP `X1`. | Incorrect-OTP error. |

## Invalid test cases – step 2 (new password)
Precondition for all: P3. OTP = X; confirm = the same value as the new password, so only the password rule is wrong.

| TC ID | Test case name | Class covered | New password and confirm | Expected result |
|---|---|---|---|---|
| FR-03_TC_24 | Empty password | EC_25 | `""` | Required-field error. |
| FR-03_TC_25 | Too short (7) | EC_27; output EC_72 | `Pass12!` | Weak-password error. |
| FR-03_TC_26 | Very long (129) | EC_28 | `Aa1!` + 125 × `a` | Weak-password / length error (tester decision); no crash. |
| FR-03_TC_27 | No uppercase | EC_30 | `newpass1!` | Weak-password error. |
| FR-03_TC_28 | No lowercase | EC_32 | `NEWPASS1!` | Weak-password error. |
| FR-03_TC_29 | No digit | EC_34 | `NewPass!!` | Weak-password error. |
| FR-03_TC_30 | No special character | EC_36 | `NewPass12` | Weak-password error. |
| FR-03_TC_31 | Special character only outside the set | EC_37 | `NewPass1#` | Weak-password error. |
| FR-03_TC_32 | Contains a space | EC_38 | `New Pass1!` | Weak-password error (tester decision). |

## Invalid test cases – step 2 (confirm password)
Precondition for all: P3. OTP = X; new password = `NewPass1!`.

| TC ID | Test case name | Class covered | Confirm value | Expected result |
|---|---|---|---|---|
| FR-03_TC_33 | Empty confirm | EC_41 | `""` | Required-field error. |
| FR-03_TC_34 | Completely different | EC_42; output EC_73 | `Other123!` | Passwords-don't-match error. |
| FR-03_TC_35 | Differs only in case | EC_43 | `newpass1!` | Passwords-don't-match error. |
| FR-03_TC_36 | Differs only by a trailing space | EC_44 | `"NewPass1! "` | Passwords-don't-match error. |

## Invalid test cases – reset API
Precondition for all: P1 + P2. Get OTP X for `test@eshop.com` via `POST /api/forgot-password` unless stated. Each request uses valid values except the one field named.

| TC ID | Test case name | Class covered | Request body for `POST /api/reset-password` | Expected result |
|---|---|---|---|---|
| FR-03_TC_37 | OTP of user A used for user B | EC_51; output EC_71 | Also request an OTP for user B. Then `{"email":"userb@eshop.com","resetToken":"X","newPassword":"NewPass1!"}` | Error "OTP not valid for this email"; user B's password unchanged. |
| FR-03_TC_38 | Unregistered email | EC_52 | `{"email":"nobody@eshop.com","resetToken":"X","newPassword":"NewPass1!"}` | Error; no account changed. |
| FR-03_TC_39 | Email missing | EC_53 | `{"resetToken":"X","newPassword":"NewPass1!"}` | Error; no account changed. |
| FR-03_TC_40 | Confirm field present but not matching | EC_58 | `{"email":"test@eshop.com","resetToken":"X","newPassword":"NewPass1!","confirmPassword":"Other123!"}` | Passwords-don't-match error; password unchanged. |
| FR-03_TC_41 | Confirm field absent | EC_59 (TBD) | `{"email":"test@eshop.com","resetToken":"X","newPassword":"NewPass1!"}` (exactly API spec 1.4) | **Decided at execution.** Record what happens; the spec conflict is reported either way. |
| FR-03_TC_42 | Reset for an email that never requested an OTP | EC_61 | Do **not** request an OTP for user B. `{"email":"userb@eshop.com","resetToken":"123456","newPassword":"NewPass1!"}` | Error; user B's password unchanged. |

## Coverage check

Every class from step 2 is covered by at least one test case, and each invalid test case targets exactly one invalid input class.

| Class | Test case | | Class | Test case | | Class | Test case |
|---|---|---|---|---|---|---|---|
| EC_01 | TC_01 | | EC_27 | TC_25 | | EC_53 | TC_39 |
| EC_02 | TC_08 | | EC_28 | TC_26 | | EC_54 | TC_01 |
| EC_03 | TC_01 | | EC_29 | TC_01 | | EC_55 | TC_04 |
| EC_04 | TC_09 | | EC_30 | TC_27 | | EC_56 | TC_23 |
| EC_05 | TC_10 | | EC_31 | TC_01 | | EC_57 | TC_07 |
| EC_06 | TC_11 | | EC_32 | TC_28 | | EC_58 | TC_40 |
| EC_07 | TC_01 | | EC_33 | TC_01 | | EC_59 | TC_41 |
| EC_08 | TC_12 | | EC_34 | TC_29 | | EC_60 | TC_01 |
| EC_09 | TC_13 | | EC_35 | TC_01 | | EC_61 | TC_42 |
| EC_10 | TC_14 | | EC_36 | TC_30 | | EC_62 | TC_01 |
| EC_11 | TC_02 | | EC_37 | TC_31 | | EC_63 | TC_01 |
| EC_12 | TC_03 | | EC_38 | TC_32 | | EC_64 | TC_01 |
| EC_13 | TC_01 | | EC_39 | TC_04 | | EC_65 | TC_12 |
| EC_14 | TC_15 | | EC_40 | TC_01 | | EC_66 | TC_09 |
| EC_15 | TC_01 | | EC_41 | TC_33 | | EC_67 | TC_08 |
| EC_16 | TC_16 | | EC_42 | TC_34 | | EC_68 | TC_16 |
| EC_17 | TC_17 | | EC_43 | TC_35 | | EC_69 | TC_20 |
| EC_18 | TC_01 | | EC_44 | TC_36 | | EC_70 | TC_21 |
| EC_19 | TC_18 | | EC_45 | TC_01 | | EC_71 | TC_37 |
| EC_20 | TC_05 | | EC_46 | TC_20 | | EC_72 | TC_25 |
| EC_21 | TC_01 | | EC_47 | TC_01 | | EC_73 | TC_34 |
| EC_22 | TC_19 | | EC_48 | TC_21 | | EC_74 | TC_01 |
| EC_23 | TC_06 | | EC_49 | TC_22 | | EC_75 | TC_01 |
| EC_24 | TC_01 | | EC_50 | TC_01 | | EC_76 | TC_02 |
| EC_25 | TC_24 | | EC_51 | TC_37 | | EC_77 | TC_01 |
| EC_26 | TC_01 | | EC_52 | TC_38 | | EC_78 | TC_19 |

## Summary

| | Count |
|---|---|
| Valid test cases | 7 |
| Invalid test cases | 34 |
| Test case with expected result decided at execution | 1 (TC_41) |
| **Total test cases** | **42** |
| Classes covered | 78 / 78 |

## Notes for review
1. **TC_01 carries 19 valid input classes.** That is what the lecture asks for, but if it fails, the cause is unclear. If TC_01 fails at execution, split it before reporting the bug.
2. **TC_04 combines two valid classes** (latest OTP, password equal to current). If it fails, rerun each part on its own.
3. **TC_06 depends on luck:** the OTP must happen to start with `0`. If it hasn't after 30 tries, mark it "Not executed" with that reason.
4. **TC_20 assumes T ≤ 15 minutes.** If the OTP still works after 15 minutes, that is still a finding: SEC-07 says the OTP must expire.
5. **TC_07, TC_40, TC_41 send a `confirmPassword` field** whose name is assumed: the API spec has no such field.
6. **Expected error wording** is not in the spec; "required-field error", "incorrect-OTP error" and so on mean "a message with that meaning".
