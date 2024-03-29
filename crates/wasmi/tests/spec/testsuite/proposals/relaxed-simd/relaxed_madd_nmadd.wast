;; Tests for f32x4.relaxed_madd, f32x4.relaxed_nmadd, f64x2.relaxed_madd, and f64x2.relaxed_nmadd.

(module
    (func (export "f32x4.relaxed_madd") (param v128 v128 v128) (result v128) (f32x4.relaxed_madd (local.get 0) (local.get 1) (local.get 2)))
    (func (export "f32x4.relaxed_nmadd") (param v128 v128 v128) (result v128) (f32x4.relaxed_nmadd (local.get 0) (local.get 1) (local.get 2)))
    (func (export "f64x2.relaxed_nmadd") (param v128 v128 v128) (result v128) (f64x2.relaxed_nmadd (local.get 0) (local.get 1) (local.get 2)))
    (func (export "f64x2.relaxed_madd") (param v128 v128 v128) (result v128) (f64x2.relaxed_madd (local.get 0) (local.get 1) (local.get 2)))
)


;; FLT_MAX == 0x1.fffffep+127
;; FLT_MAX * 2 - FLT_MAX ==
;;   FLT_MAX (if fma)
;;   0       (if no fma)
;; from https://www.vinc17.net/software/fma-tests.c
(assert_return (invoke "f32x4.relaxed_madd"
                       (v128.const f32x4 0x1.fffffep+127 0x1.fffffep+127 0x1.fffffep+127 0x1.fffffep+127 )
                       (v128.const f32x4 2.0 2.0 2.0 2.0)
                       (v128.const f32x4 -0x1.fffffep+127 -0x1.fffffep+127 -0x1.fffffep+127 -0x1.fffffep+127))
               (either (v128.const f32x4 0x1.fffffep+127 0x1.fffffep+127 0x1.fffffep+127 0x1.fffffep+127)
                       (v128.const f32x4 inf inf inf inf)))

;; Special values for float:
;; x            = 0x1.000004p+0 (1 + 2^-22)
;; y            = 0x1.0002p+0   (1 + 2^-15)
;; z            = -(1.0 + 0x0.0002p+0 + 0x0.000004p+0)
;;              = -0x1.000204p+0
;; x.y          = 1.0 + 0x0.0002p+0 + 0x0.000004p+0 + 0x1p-37 (round bit)
;; x.y+z        = 0 (2 roundings)
;; fma(x, y, z) = (0x1p-37) 2^-37
;; from https://accurate-algorithms.readthedocs.io/en/latest/ch09appendix.html#test-system-information
(assert_return (invoke "f32x4.relaxed_madd"
                       (v128.const f32x4 0x1.000004p+0 0x1.000004p+0 0x1.000004p+0 0x1.000004p+0)
                       (v128.const f32x4 0x1.0002p+0 0x1.0002p+0 0x1.0002p+0 0x1.0002p+0)
                       (v128.const f32x4 -0x1.000204p+0 -0x1.000204p+0 -0x1.000204p+0 -0x1.000204p+0))
               (either (v128.const f32x4 0x1p-37 0x1p-37 0x1p-37 0x1p-37)
                       (v128.const f32x4 0 0 0 0)))
(assert_return (invoke "f32x4.relaxed_nmadd"
                       (v128.const f32x4 0x1.000004p+0 0x1.000004p+0 0x1.000004p+0 0x1.000004p+0)
                       (v128.const f32x4 0x1.0002p+0 0x1.0002p+0 0x1.0002p+0 0x1.0002p+0)
                       (v128.const f32x4 0x1.000204p+0 0x1.000204p+0 0x1.000204p+0 0x1.000204p+0))
               (either (v128.const f32x4 0x1p-37 0x1p-37 0x1p-37 0x1p-37)
                       (v128.const f32x4 0 0 0 0)))

;; DBL_MAX = 0x1.fffffffffffffp+1023
;; DLB_MAX * 2 - DLB_MAX ==
;;   DLB_MAX (if fma)
;;   0       (if no fma)
;; form https://www.vinc17.net/software/fma-tests.c
;; from https://www.vinc17.net/software/fma-tests.c
(assert_return (invoke "f64x2.relaxed_madd"
                       (v128.const f64x2 0x1.fffffffffffffp+1023 0x1.fffffffffffffp+1023)
                       (v128.const f64x2 2.0 2.0)
                       (v128.const f64x2 -0x1.fffffffffffffp+1023 -0x1.fffffffffffffp+1023))
               (either (v128.const f64x2 0x1.fffffffffffffp+1023 0x1.fffffffffffffp+1023)
                       (v128.const f64x2 inf inf)))

;; Special values for double:
;; x            = 0x1.00000004p+0 (1 + 2^-30)
;; y            = 0x1.000002p+0   (1 + 2^-23)
;; z            = -(1.0 + 0x0.000002p+0 + 0x0.00000004p+0)
;;              = -0x1.00000204p+0
;; x.y          = 1.0 + 0x0.000002p+0 + 0x0.00000004p+0 + 0x1p-53 (round bit)
;; x.y+z        = 0 (2 roundings)
;; fma(x, y, z) = 0x1p-53
;; from https://accurate-algorithms.readthedocs.io/en/latest/ch09appendix.html#test-system-information
(assert_return (invoke "f64x2.relaxed_madd"
                       (v128.const f64x2 0x1.00000004p+0 0x1.00000004p+0)
                       (v128.const f64x2 0x1.000002p+0 0x1.000002p+0)
                       (v128.const f64x2 -0x1.00000204p+0 -0x1.00000204p+0))
               (either (v128.const f64x2 0x1p-53 0x1p-53)
                       (v128.const f64x2 0 0)))
(assert_return (invoke "f64x2.relaxed_nmadd"
                       (v128.const f64x2 0x1.00000004p+0 0x1.00000004p+0)
                       (v128.const f64x2 0x1.000002p+0 0x1.000002p+0)
                       (v128.const f64x2 0x1.00000204p+0 0x1.00000204p+0))
               (either (v128.const f64x2 0x1p-53 0x1p-53)
                       (v128.const f64x2 0 0)))
