# Group B – Software Testing HW02 (Domain Testing on EShop)

SUT: [ttbhanh/eshop-sut](https://github.com/ttbhanh/eshop-sut). Clone it **separately** to run it; its code is not in this repo.

## Feature assignment (no duplicates)
| Student ID | Pool A | Pool B | Pool C | Pool D (mobile) |
|---|---|---|---|---|
| | FR-03 | FR-07 | FR-12 | – |
| | | | | |
| | | | | |
| | | | | |

## First-time setup (each member)
1. Clone this repo.
2. Set your identity so commits are attributed to you:
   ```
   git config user.name  "Your Name"
   git config user.email "the-email-on-your-github-account"
   ```
3. Create your folder:
   ```
   bash scripts/new_member.sh <StudentID> FR-03 FR-07 FR-12
   ```
4. Commit and push it.

## Rules
- **Only edit files inside your own folder.** That keeps everyone's work separate and avoids merge conflicts.
- Always `git pull` before you start and before you `git push`.
- **One commit per testing step per feature.** Message format:
  ```
  FR-03: step 2 – domain partitions for OTP and password
  ```
- Steps are 1 spec analysis, 2 domain testing, 3 BVA, 4 execution, 5 AI gap analysis.

## Bugs
- File every bug as a GitHub Issue with **New issue → Bug report (EShop)**.
- Search existing issues first. If someone else already filed it, comment on theirs instead.
- Add labels: the feature (`FR-xx`), the technique (`domain` or `bva`), a severity (`sev:*`), and your own `by:<StudentID>` label.
- Put the screenshot in the issue **and** in your folder under `FR-xx/screenshots/`.

## Exporting your commit log for submission
```
git log --author="your-email" --date=iso --pretty=format:"%h %ad %s" -- <StudentID>/ > <StudentID>/commit_log.txt
```

## Maintainer: one-time label setup
Needs the [GitHub CLI](https://cli.github.com) and `gh auth login`:
```
bash scripts/create_labels.sh <ID1> <ID2> <ID3> <ID4>
```
