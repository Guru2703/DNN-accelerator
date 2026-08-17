# DNN-accelerator

# Mathematical Formulation and Matrix Tiling

A Fully Connected (FC) layer in a neural network can be represented as a matrix multiplication followed by bias addition and an activation function. This representation allows the computation of a DNN layer to be mapped onto the matrix-multiplication hardware of the accelerator.

## 1. Fully Connected Neural Network

A Fully Connected Neural Network (FNN) consists of layers of neurons where every neuron in one layer is connected to every neuron in the next layer. Each connection has an associated **weight**, while each output neuron has an associated **bias**.

![Fully Connected Neural Network](images/fnn.png)

For example, the connection between input neuron $x_i$ and output neuron $y_j$ has a corresponding weight $w_{ij}$.

Therefore, the output of neuron $j$ before applying the activation function is:

$$
y_j =
x_0w_{0j}
+
x_1w_{1j}
+
\cdots
+
x_{N-1}w_{N-1,j}
+
b_j
$$

This can be written more compactly as:

$$
y_j =
\sum_{i=0}^{N-1} x_iw_{ij}+b_j
$$

where:

- $x_i$ represents the $i$-th input activation.
- $w_{ij}$ represents the weight connecting input neuron $i$ to output neuron $j$.
- $b_j$ represents the bias associated with output neuron $j$.
- $y_j$ represents the output of neuron $j$ before activation.

Thus, the computation performed by each neuron is essentially a **dot product followed by bias addition**.

---

## 2. Fully Connected Layer as Matrix Multiplication

Consider a fully connected layer with $N$ input neurons and $M$ output neurons.

The input activations can be represented as a vector:

$$
X =
\begin{bmatrix}
x_0 & x_1 & \cdots & x_{N-1}
\end{bmatrix}
$$

The weights connecting the input neurons to the output neurons can be represented as a matrix:

$$
W =
\begin{bmatrix}
w_{00} & w_{01} & \cdots & w_{0,M-1} \\
w_{10} & w_{11} & \cdots & w_{1,M-1} \\
\vdots & \vdots & \ddots & \vdots \\
w_{N-1,0} & w_{N-1,1} & \cdots & w_{N-1,M-1}
\end{bmatrix}
$$

where:

$$
W \in \mathbb{R}^{N \times M}
$$

Each column of $W$ contains all the weights connected to one output neuron.

The biases can be represented as a vector:

$$
B =
\begin{bmatrix}
b_0 & b_1 & \cdots & b_{M-1}
\end{bmatrix}
$$

The output of the fully connected layer before applying the activation function is:

$$
Y = XW + B
$$

where:

$$
X \in \mathbb{R}^{1 \times N}
$$

$$
W \in \mathbb{R}^{N \times M}
$$

and:

$$
Y \in \mathbb{R}^{1 \times M}
$$

Therefore:

$$
(1 \times N)(N \times M) = (1 \times M)
$$

For an individual output neuron $j$:

$$
y_j =
\sum_{i=0}^{N-1} x_iw_{ij}+b_j
$$

After the matrix operation, an activation function $f$ is applied element-wise:

$$
A = f(Y)
$$

Hence, the complete computation of a fully connected layer can be expressed as:

$$
A = f(XW+B)
$$

This transformation converts the computation of individual neurons into a matrix operation, which is more suitable for hardware acceleration.

---

## 3. Representing Multiple Inputs as a Matrix

When multiple input samples are processed together, the input vectors can be arranged as rows of a matrix.

For a batch containing $K$ input samples:

$$
X =
\begin{bmatrix}
x_{0,0} & x_{0,1} & \cdots & x_{0,N-1} \\
x_{1,0} & x_{1,1} & \cdots & x_{1,N-1} \\
\vdots & \vdots & \ddots & \vdots \\
x_{K-1,0} & x_{K-1,1} & \cdots & x_{K-1,N-1}
\end{bmatrix}
$$

where:

$$
X \in \mathbb{R}^{K \times N}
$$

