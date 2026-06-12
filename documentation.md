# DOCUMENTATION

**Program:** Array Sum & Product Calculator (`array_stats.asm`)

| | |
|---|---|
| **Course / Section** | CIS 11 |
| **Team / Group name** | Keys |
| **Member 1** | ME |
| **Member 2** | ME |
| **Member 3** | IMITATED |

---

## 1. Project Overview

An interactive LC-3 program that reads five single digits from the keyboard, stores
them in an array, then computes and displays the **sum** and the **product** of those
values. The product path detects 16-bit signed overflow

The goal of this report is to document the work split, map each rubric requirement to
the code, record the testing performed against the required values, and analyze the
program's limitations, performance, efficiency, and possible improvements

---

## 2. Team Work Distribution

The program was divided into three modules the first two that I did on my own. Last module completed in the mindset that the first two modules were completed by other people

| Member | Modules Owned | Rubric Items Covered |
|--------|---------------|----------------------|
| **[Me]** | MAIN driver, prompts, keyboard input loop, GETNUM (ASCII input conversion) | Addresses, console I/O, system calls, ASCII conversion (input) |
| **[Me2.0]** | SUMARR, MULT, PRODARR, overflow detection, storage allocation | Arithmetic, subroutines, branching, overflow, pointer |
| **["Member"]** | PRINTDEC (binary→ASCII), stack PUSH/POP, save/restore convention | ASCII conversion (output), stack, save-restore, console display |

---

## 3. Rubric Compliance Map

Reference to Rubric

| Rubric Requirement | Where It Is Satisfied in `array_stats.asm` |
|--------------------|--------------------------------------------|
| `.ORIG` origination address; `.FILL`, array, input & output addresses | Line `.ORIG x3000`; `.FILL` constants block; `ARRAY .BLKW #5`; GETC input / OUT output |
| Display values in console | PUTS labels + PRINTDEC prints Sum and Product |
| Appropriate labels and comments | Labeled subroutines + block / inline comments throughout |
| Arithmetic, data movement, conditional operations | ADD/AND/NOT; LD/LDR/STR/LEA; BR* conditionals |
| 2+ subroutines and subroutine calls | GETNUM, SUMARR, MULT, PRODARR, PRINTDEC via JSR/RET (PRODARR calls MULT) |
| Branching: conditional and iterative | BRp/BRn/BRz; INLOOP, SLOOP, MLOOP, PLOOP, PD_SUB loops |
| Manage overflow and storage allocation | MULT BRn overflow detect + R5 flag; `.BLKW` + stack allocation |
| Manage stack: PUSH-POP | R6 stack; PUSH/POP of Sum & Product in MAIN; saves in every subroutine |
| Save-restore operations | Callee-save: each subroutine saves R7 + used regs on entry, restores on exit |
| Pointer | R3/R1 walk ARRAY; R5 walks the DIVTBL divisor table |
| ASCII conversion operations | GETNUM: ASCII−#48 (in); PRINTDEC: digit+#48 (out) |
| System call directives | GETC x20, OUT x21, PUTS x22, HALT x25 |
| Testing with required values | Section 6 test table + screen captures |

---

## 4. How to Build and Run

1. Open `array_stats.asm` 
2. Assemble the file
3. Load the object file and set the PC to `x3000`
4. Run. When prompted, type five single digits (0–9). No Enter key is required between digits
5. Read the Sum and Product printed in the console. Capture a screenshot for each test case below

---

## 5. Sample Expected Console Output

Reference output for Test 1 (input `1 2 3 4 5`)

```
===== LC-3 ARRAY SUM & PRODUCT CALCULATOR =====
Enter 5 single digits (0-9):
  digit > 1
  digit > 2
  digit > 3
  digit > 4
  digit > 5
Sum of values     = 15
Product of values = 120
```

---

## 6. Test Plan and Results

The program was tested against the required values below, including a zero case
(product = 0), an overflow case (9×9×9×9×9 = 59049 exceeds the 16-bit signed range),
and an in-range multi-digit case. Record actual results and mark Pass/Fail, then paste
the matching screen capture under each test

| # | Input (5 digits) | Expected Sum | Expected Product | Pass / Fail |
|---|------------------|--------------|------------------|-------------|
| 1 | 1 2 3 4 5 | 15 | 120 | |
| 2 | 0 0 0 0 0 | 0 | 0 | |
| 3 | 9 9 9 9 9 | 45 | OVERFLOW message | |
| 4 | 2 3 0 4 5 | 14 | 0 | |
| 5 | 9 9 9 9 1 | 37 | 6561 | |

---

## 7. Screen Captures

ALL TESTS PASSED THE PLAN  
VIEW SCREENSHOTS BELOW 

<img width="538" height="395" alt="Screenshot (81)" src="https://github.com/user-attachments/assets/b169251d-4493-467a-b030-7e829a1b1979" /> <img width="526" height="393" alt="Screenshot (8)" src="https://github.com/user-attachments/assets/e7f0f4ce-21d4-49c5-8194-f99e2fa8ecec" />

<img width="472" height="359" alt="Screenshot (91)" src="https://github.com/user-attachments/assets/d60fdb0e-ad98-474f-8f31-166d59fe5209" />
<img width="540" height="417" alt="Screenshot (9)" src="https://github.com/user-attachments/assets/f5b5ab5d-c725-4410-9eb0-ad8515e34b41" />
<img width="584" height="460" alt="Screenshot (12)" src="https://github.com/user-attachments/assets/9d084630-ff5a-4a22-adc9-c056c31dcbcd" />



---

## 8. Analysis

### Limitations
- Input is restricted to five single digits (0–9)
- Multiplication uses repeated addition, so a large multiplier means many iterations
- Decimal output (PRINTDEC) supports values up to 32767 and larger values are reported as overflow rather than printed

### Performance
- Reading input and computing the sum are linear in the number of values and complete in a few hundred cycles

### Efficiency
- Registers are reused and only saved/restored when necessary, keeping stack traffic and memory footprint small
- Leading-zero suppression in PRINTDEC avoids printing unnecessary characters

### Future Improvements
- Add input validation and an error message for non-digit characters
- Support multi-digit input and 32-bit (double-word) results to widen the usable range

---

## 9. Conclusion

It was fun building this project. I like programs where you don't have to hit enter and it will prompt you the next section to fill out so it was cool to build one of those. Also building a meaningful program that may be useful in the future to average tests that was built with knowledge I learned throughout the course is cool
