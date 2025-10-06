#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <omp.h>
#include <time.h>
#include <chrono>

using namespace std;

static inline double now_seconds() {
    auto now = std::chrono::high_resolution_clock::now();
    auto duration = now.time_since_epoch();
    return std::chrono::duration<double>(duration).count();
}

int main(int argc, char** argv) {
    if (argc != 5) {
        cout << "Usage: " << argv[0] << " M N K P\n";
        return 1;
    }
    int M = atoi(argv[1]);
    int N = atoi(argv[2]);
    int K = atoi(argv[3]);
    int P = atoi(argv[4]);
    if (M <= 0 || N <= 0 || K <= 0 || P <= 0) {
        cout << "All args must be positive integers\n";
        return 1;
    }

    omp_set_num_threads(P);

    size_t sizeA = (size_t)M * N;
    size_t sizeB = (size_t)N * K;
    size_t sizeC = (size_t)M * K;

    double* A = (double*)malloc(sizeA * sizeof(double));
    double* B = (double*)malloc(sizeB * sizeof(double));
    double* C = (double*)malloc(sizeC * sizeof(double));
    if (!A || !B || !C) {
        cerr << "Allocation failed\n";
        return 1;
    }

    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            A[(size_t)i * N + j] = (double)((i + j + 1) % 100) * 1e-3 + 1.0;
        }
    }
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++) {
            B[(size_t)i * K + j] = (double)((i * 7 + j * 13) % 100) * 1e-3 + 1.0;
        }
    }
    for (size_t i = 0; i < sizeC; i++) C[i] = 0.0;


    double t0 = now_seconds();

    #pragma omp parallel for default(none) collapse(2)
    for (int i = 0; i < M; ++i) {
        for (int k = 0; k < K; ++k) {
            double sum = 0.0;
            for (int j = 0; j < N; ++j) {
                sum += A[(size_t)i * N + j] * B[(size_t)j * K + k];
            }
            C[(size_t)i * K + k] = sum;
        }
    }

    double t1 = now_seconds();
    double elapsed = t1 - t0;

    fprintf(stdout, "%.9f\n", elapsed);

    free(A); free(B); free(C);
    return 0;
}
