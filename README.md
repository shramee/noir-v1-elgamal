# Elgamal Cryptosystem for Noir v1+


## 1. Elgamal on a Multiplicative group of integers

_As described in https://en.wikipedia.org/wiki/ElGamal_encryption#The_algorithm_

For a group **`G`** of order **`q`** and generator **`g`**.

### Key generation

Choose an integer **x** `x ∈ {1,2,...,q−1}` as the private key.

Public key `h = gˣ`, agreed upon group parameter G, q, g skipped for simplicity.

#### Public key, $h=g^x$

### Encryption

Choose a random integer **r** `r ∈ {1,2,...,q−1}`.

#### $(c1,c2)=(g^r, h^r*m)$

### Decryption

Compute $c1^x$ and multiply c2 by it's inverse in group G, i.e. $c2/c1^x$.

$m*h^r/(g^r)^x = m*(g^x)^r/(g^r)^x = m$

### Homomorphic property
Multiplying the pairs of cyphertext values, $E(m1) * E(m2)$  
$= (g^{r_1}, m_1 * h^{r_1})(g^{r_2}, m_2 * h^{r_2})$  
$= (g^{r_1+r_2}, (m_1*m_2)h^{r_1+r_2})$  
$= E(m_1*m_2)$, encryption of product of two cyphertexts.

## 2. Elgamal on Elliptic curves

_As described in the paper [Elliptic Curve Cryptosystems by Neal Koblitz](https://www.ams.org/journals/mcom/1987-48-177/S0025-5718-1987-0866109-5/S0025-5718-1987-0866109-5.pdf)_

The exponentiations are replaced with scalar multiplications and multiplications and divisions are replaced with point additions/subtractions.

**When we do this something really exciting and desirable happens, the originally multiplicative homomorphism of the scheme transforms into additive homomorphism.**

---

For an elliptic curve group with generator **`G`** and scalar field (group order) **`q`**. Points are in capitals and scalar in lowercase.

We need a public known reversible function, $f:m ↦ P_m$. Function $f$ **reversibly** maps messages `m` to points $P_m$ on the curve. Most of the approaches in the **Section 3: Imbedding plaintext** of the paper don't work. We will discuss this in a later section.
