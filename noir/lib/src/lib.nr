
use std::embedded_curve_ops::{
    embedded_curve_add, EmbeddedCurvePoint, EmbeddedCurveScalar, fixed_base_scalar_mul,
    multi_scalar_mul,
};


pub fn public_key(priv_key: Field) -> EmbeddedCurvePoint {
    let x = EmbeddedCurveScalar::from_field(priv_key);
    fixed_base_scalar_mul(x)
}

pub fn field_to_point(x: Field) -> EmbeddedCurvePoint {
    fixed_base_scalar_mul(EmbeddedCurveScalar::from_field(x))
}

pub fn encrypt(
    pub_key: EmbeddedCurvePoint,
    message: Field,
    randomness: Field,
) -> (EmbeddedCurvePoint, EmbeddedCurvePoint) {
    // @Optimise: Use multi_scalar_mul instead of fixed_base_scalar_mul
    let r = EmbeddedCurveScalar::from_field(randomness);
    let c1 = fixed_base_scalar_mul(r);
    let embedded_message = field_to_point(message);
    let c2 = embedded_curve_add(embedded_message, multi_scalar_mul([pub_key], [r]));
    (c1, c2)
}

pub fn decrypt(
    c1: EmbeddedCurvePoint,
    c2: EmbeddedCurvePoint,
    priv_key: Field,
) -> EmbeddedCurvePoint {
    let x = EmbeddedCurveScalar::from_field(priv_key);
    let diff = multi_scalar_mul([c1], [x]);
    embedded_curve_add(c2, -diff)
}
