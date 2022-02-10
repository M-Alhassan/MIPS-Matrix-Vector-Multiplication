# Matrix Vector Multiplication

A program that computes the multiplication of a  vector with a matrix and prints out the result.

## ⚙️ Technologies

-   MIPS Assembly Language

## ⚡ Functions

-   MVM
    -   Multiplies matrix with vector
-   read_matrix
    -   Allocates a matric of n\*n floats
    -   Asks the user to input n\*n floats and reads them into allocated matrix
    -   Returns address of matrix
-   read_vector
    -   Allocates a vector of n floats
    -   Asks the user to input n floats and reads them into allocated vector
    -   Returns address of vector
-   print_vector
    -   Displays the n elements of vector V

## 📝 C code for the program

Describing the program in C language:

### MVM function

```
float* MVM (int n, float A[n][n], float X[n]) {
    float* V = new float[n]; // allocate an array of n floats
    int i, j;
    for (i=0; i<n; i++) {
        float sum = 0;
        for (j=0; j<n; j++) { sum = sum + A[i][j] * X[j]; }
        V[i] = sum;
    }
    return V; // return a pointer to vector V
}
```

### Support functions

```
float* read_matrix (int n) {
    // allocate a matrix of n*n floats
    // ask the user to input n*n floats and read them into allocated matrix
    // return address of matrix
}
float* read_vector (int n) {
    // allocate a vector of n floats
    // ask the user to input n floats and read them into allocated vector
    // return address of vector
}
void print_vector (int n, float V[n]) {
    // Display the n elements of vector V
}

```

## ✒️ Author

| [<img src="https://github.com/M-Alhassan.png?size=115" width="115"><br><sub>@M-Alhassan</sub>](https://github.com/M-Alhassan) |
| :---------------------------------------------------------------------------------------------------------------------------: |
