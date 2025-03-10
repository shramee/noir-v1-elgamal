use crate::{field_to_point, public_key, encrypt, decrypt, add_ciphertexts, embed_message, verify_embedding};

#[test]
fn test_public_key() {
    let priv_key = 0x04d73359c9166e49aafaf9a4852eaa4dceb2c26878196b10e9048004ff5cc20c;
    let pub_key = public_key(priv_key);
    assert(0.lt(pub_key.x));
    assert(0.lt(pub_key.y));
}

#[test]
fn test_encrypt_decrypt() {
    // let priv_key = 0x03de9c86d98bf24ffaac6e38fb55c8c45f73a33bdd4b2d8c904f2c34971356c2;
    let priv_key = 0x04d73359c9166e49aafaf9a4852eaa4dceb2c26878196b10e9048004ff5cc20c;
    let pub_key = public_key(priv_key);

    let x: u32 = 0x12345678;
    let randomness = 0x030cffca80ca4344e54e436fc5a03ae8e884b8f3edcb780702599e1951e8aa62;
    let ct = encrypt(pub_key, x as Field, randomness);

    let res = decrypt(ct, priv_key);

    let embedded = field_to_point(x as Field);

    assert(res.x == embedded.x);
    assert(res.y == embedded.y);
}

#[test(should_fail)]
fn test_embedding_fail() {
    // let m = 0x03de9c86d98bf24ffaac6e38fb55c8c45f73a33bdd4b2d8c904f2c34971356c2;
    let m = 0xffffffffff + 1; // larger than 40 bits
    let _P_m = embed_message(m);
}

#[test]
fn test_embedding() {
    let m = 0xe49aafaf9a;
    let _P_m = embed_message(m);
}

#[test(should_fail)]
fn test_verify_embedding_fail() {
    // let m = 0x03de9c86d98bf24ffaac6e38fb55c8c45f73a33bdd4b2d8c904f2c34971356c2;
    let P_m = embed_message(0x2525252525);
	verify_embedding(P_m, 0x6969696969);
}

#[test]
fn test_verify_embedding() {
    let P_m = embed_message(0xe49aafaf9a);
	verify_embedding(P_m, 0xe49aafaf9a);
}

#[test]
fn test_homomorphism() {
    let priv_key = 0x04d73359c9166e49aafaf9a4852eaa4dceb2c26878196b10e9048004ff5cc20c;
    let pub_key = public_key(priv_key);

    let a: u32 = 0x12345678;
    let r = 0x030cffca80ca4344e54e436fc5a03ae8e884b8f3edcb780702599e1951e8aa62;
    let ca = encrypt(pub_key, a as Field, r);

    let b: u32 = 0x10000000;
    let r = 0x030cffca80ca4344e54e436fc5a03ae8e884b8f3edcb780702599e1951e8aa62;
    let cb = encrypt(pub_key, b as Field, r);

	let c_a_plus_b = add_ciphertexts(ca, cb);

    let res = decrypt(c_a_plus_b, priv_key);

    let embedded = field_to_point((a + b) as Field);

    assert(res.x == embedded.x);
    assert(res.y == embedded.y);
}
