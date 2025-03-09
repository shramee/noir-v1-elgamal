// Elgamal encryption
// ------------------
//
// Homomorphic property of ElGamal encryption:
// E(m1) * E(m2) = (g^r1, m1 * h^r1)(g^r2, m2 * h^r2)
//               = (g^(r1+r2), (m1*m2)h^(r1+r2))
//               = E(m1*m2)
//
// https://en.wikipedia.org/wiki/ElGamal_encryption
//
// Key Generation: h = g^x, where x is private, (p,g,h) is public
// Encryption: c1 = g^y, c2 = m * h^y, using random y
// Decryption: m = c2 * (c1^x)^-1 = c2 * (c1^x)^(p-2)

pub mod utils;
pub mod elgamal;
