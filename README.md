# DNN-accelerator
# Mathematical Formulation and Matrix Tiling

A fully connected (FC) layer in a neural network can be represented as a matrix multiplication followed by bias addition and an activation function. This representation allows the computation of a DNN layer to be mapped onto the matrix-multiplication hardware of the accelerator.

## 1. Fully Connected Layer as Matrix Multiplication

Consider a fully connected layer with $N$ input neurons and $M$ output neurons.

The input can be represented as a vector:

$$
X =
\begin{bmatrix}
x_0 & x_1 & \cdots & x_{N-1}
\end{bmatrix}
$$

The weights connecting the input neurons to the output neurons are represented by a matrix:

$$
W =
\begin{bmatrix}
w_{00} & w_{01} & \cdots & w_{0,M-1} \
w_{10} & w_{11} & \cdots & w_{1,M-1} \
\vdots & \vdots & \ddots & \vdots \
w_{N-1,0} & w_{N-1,1} & \cdots & w_{N-1,M-1}
\end{bmatrix}
$$

and the bias is represented as:

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

For an individual output neuron $j$:

$$
y_j = \sum_{i=0}^{N-1} x_i w_{ij} + b_j
$$

Therefore, the computation of each neuron is a dot product between the input vector and the corresponding column of the weight matrix, followed by the addition of its bias.

After the matrix operation, an activation function $f$ is applied:

$$
A = f(Y)
$$

Thus, the complete computation of a fully connected layer can be expressed as:

$$
\boxed{A = f(XW+B)}
$$

This formulation converts the computation of individual neurons into a matrix operation, which is more suitable for hardware acceleration.

---

## 2. Representing Multiple Inputs as a Matrix

When multiple input samples are processed together, the input vectors can be arranged as rows of a matrix.

For a batch containing $K$ input samples:

$$
X =
\begin{bmatrix}
x_{0,0} & x_{0,1} & \cdots & x_{0,N-1} \
x_{1,0} & x_{1,1} & \cdots & x_{1,N-1} \
\vdots & \vdots & \ddots & \vdots \
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
X_{K\times N} \times W_{N\times M}
==================================

Y_{K\times M}
$$

Therefore:

$$
\boxed{
(K\times N)(N\times M) = K\times M
}
$$

This representation allows the computation of an entire layer to be expressed as a matrix-matrix multiplication.

---

## 3. Matrix Tiling

The accelerator operates on fixed-size matrix blocks of **16 × 16**. Therefore, larger matrices are divided into smaller 16 × 16 sub-matrices before being mapped to the accelerator.

For a matrix with dimensions $H \times W$, the number of required sub-matrix blocks is:

$$
R = \left\lceil \frac{H}{16} \right\rceil
$$

$$
C = \left\lceil \frac{W}{16} \right\rceil
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

and can then be represented as:

$$
A =
\begin{bmatrix}
A_{00} & A_{01} \
A_{10} & A_{11}
\end{bmatrix}
$$

where every sub-matrix $A_{ij}$ has dimensions:

$$
A_{ij} \in \mathbb{R}^{16\times16}
$$

The zero-padding allows the accelerator to operate on a fixed 16 × 16 computation size even when the original matrix dimensions are not multiples of 16.

---

## 4. Matrix Multiplication Using Sub-Matrices

Consider two matrices partitioned into 16 × 16 sub-matrices:

$$
A =
\begin{bmatrix}
A_{00} & A_{01} \
A_{10} & A_{11}
\end{bmatrix}
$$

and

$$
B =
\begin{bmatrix}
B_{00} & B_{01} \
B_{10} & B_{11}
\end{bmatrix}
$$

The matrix multiplication:

$$
C = AB
$$

can be performed using the individual sub-matrices.

The first output block is:

$$
C_{00} = A_{00}B_{00} + A_{01}B_{10}
$$

The remaining output blocks are:

$$
C_{01} = A_{00}B_{01} + A_{01}B_{11}
$$

$$
C_{10} = A_{10}B_{00} + A_{11}B_{10}
$$

$$
C_{11} = A_{10}B_{01} + A_{11}B_{11}
$$

In general, the computation of an output sub-matrix can be expressed as:

$$
\boxed{
C_{ij} = \sum_k A_{ik}B_{kj}
}
$$

Each multiplication:

$$
A_{ik}B_{kj}
$$

is therefore a **16 × 16 matrix multiplication**, and the resulting matrices are accumulated to produce the corresponding output block.

---

## 5. Mapping the Mathematics to the Accelerator

The original large matrix multiplication:

$$
A \times B
$$

is transformed into a sequence of fixed-size 16 × 16 matrix operations:

$$
A \times B
\quad\longrightarrow\quad
{A_{ik} \times B_{kj}}
$$

For example, the computation of $C_{00}$ becomes:

$$
C_{00}
======

A_{00}B_{00}
+
A_{01}B_{10}
+
\cdots
$$

The instruction-generation flow follows this same mathematical decomposition. For every required combination of sub-matrices, the corresponding matrix operation is generated and accumulated into the appropriate output sub-matrix.

Therefore, the overall transformation is:

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
```

This mathematical formulation provides the basis for converting a fully connected DNN into a sequence of fixed-size matrix operations that can be executed by the accelerator.
