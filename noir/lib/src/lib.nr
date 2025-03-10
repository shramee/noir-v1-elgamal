// ElGamal Cryptosystem Implementation
//
// This library implements the elliptic curve variant of the ElGamal cryptosystem as described
// in the accompanying documentation. It provides functions for key generation, message embedding,
// encryption and decryption with the following features:
//
// - Curve-agnostic implementation: No elliptic curve parameters are hardcoded in this library
// - Works with any curve supported by the underlying proving system
// - Preserves the additive homomorphic property described in Section 2.4
// - Implements the message embedding approach from Section 2.5
//
// The implementation follows the mathematical formulation in the documentation with
// function signatures designed to be simple and composable.

use std::embedded_curve_ops::{
    embedded_curve_add, EmbeddedCurvePoint, EmbeddedCurveScalar, fixed_base_scalar_mul,
    multi_scalar_mul,
};

// #region utils

/// Field to point, x . G
pub fn field_to_point(x: Field) -> EmbeddedCurvePoint {
    fixed_base_scalar_mul(EmbeddedCurveScalar::from_field(x))
}

// #endregion utils


/// Implements key generation as in Section 2.1
/// Computes H = x . G (Equation 2.1)
pub fn public_key(priv_key: Field) -> EmbeddedCurvePoint {
    field_to_point(priv_key)
}

/// Encryption as defined in Section 2.2
/// Computes (C_1, C_2) = (r . G, r . H + P_m)`$ (Equation 2.2)
pub fn encrypt(
    pub_key: EmbeddedCurvePoint,
    message: Field,
    randomness: Field,
) -> (EmbeddedCurvePoint, EmbeddedCurvePoint) {
    // @Optimise: Use multi_scalar_mul instead of separate fixed_base_scalar_mul
    let c1 = field_to_point(randomness);
    let embedded_message = field_to_point(message);
    let c2 = embedded_curve_add(embedded_message, multi_scalar_mul([pub_key], [r]));
    (c1, c2)
}

/// Decryption as per Section 2.3
/// Computes C_2 - x . C_1 = P_m
pub fn decrypt(
    c1: EmbeddedCurvePoint,
    c2: EmbeddedCurvePoint,
    priv_key: Field,
) -> EmbeddedCurvePoint {
    let x = EmbeddedCurveScalar::from_field(priv_key);
    let diff = multi_scalar_mul([c1], [x]);
    embedded_curve_add(c2, -diff)
}


/// Message embedding function f(m) = m . G from Section 2.5
/// Fails if message is over 40 bits
pub fn embed_message(m: Field) -> EmbeddedCurvePoint {
	assert_max_bit_size<40>(m);
	field_to_point(m)
}

/// Verifies that a point is the correct embedding of a message
/// Implements the verification function from Section 2.5
pub fn verify_embedding(m: Field, embedding: EmbeddedCurvePoint) {
	assert(embedding == field_to_point(m));	
}
