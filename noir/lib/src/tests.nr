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

