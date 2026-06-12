; PROJECT   : LC-3 Array Sum & Product Calculator
; FILE      : array_stats.asm
; COURSE    : CIS 11
; AUTHOR    : NATHAN WONG
; PROFESSOR : KASEY NGUYEN

; WHAT IT DOES
;   1. Reads 5 single digits (0-9) typed at the keyboard
;   2. Stores them in an array using a pointer
;   3. Computes the SUM of all values
;   4. Computes the PRODUCT of all values, detecting 16-bit signed overflow
;   5. Converts the binary results to ASCII and prints them in the console

; TEAM WORK DISTRIBUTION (no members but this is how I envisioned the project)
;   Me      -- I/O & Main Driver : MAIN driver, prompts, keyboard input loop,
;                                   GETNUM subroutine (ASCII input conversion).
;   Me pt.2 -- Arithmetic Core   : SUMARR, MULT, PRODARR subroutines,
;                                   overflow detection, storage allocation
;  "Member" -- Output & Stack    : PRINTDEC subroutine (binary->ASCII decimal),
;                                   stack PUSH/POP, save/restore conventions

; REGISTER / CALLING CONVENTION
;   R6 = stack pointer (full-descending: decrement, then store).
;   R7 = subroutine return address (saved/restored on the stack by every
;        subroutine that calls TRAP or JSR)
;   Subroutines are callee-save: each one PUSHes the registers it modifies on
;   entry and POPs them on exit, leaving the caller's state intact

        .ORIG   x3000

; MAIN DRIVER                                          [Me]

MAIN    LD      R6, STACKBASE

        LD      R0, PTR_WEL
        PUTS

        LEA     R3, ARRAY
        LD      R4, COUNT

; Input loop: read COUNT digits into the array
INLOOP  LD      R0, PTR_PRM
        PUTS
        JSR     GETNUM
        STR     R0, R3, #0
        LD      R0, NEWLINE
        OUT
        ADD     R3, R3, #1
        ADD     R4, R4, #-1
        BRp     INLOOP

; Compute and display the SUM
        JSR     SUMARR
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        LD      R0, PTR_SUM
        PUTS
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        JSR     PRINTDEC

; Compute and display the PRODUCT (overflow checked)
        JSR     PRODARR
        ADD     R5, R5, #0
        BRp     POVF

        ADD     R6, R6, #-1
        STR     R0, R6, #0
        LD      R0, PTR_PRD
        PUTS
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        JSR     PRINTDEC
        BR      DONE

POVF    LD      R0, PTR_PRD
        PUTS
        LD      R0, PTR_OVF
        PUTS

DONE    LD      R0, NEWLINE
        OUT
        HALT


; DATA / STORAGE ALLOCATION                            [Me pt.2]
;   Placed between the main driver and the subroutines so that every
;   PC-relative LD/LEA stays inside the 9-bit offset range

COUNT     .FILL #5
NEWLINE   .FILL x000A
NEG48     .FILL #-48
ASCII0    .FILL #48
STACKBASE .FILL x6000

PTR_WEL   .FILL MSG_WEL
PTR_PRM   .FILL MSG_PRM
PTR_SUM   .FILL MSG_SUM
PTR_PRD   .FILL MSG_PRD
PTR_OVF   .FILL MSG_OVF

; Negative place-value divisors for PRINTDEC, ending in a 0 sentinel
DIVTBL    .FILL #-10000
          .FILL #-1000
          .FILL #-100
          .FILL #-10
          .FILL #0

ARRAY     .BLKW #5


; SUBROUTINE: GETNUM                                   [Me]
;   Reads one character, echoes it, converts ASCII digit -> binary value
;   OUT: R0 = numeric value (0-9)

GETNUM  ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0

        GETC
        OUT
        LD      R1, NEG48
        ADD     R0, R0, R1

        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET


; SUBROUTINE: SUMARR                                   [Me pt.2]
;   Adds every element of ARRAY using a pointer walk
;   OUT: R0 = sum

