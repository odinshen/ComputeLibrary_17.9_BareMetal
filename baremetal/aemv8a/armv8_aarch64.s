; ------------------------------------------------------------
; ARMv8-A AArch64 - Common helper functions
;
; Copyright (c) 2012 ARM Ltd.  All rights reserved.
; ------------------------------------------------------------

  PRESERVE8

  AREA  v8_helper_funcs, CODE, READONLY

; ------------------------------------------------------------
; Caches
; ------------------------------------------------------------

  EXPORT enableCachesEL1
  ; void enableCachesEL1(void)
enableCachesEL1 PROC
  MRS     x0, SCTLR_EL1
  ORR     x0, x0, #(1 << 2)     ; Set the SCTLR_EL1.C bit
  ORR     x0, x0, #(1 << 12)    ; Set the SCTLR_EL1.I bit
  MSR     SCTLR_EL1, x0
  RET

  ENDP

; ------------------------------------------------------------

  EXPORT  disableCachesEL1
  ; void disableCachesEL1(void)
disableCachesEL1 PROC
  MRS     x0, SCTLR_EL1
  AND     w0, w0, #~(1 << 2)     ; Clears the SCTLR_EL1.C bit
  AND     w0, w0, #~(1 << 12)    ; Clears the SCTLR_EL1.I bit
  MSR     SCTLR_EL1, x0
  RET

  ENDP

; ------------------------------------------------------------

  EXPORT enableCachesEL3
  ; void enableCachesEL3(void)
enableCachesEL3 PROC
  MRS     x0, SCTLR_EL3
  ORR     x0, x0, #(1 << 2)     ; Set the SCTLR_EL3.C bit
  ORR     x0, x0, #(1 << 12)    ; Set the SCTLR_EL3.I bit
  MSR     SCTLR_EL3, x0
  RET

  ENDP

; ------------------------------------------------------------

  EXPORT  disableCachesEL3
  ; void disableCachesEL3(void)
disableCachesEL3 PROC
  MRS     x0, SCTLR_EL3
  AND     w0, w0, #~(1 << 2)     ; Clears the SCTLR_EL3.C bit
  AND     w0, w0, #~(1 << 12)    ; Clears the SCTLR_EL3.I bit
  MSR     SCTLR_EL3, x0
  RET

  ENDP

; ------------------------------------------------------------

  EXPORT invalidateCaches
  ; void invalidateCaches(void)
invalidateCaches PROC

  IC      IALLU                  ; Invalidate I cache to PoU

  DMB     ISH
  MRS     x0, CLIDR_EL1          ; x0 = CLIDR
  UBFX    w2, w0, #24, #3        ; w2 = CLIDR.LoC
  CMP     w2, #0                 ; LoC is 0?
  B.EQ    invalidateCaches_end   ; No cleaning required and enable MMU
  MOV     w1, #0                 ; w1 = level iterator

invalidateCaches_flush_level
  ADD     w3, w1, w1, lsl #1     ; w3 = w1 * 3 (right-shift for cache type)
  LSR     w3, w0, w3             ; w3 = w0 >> w3
  UBFX    w3, w3, #0, #3         ; w3 = cache type of this level
  CMP     w3, #2                 ; No cache at this level?
  B.LT    invalidateCaches_next_level

  LSL     w4, w1, #1
  MSR     CSSELR_EL1, x4         ; Select current cache level in CSSELR
  ISB                            ; ISB required to reflect new CSIDR
  MRS     x4, CSSELR_EL1         ; w4 = CSIDR

  UBFX    w3, w4, #0, #3
  ADD     w3, w3, #2             ; w3 = log2(line size)
  UBFX    w5, w4, #13, #15
  UBFX    w4, w4, #3, #10        ; w4 = Way number
  CLZ     w6, w4                 ; w6 = 32 - log2(number of ways)

invalidateCaches_flush_set
  MOV     w8, w4                 ; w8 = Way number
