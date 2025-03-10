# ElGamal Cryptosystem on Elliptic Curve for Additive homomorphism

## 1. ElGamal on a Multiplicative group of integers

_As described in https://en.wikipedia.org/wiki/ElGamal_encryption#The_algorithm_

For a group **`G`** of order **`q`** and generator **`g`**.

### 1.1 Key generation

Choose an integer **x** `x ∈ {1,2,...,q−1}` as the private key.

Public key `h = gˣ`, agreed upon group parameter G, q, g skipped for simplicity.

#### Public key, $`h=g^x`$ $`~~~~`$ _(Equation 1.1)_

### 1.2 Encryption

Choose a random integer **r** `r ∈ {1,2,...,q−1}`.

#### $`(c_1,c2)=(g^r, h^r*m)`$ $`~~~~`$ _(Equation 1.2)_

### 1.3 Decryption

Compute $`c_1^x`$ and multiply $`c_2`$ by it's inverse in group G, i.e. $`c_2/c_1^x`$.

$`c_2/(c_1)^x`$  
$`=(h^r*m)/(g^r)^x`$ $`~~~~`$ ($`c_1`$ and $`c_2`$ from equation 1.2)  
$`= (g^x)^r*m/(g^r)^x`$ $`~~~~`$ ($`h`$ from equation 1.1)  
$`= m`$

### 1.4 Homomorphic property
Multiplying the pairs of cyphertext values, $`E(m_1) * E(m_2)`$  
$`= (g^{r_1}, m_1 * h^{r_1})(g^{r_2}, m_2 * h^{r_2})`$  
$`= (g^{r_1+r_2}, (m_1*m_2)h^{r_1+r_2})`$  
$`= E(m_1*m_2)`$, encryption of product of two plaintexts.

## 2. ElGamal on Elliptic curves

_As described in the paper [Elliptic Curve Cryptosystems by Neal Koblitz](https://www.ams.org/journals/mcom/1987-48-177/S0025-5718-1987-0866109-5/S0025-5718-1987-0866109-5.pdf)_

The exponentiations are replaced with scalar multiplications and multiplications and divisions are replaced with point additions/subtractions.

**When we do this something really exciting and desirable happens, the originally multiplicative homomorphism of the scheme transforms into additive homomorphism.**

---

For an elliptic curve group with generator **`G`** and scalar field (group order) **`q`**. Points are in capitals and scalar in lowercase.

We need a public known reversible function, $`f:m ↦ P_m`$. Function $`f`$ **reversibly** maps messages $`m`$ to points $`P_m`$ on the curve. Most of the approaches in the **Section 3: Imbedding plaintext** of the paper don't work. We will discuss $`f(x)`$ in a **Message embedding function** section.
### 2.1 Key generation

Choose an integer **x** `x ∈ {1,2,...,q−1}` as the private key.

#### Public key, $`H=x \cdot G`$ $`~~~~`$ _(Equation 2.1)_

### 2.2 Encryption

Choose a random integer **r** `r ∈ {1,2,...,q−1}`.

Map plaintext $`m`$ to point $`P_m = f(m)`$.

#### $`(C_1,C_2)=(r \cdot G,r \cdot H + P_m)`$ $`~~~~`$ _(Equation 2.2)_

### 2.3 Decryption

Compute $`x \cdot C_1`$ and add its negative to $`C_2`$, i.e. essentially $`C_2 - x \cdot C_1`$.

$`C_2 - x \cdot (C_1)`$  
$`=(r \cdot H + P_m) - x \cdot (r \cdot G)`$ $`~~~~`$ ($`C_1`$ and $`C_2`$ from equation 2.2)  
$`=(r \cdot (x \cdot G) + P_m) - x \cdot (r \cdot G)`$ $`~~~~`$ ($`H`$ from equation 2.1)  
$`= P_m`$

### 2.4 Homomorphic property
Adding the pairs of cyphertext points, $`E(P_{m1}) + E(P_{m2})`$  
$`= (G \cdot {r_1}, P_{m1} \cdot (r_1 \cdot H))(G \cdot {r_2}, P_{m2} \cdot (r_2 \cdot H))`$  
$`= (G \cdot {r_1+r_2}, (P_{m1} + P_{m2})\cdot ({r_1+r_2} \cdot H))`$  
$`= E(P_{m1} + P_{m2}) ~~ = ~~ E(f({m1}) + f({m2}))`$ $`~~`$ encryption of the sum of the two message points.

### 2.5 Message embedding
It's time to talk about the mapping functions $`f(m)`$ and reverse  $`f^{-1}(m)`$ such that $`f:m ↦ P_m`$ and $`f^{-1}:P_m ↦ m`$.

The ideas illustrated in Section 3 of the paper [Elliptic Curve Cryptosystems](https://www.ams.org/journals/mcom/1987-48-177/S0025-5718-1987-0866109-5/S0025-5718-1987-0866109-5.pdf) don't work for us.
We need the point $`P_m`$ to be repesentative of the original value of $`m`$ on the curve scalar field, i.e. $`P_m`$ needs to be the m-th point on the curve from the generator, $`G`$.

Luckily we've come a long way since the paper was written, and now, for $`|m| <= 40`$, consumer hardware can find the forty bit $`m`$ from $`m \cdot G`$ in a few seconds if not under a second everytime.

This can be found outside the circuit, provided as a hint and verified with a simple scalar multiplication in the circuit. So,

$`f(m)`$ in the circuit looks like,

$`f(m) = 
\begin{cases} 
m \cdot G & \text{if } \lfloor \log_2(m) \rfloor + 1 < 40 \\
\text{fail} & \text{otherwise}
\end{cases}`$


$`f^{-1}(...)`$ takes the value of $`m`$ computed outside the curve and asserts $`P_m`$ equals $`m \cdot G`$,

$`f^{-1}(m, P_m) = 
\begin{cases} 
\text{pass} & m \cdot G = P_m \\
\text{fail} & \text{otherwise}
\end{cases}`$

With these definitions for $`f(m)`$ and $`f^{-1}(P_m, m)`$ we preserve homomorphism between the original messages, i.e. the homomorphism on the points as described in section 2.4 extends to the original plaintexts.