SUMARR  ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0

        AND     R0, R0, #0
        LEA     R1, ARRAY
        LD      R2, COUNT
SLOOP   LDR     R3, R1, #0
        ADD     R0, R0, R3
        ADD     R1, R1, #1
        ADD     R2, R2, #-1
        BRp     SLOOP

        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET


; SUBROUTINE: MULT                                     [Me pt.2]
;   Multiplies two non-negative integers by repeated addition.
;   IN : R1 = multiplicand (>=0), R2 = multiplier (>=0)
;   OUT: R0 = R1 * R2,  R5 = 1 if signed overflow occurred else 0

MULT    ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0

        AND     R0, R0, #0
        AND     R5, R5, #0
        ADD     R2, R2, #0
        BRz     MDONE
MLOOP   ADD     R0, R0, R1
        BRn     MOVF
        ADD     R2, R2, #-1
        BRp     MLOOP
        BR      MDONE
MOVF    AND     R5, R5, #0
        ADD     R5, R5, #1
MDONE   LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET


; SUBROUTINE: PRODARR                                  [Me pt.2]
;   Multiplies every element of ARRAY together (nested subroutine call to MULT)
;   OUT: R0 = product,  R5 = overflow flag (1 if any step overflowed)

PRODARR ADD     R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0
        ADD     R6, R6, #-1
        STR     R4, R6, #0

        AND     R0, R0, #0
        ADD     R0, R0, #1
        AND     R5, R5, #0
        LEA     R3, ARRAY
        LD      R4, COUNT
PLOOP   LDR     R1, R3, #0
        ADD     R2, R0, #0
        JSR     MULT
        ADD     R5, R5, #0
        BRp     PEND
        ADD     R3, R3, #1
        ADD     R4, R4, #-1
        BRp     PLOOP

PEND    LDR     R4, R6, #0
        ADD     R6, R6, #1
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET


; SUBROUTINE: PRINTDEC                                 ["Member"]
;   Prints a non-negative value (0..32767) as decimal digits in the console
;   Uses a divisor table + repeated subtraction, suppresses leading zeros,
;   and always prints at least one digit
;   IN: R0 = value to print

PRINTDEC ADD    R6, R6, #-1
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0
        ADD     R6, R6, #-1
        STR     R4, R6, #0
        ADD     R6, R6, #-1
        STR     R5, R6, #0

        ADD     R1, R0, #0
        AND     R4, R4, #0
        LEA     R5, DIVTBL

PD_PL   LDR     R2, R5, #0
        BRz     PD_ONES
        AND     R3, R3, #0
PD_SUB  ADD     R0, R1, R2
        BRn     PD_EMIT
        ADD     R1, R0, #0
        ADD     R3, R3, #1
        BR      PD_SUB
PD_EMIT ADD     R3, R3, #0
        BRp     PD_PR
        ADD     R4, R4, #0
        BRz     PD_NX
PD_PR   LD      R0, ASCII0
        ADD     R0, R0, R3
        OUT
        AND     R4, R4, #0
        ADD     R4, R4, #1
PD_NX   ADD     R5, R5, #1
        BR      PD_PL
PD_ONES LD      R0, ASCII0
        ADD     R0, R0, R1 
        OUT

        LDR     R5, R6, #0
        ADD     R6, R6, #1
        LDR     R4, R6, #0
        ADD     R6, R6, #1
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET

MSG_WEL .STRINGZ "\n===== LC-3 ARRAY SUM & PRODUCT CALCULATOR =====\nEnter 5 single digits (0-9):\n"
MSG_PRM .STRINGZ "  digit > "
MSG_SUM .STRINGZ "\nSum of values     = "
MSG_PRD .STRINGZ "\nProduct of values = "
MSG_OVF .STRINGZ "OVERFLOW (exceeds 16-bit signed range)"

        .END