invalidateCaches_flush_way
  LSL     w7, w1, #1             ; Fill level field
  LSL     w9, w5, w3
  ORR     w7, w7, w9             ; Fill index field
  LSL     w9, w8, w6
  ORR     w7, w7, w9             ; Fill way field
  DC      CISW, x7               ; Invalidate by set/way to point of coherency
  SUBS    w8, w8, #1             ; Decrement way
  B.GE    invalidateCaches_flush_way
  SUBS    w5, w5, #1             ; Descrement set
  B.GE    invalidateCaches_flush_set

invalidateCaches_next_level
  ADD     w1, w1, #1             ; Next level
  CMP     w2, w1
  B.GT    invalidateCaches_flush_level

invalidateCaches_end
  RET

  ENDP

; ------------------------------------------------------------
; TLB operations
; ------------------------------------------------------------

  ; Invalidates all EL1 (stage 1) translations
  ; void invalidateTLBEL1(void);
invalidateTLBEL1 PROC
  TLBI     VMALLE1               ; All stage 1 translations used at EL1
  RET
  ENDP

  ; Invalidates all EL1 (stage 1) translations, inner-shareable
  ; void invalidateTLBEL1_IS(void);
invalidateTLBEL1_IS PROC
  TLBI     VMALLE1IS             ; All stage 1 translations used at EL1 (inner-shareable)
  RET
  ENDP

  ; Invalidates all EL3 TLB entries
  ; void invalidateTLBEL3(void);
invalidateTLBEL3 PROC
  TLBI     ALLE3
  RET
  ENDP

  ; Invalidate all EL3 TLB entries, inner-shareable
  ; void invalidateTLBEL3_IS(void);
invalidateTLBEL3_IS PROC
  TLBI     ALLE3IS
  RET
  ENDP

  ; Invalidate Entire TLB (EL3 only)
  ; void invalidateEntireTLB(void);
invalidateEntireTLB PROC
  TLBI     ALLE3
  TLBI     ALLE2
  TLBI     ALLE1
  ENDP

  ; Invalidate Entire TLB (EL3 only), inner-shareable
  ; void invalidateEntireTLB_IS(void);
invalidateEntireTLB_IS PROC
  TLBI     ALLE3IS
  TLBI     ALLE2IS
  TLBI     ALLE1IS
  ENDP

; ------------------------------------------------------------
; ID Registers
; ------------------------------------------------------------

  EXPORT getMIDR
  ; Returns the full value of the MIDR_EL0
  ; unsigned int getMIDR(void)
getMIDR PROC
  MRS     x0, MIDR_EL1
  RET

  ENDP


; ------------------------------------------------------------

  EXPORT getMPIDR
  ; Returns the full value of the MPDIR_EL0
  ; unsigned long long getMPIDR(void)
getMPIDR PROC
  MRS     x0, MPIDR_EL1
  RET

  ENDP

; ------------------------------------------------------------

  EXPORT getCPUID
  ; Returns the Aff0 field from the MPIDR_EL1
  ; unsigned int getCPUID(void)
getCPUID  PROC
  MRS     x0, MPIDR_EL1
  AND     x0, x0, #0xFF
  MOV     w0, w0       ; Caller expects a 32-bit value, not a 64-bit
  RET

  ENDP

; ------------------------------------------------------------

  EXPORT goToSleep
  ; Puts the CPU to sleep
  ; void goToSleep(void);
goToSleep PROC
  WFI
  B       goToSleep
  RET
  ENDP

; ------------------------------------------------------------

  EXPORT semihostingExit
  ; Makes a semihosting call to request halt
  ; void semihostingExit(void);
semihostingExit PROC
  ; TBD
  RET
  ENDP

; ------------------------------------------------------------
; End of code
; ------------------------------------------------------------

  END

; ------------------------------------------------------------
; End of v8_aarch64.s
; ------------------------------------------------------------
