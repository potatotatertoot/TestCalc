# TestCalc LC-3 Array Sum & Product Calculator

An LC-3 assembly program that reads five single digits (0–9) from the keyboard,
stores them in an array via a pointer, and computes and prints their **sum** and
**product**. The product path detects 16-bit signed overflow

## Files

| File | Purpose |
|------|---------|
| `array_stats.asm` | The complete LC-3 source program |

## Build & Run

1. Open `array_stats.asm` in an LC-3 toolchain
2. Assemble the file
3. Load the object file and set the PC to `x3000`.
4. Run. When prompted, type **five single digits (0–9)**. No Enter
   is needed between them
5. Read the Sum and Product printed in the console

Origin: `.ORIG x3000` · Stack pointer `R6 = x6000` (full-descending) · TRAPs used:
GETC (x20), OUT (x21), PUTS (x22), HALT (x25)

## Module Breakdown

| Module | Routines | Responsibility |
|--------|----------|----------------|
| Me | MAIN, GETNUM | Driver, keyboard input loop, ASCII→value conversion |
| Me | SUMARR, MULT, PRODARR | Arithmetic, overflow detection, storage allocation |
| "Member" | PRINTDEC | Binary→ASCII output, stack PUSH/POP, save-restore |

Every subroutine is callee-save: it pushes `R7` plus any registers it uses and
restores them before `RET`. Subroutines communicate through a documented
register/stack calling convention

## Test Cases

| Test | Input | Sum | Product |
|------|-------|-----|---------|
| 1 | 1 2 3 4 5 | 15 | 120 |
| 2 | 0 0 0 0 0 | 0 | 0 |
| 3 | 9 9 9 9 9 | 45 | overflow message |
| 4 | 2 3 0 4 5 | 14 | 0 |
| 5 | 9 9 9 9 1 | 37 | 6561 |

Test 3 exercises overflow detection (9⁵ = 59049 exceeds the 32767 signed limit)
Test 4 confirms a single zero zeroes the entire product

## Notes

- Input is restricted to five single digits (0–9) and non-digit keys are not validated
- Decimal output (PRINTDEC) supports values up to 32767; larger products are reported
  as overflow rather than printed