The fully connected layer then becomes:

$$
Y = XW + B
$$

with:

$$
X_{K \times N}\times W_{N \times M}=Y_{K \times M}
$$

Therefore:

$$
(K \times N)(N \times M) = K \times M
$$

This representation allows the computation of multiple input samples to be expressed as a matrix-matrix multiplication.

---

## 4. Matrix Tiling

The accelerator operates on fixed-size matrix blocks of **16 × 16**. Therefore, larger matrices are divided into smaller 16 × 16 sub-matrices before being mapped to the accelerator.

For a matrix with dimensions $H \times W$, the number of required row and column blocks is:

$$
R =
\left\lceil
\frac{H}{16}
\right\rceil
$$

$$
C =
\left\lceil
\frac{W}{16}
\right\rceil
$$

If the original matrix dimensions are not multiples of 16, the matrix is zero-padded to the next multiple of 16.

For example, a matrix of size:

$$
20 \times 30
$$

is padded to:

$$
32 \times 32
$$

The padded matrix can then be represented as a matrix of 16 × 16 sub-matrices:

$$
A =
\begin{bmatrix}
A_{00} & A_{01} \\
A_{10} & A_{11}
\end{bmatrix}
$$

where each sub-matrix has dimensions:

$$
A_{ij} \in \mathbb{R}^{16 \times 16}
$$

The matrix is therefore represented as a **matrix of sub-matrices**, rather than as a single large matrix.

Zero-padding allows the accelerator to maintain a fixed 16 × 16 computation size even when the original matrix dimensions are not multiples of 16.

---

## 5. Matrix Multiplication Using Sub-Matrices

Consider two matrices partitioned into 16 × 16 sub-matrices:

$$
A =
\begin{bmatrix}
A_{00} & A_{01} \\
A_{10} & A_{11}
\end{bmatrix}
$$

and:

$$
B =
\begin{bmatrix}
B_{00} & B_{01} \\
B_{10} & B_{11}
\end{bmatrix}
$$

The matrix multiplication is:

$$
C = AB
$$

where the resulting matrix is:

$$
C =
\begin{bmatrix}
C_{00} & C_{01} \\
C_{10} & C_{11}
\end{bmatrix}
$$

The output sub-matrices are calculated as:

$$
C_{00}
=
A_{00}B_{00}
+
A_{01}B_{10}
$$

$$
C_{01}
=
A_{00}B_{01}
+
A_{01}B_{11}
$$

$$
C_{10}
=
A_{10}B_{00}
+
A_{11}B_{10}
$$

$$
C_{11}
=
A_{10}B_{01}
+
A_{11}B_{11}
$$

In general, the computation of an output sub-matrix is:

$$
C_{ij}
=
\sum_k A_{ik}B_{kj}
$$

Each multiplication:

$$
A_{ik}B_{kj}
$$

is therefore a **16 × 16 matrix multiplication**, and the resulting matrices are accumulated to produce the corresponding output sub-matrix.

---

## 6. Mapping the Mathematics to the Accelerator

The original large matrix multiplication:

$$
A \times B
$$

is transformed into a sequence of fixed-size 16 × 16 matrix operations:

$$
A \times B
\quad\longrightarrow\quad
A_{ik} \times B_{kj}
$$

For example, the computation of the output block $C_{00}$ becomes:

$$
C_{00}
=
A_{00}B_{00}
+
A_{01}B_{10}
+
\cdots
$$

The instruction-generation flow follows the same mathematical decomposition. For every required combination of sub-matrices, the corresponding matrix operation is generated and accumulated into the appropriate output sub-matrix.

The overall transformation can therefore be summarized as:

```text
Fully Connected Layer
        │
        ▼
      X × W
        │
        ▼
 Matrix Partitioning
        │
        ▼
   16 × 16 Blocks
        │
        ▼
  Block Matrix Multiply
        │
        ▼
 Accumulation of Blocks
        │
        ▼
      X × W + B
        │
        ▼
   Activation Function
