;; Tests for f32x4.min, f32x4.max, f64x2.min, and f64x2.max.

(module
    (func (export "f32x4.relaxed_min") (param v128 v128) (result v128) (f32x4.relaxed_min (local.get 0) (local.get 1)))
    (func (export "f32x4.relaxed_max") (param v128 v128) (result v128) (f32x4.relaxed_max (local.get 0) (local.get 1)))
    (func (export "f64x2.relaxed_max") (param v128 v128) (result v128) (f64x2.relaxed_max (local.get 0) (local.get 1)))
    (func (export "f64x2.relaxed_min") (param v128 v128) (result v128) (f64x2.relaxed_min (local.get 0) (local.get 1)))
)

(assert_return (invoke "f32x4.relaxed_min"
                       (v128.const f32x4 -nan nan 0 0)
                       (v128.const f32x4 0 0 -nan nan))
               (either (v128.const f32x4 nan:canonical nan:canonical nan:canonical nan:canonical)
                       (v128.const f32x4 nan:canonical nan:canonical 0 0)
                       (v128.const f32x4 0 0 nan:canonical nan:canonical)
                       (v128.const f32x4 0 0 0 0)))

(assert_return (invoke "f32x4.relaxed_min"
                       (v128.const f32x4 +0.0 -0.0 +0.0 -0.0)
                       (v128.const f32x4 -0.0 +0.0 +0.0 -0.0))
               (either (v128.const f32x4 -0.0 -0.0 +0.0 -0.0)
                       (v128.const f32x4 +0.0 -0.0 +0.0 -0.0)
                       (v128.const f32x4 -0.0 +0.0 +0.0 -0.0)
                       (v128.const f32x4 -0.0 -0.0 +0.0 -0.0)))

(assert_return (invoke "f32x4.relaxed_max"
                       (v128.const f32x4 -nan nan 0 0)
                       (v128.const f32x4 0 0 -nan nan))
               (either (v128.const f32x4 nan:canonical nan:canonical nan:canonical nan:canonical)
                       (v128.const f32x4 nan:canonical nan:canonical 0 0)
                       (v128.const f32x4 0 0 nan:canonical nan:canonical)
                       (v128.const f32x4 0 0 0 0)))

(assert_return (invoke "f32x4.relaxed_max"
                       (v128.const f32x4 +0.0 -0.0 +0.0 -0.0)
                       (v128.const f32x4 -0.0 +0.0 +0.0 -0.0))
               (either (v128.const f32x4 +0.0 +0.0 +0.0 -0.0)
                       (v128.const f32x4 +0.0 -0.0 +0.0 -0.0)
                       (v128.const f32x4 -0.0 +0.0 +0.0 -0.0)
                       (v128.const f32x4 -0.0 -0.0 +0.0 -0.0)))

(assert_return (invoke "f64x2.relaxed_min"
                       (v128.const f64x2 -nan nan)
                       (v128.const f64x2 0 0))
               (either (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 0 0)
                       (v128.const f64x2 0 0)))

(assert_return (invoke "f64x2.relaxed_min"
                       (v128.const f64x2 0 0)
                       (v128.const f64x2 -nan nan))
               (either (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 0 0)
                       (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 0 0)))

(assert_return (invoke "f64x2.relaxed_min"
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 -0.0 +0.0))
               (either (v128.const f64x2 -0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 -0.0 +0.0)
                       (v128.const f64x2 -0.0 -0.0)))

(assert_return (invoke "f64x2.relaxed_min"
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0))
               (either (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0)))

(assert_return (invoke "f64x2.relaxed_max"
                       (v128.const f64x2 -nan nan)
                       (v128.const f64x2 0 0))
               (either (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 0 0)
                       (v128.const f64x2 0 0)))

(assert_return (invoke "f64x2.relaxed_max"
                       (v128.const f64x2 0 0)
                       (v128.const f64x2 -nan nan))
               (either (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 0 0)
                       (v128.const f64x2 nan:canonical nan:canonical)
                       (v128.const f64x2 0 0)))

(assert_return (invoke "f64x2.relaxed_max"
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 -0.0 +0.0))
               (either (v128.const f64x2 +0.0 +0.0)
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 -0.0 +0.0)
                       (v128.const f64x2 -0.0 -0.0)))

(assert_return (invoke "f64x2.relaxed_max"
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0))
               (either (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0)
                       (v128.const f64x2 +0.0 -0.0)))
