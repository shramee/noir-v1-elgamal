# Elgamal Cryptosystem for Noir v1+


## 1. Elgamal on a Multiplicative group of integers

_As described in https://en.wikipedia.org/wiki/ElGamal_encryption#The_algorithm_

For a group **`G`** of order **`q`** and generator **`g`**.

### Key generation

Choose an integer **x** `x ∈ {1,2,...,q−1}` as the private key.

Public key `h = gˣ`, agreed upon group parameter G, q, g skipped for simplicity.

#### Public key, $h=g^x$ $~~~~$ _(Equation 1.1)_

### Encryption

Choose a random integer **r** `r ∈ {1,2,...,q−1}`.

#### $(c_1,c2)=(g^r, h^r*m)$ $~~~~$ _(Equation 1.2)_

### Decryption

Compute $c_1^x$ and multiply $c_2$ by it's inverse in group G, i.e. $c_2/c_1^x$.

$c_2/(c_1)^x$  
$=(h^r*m)/(g^r)^x$ $~~~~$ ($c_1$ and $c_2$ from equation 1.2)  
$= (g^x)^r*m/(g^r)^x$ $~~~~$ ($h$ from equation 1.1)  
$= m$

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

### Key generation

Choose an integer **x** `x ∈ {1,2,...,q−1}` as the private key.

#### Public key, $H=x \cdot G$ $~~~~$ _(Equation 2.1)_

### Encryption

Choose a random integer **r** `r ∈ {1,2,...,q−1}`.

Map plaintext `m` to point $P_m = f(m)$.

#### $(C_1,C_2)=(r \cdot G,r \cdot H + P_m)$ $~~~~$ _(Equation 2.2)_

### Decryption

Compute $x \cdot C_1$ and add its negative to $C_2$, i.e. essentially $C_2 - x \cdot C_1$.

$C_2 - x \cdot (C_1)$  
$=(r \cdot H + P_m) - x \cdot (r \cdot G)$ $~~~~$ ($C_1$ and $C_2$ from equation 2.2)  
$=(r \cdot (x \cdot G) + P_m) - x \cdot (r \cdot G)$ $~~~~$ ($H$ from equation 2.1)  
$= P_m$
