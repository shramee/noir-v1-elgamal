ElGamal Cryptosystem on Elliptic Curve for Additive homomorphism
----------------------------------------------------------------

The project includes description of math behind ElGamal, its adpatation to Elliptic curve groups and an implementation in Noir.

- [ElGamal Cryptosystem on Elliptic Curve for Additive homomorphism](#elgamal-cryptosystem-on-elliptic-curve-for-additive-homomorphism)
- [1. ElGamal on a Multiplicative group of integers](#1-elgamal-on-a-multiplicative-group-of-integers)
	- [1.1 Key generation](#11-key-generation)
		- [Public key, $`h=g^x`$   _(Equation 1.1)_](#public-key-hgx--equation-11)
	- [1.2 Encryption](#12-encryption)
		- [$`(c_1,c_2)=(g^r, h^r*m)`$   _(Equation 1.2)_](#c_1c_2gr-hrm--equation-12)
	- [1.3 Decryption](#13-decryption)
	- [1.4 Homomorphic property](#14-homomorphic-property)
- [2. ElGamal on Elliptic curves](#2-elgamal-on-elliptic-curves)
	- [2.1 Key generation](#21-key-generation)
		- [Public key, $`H=x \cdot G`$   _(Equation 2.1)_](#public-key-hx-cdot-g--equation-21)
	- [2.2 Encryption](#22-encryption)
		- [$`(C_1,C_2)=(r \cdot G,r \cdot H + P_m)`$   _(Equation 2.2)_](#c_1c_2r-cdot-gr-cdot-h--p_m--equation-22)
	- [2.3 Decryption](#23-decryption)
	- [2.4 Homomorphic property](#24-homomorphic-property)
	- [2.5 Message embedding](#25-message-embedding)
- [3. Implementation and Usage](#3-implementation-and-usage)
	- [3.1 Key Generation](#31-key-generation)
	- [3.2 Message Embedding](#32-message-embedding)
	- [3.3 Encryption and Decryption](#33-encryption-and-decryption)
	- [3.4 Homomorphic Addition](#34-homomorphic-addition)
	- [3.5 Limitations and Security Considerations](#35-limitations-and-security-considerations)

## 1. ElGamal on a Multiplicative group of integers

_As described in https://en.wikipedia.org/wiki/ElGamal_encryption#The_algorithm_

For a group **`G`** of order **`q`** and generator **`g`**.

### 1.1 Key generation

Choose an integer **x** `x ∈ {1,2,...,q−1}` as the private key.

Public key `h = gˣ`, agreed upon group parameter G, q, g skipped for simplicity.

#### Public key, $`h=g^x`$ &emsp; _(Equation 1.1)_

### 1.2 Encryption

Choose a random integer **r** `r ∈ {1,2,...,q−1}`.

#### $`(c_1,c_2)=(g^r, h^r*m)`$ &emsp; _(Equation 1.2)_

### 1.3 Decryption

Compute $`c_1^x`$ and multiply $`c_2`$ by it's inverse in group G, i.e. $`c_2/c_1^x`$.

$`c_2/(c_1)^x`$  
$`=(h^r*m)/(g^r)^x`$ &emsp; ($`c_1`$ and $`c_2`$ from equation 1.2)  
$`= (g^x)^r*m/(g^r)^x`$ &emsp; ($`h`$ from equation 1.1)  
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

#### Public key, $`H=x \cdot G`$ &emsp; _(Equation 2.1)_

### 2.2 Encryption

Choose a random integer **r** `r ∈ {1,2,...,q−1}`.

Map plaintext $`m`$ to point $`P_m = f(m)`$.

#### $`(C_1,C_2)=(r \cdot G,r \cdot H + P_m)`$ &emsp; _(Equation 2.2)_

### 2.3 Decryption

Compute $`x \cdot C_1`$ and add its negative to $`C_2`$, i.e. essentially $`C_2 - x \cdot C_1`$.

$`C_2 - x \cdot (C_1)`$  
$`=(r \cdot H + P_m) - x \cdot (r \cdot G)`$ &emsp; ($`C_1`$ and $`C_2`$ from equation 2.2)  
$`=(r \cdot (x \cdot G) + P_m) - x \cdot (r \cdot G)`$ &emsp; ($`H`$ from equation 2.1)  
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

## 3. Implementation and Usage

This library implements the ElGamal cryptosystem in Noir, providing homomorphic encryption capabilities that can be used within zero-knowledge proofs.

### 3.1 Key Generation

Generate a public key from a private key:

```rs
use elgamal::{public_key};

fn main() {
    // Create a private key (a scalar field element)
    let priv_key = 0x04d73359c9166e49aafaf9a4852eaa4dceb2c26878196b10e9048004ff5cc20c;
    
    // Generate the corresponding public key (a point on the curve)
    let pub_key = public_key(priv_key);
    
    // pub_key is now a point (x, y) on the elliptic curve
}
```

### 3.2 Message Embedding

Before encrypting a message, it needs to be embedded as a point on the elliptic curve:

```rs
use elgamal::{embed_message, verify_embedding};

fn main() {
    // Message must be at most 40 bits (values larger than 0xffffffffff will fail)
    let message = 0xe49aafaf9a;
    
    // Embed the message as a point on the curve
    let point = embed_message(message);
    
    // You can verify that a point corresponds to a specific message
    verify_embedding(point, message); // Returns true if the embedding is correct
}
```

### 3.3 Encryption and Decryption

Encrypt a message using a public key:

```rs
use elgamal::{field_to_point, public_key, encrypt, decrypt};

fn main() {
    // Set up keys
    let priv_key = 0x04d73359c9166e49aafaf9a4852eaa4dceb2c26878196b10e9048004ff5cc20c;
    let pub_key = public_key(priv_key);
    
    // Message to encrypt (as a Field element)
    let message: u32 = 0x12345678;
    
    // Randomness for encryption (important for security)
    let randomness = 0x030cffca80ca4344e54e436fc5a03ae8e884b8f3edcb780702599e1951e8aa62;
    
    // Encrypt the message
    let ciphertext = encrypt(pub_key, message as Field, randomness);
    
    // Decrypt the ciphertext using the private key
    let decrypted_point = decrypt(ciphertext, priv_key);
    
    // Convert the original message to a point for comparison
    let original_point = field_to_point(message as Field);
    
    // Verify decryption was successful
    assert(decrypted_point.x == original_point.x);
    assert(decrypted_point.y == original_point.y);
}
```

### 3.4 Homomorphic Addition

One of the key features of ElGamal is homomorphic addition, allowing computations on encrypted data:

```rs
use elgamal::{public_key, encrypt, decrypt, add_ciphertexts, field_to_point};

fn main() {
    // Set up keys
    let priv_key = 0x04d73359c9166e49aafaf9a4852eaa4dceb2c26878196b10e9048004ff5cc20c;
    let pub_key = public_key(priv_key);
    
    // First message
    let a: u32 = 0x12345678;
    let r_a = 0x030cffca80ca4344e54e436fc5a03ae8e884b8f3edcb780702599e1951e8aa62;
    let ciphertext_a = encrypt(pub_key, a as Field, r_a);
    
    // Second message
    let b: u32 = 0x10000000;
    let r_b = 0x030cffca80ca4344e54e436fc5a03ae8e884b8f3edcb780702599e1951e8aa62;
    let ciphertext_b = encrypt(pub_key, b as Field, r_b);
    
    // Add the ciphertexts (this adds the underlying plaintexts)
    let sum_ciphertext = add_ciphertexts(ciphertext_a, ciphertext_b);
    
    // Decrypt the sum
    let decrypted_sum = decrypt(sum_ciphertext, priv_key);
    
    // The expected sum as a point
    let expected_sum_point = field_to_point((a + b) as Field);
    
    // Verify the homomorphic addition worked correctly
    assert(decrypted_sum.x == expected_sum_point.x);
    assert(decrypted_sum.y == expected_sum_point.y);
}
```

### 3.5 Limitations and Security Considerations

- Messages must be at most 40 bits in size (values greater than `0xffffffffff` will fail)
- Proper randomness should be used for encryption in production settings
- The library assumes working with the default Noir elliptic curve
- Always use fresh randomness for each encryption
- Keep private keys secure and do not expose them in circuit outputs
- Be mindful of potential attacks specific to homomorphic encryption systems
