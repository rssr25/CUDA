#include<helper_cuda.h>
#include<stdio.h>

#define N 10

__global__ void add(int *a, int *b, int *c){

    int tid = threadIdx.x;
    if(tid < N) c[tid] = a[tid] + b[tid];
}
int main(void){

    int a[N], b[N], c[N];
    int *dev_a, *dev_b, *dev_c;


    //allocate memory
    checkCudaErrors(cudaMalloc((void**)&dev_a, N*sizeof(int)));
    checkCudaErrors(cudaMalloc((void**)&dev_b, N*sizeof(int)));
    checkCudaErrors(cudaMalloc((void**)&dev_c, N*sizeof(int)));

    //initialize data
    for(int i = 0; i < N; i++){

        a[i] = i;
        b[i] = i*10;
    }

    //get these arrays to the device
    checkCudaErrors(cudaMemcpy(dev_a, a, N*sizeof(int), cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(dev_b, b, N*sizeof(int), cudaMemcpyHostToDevice));
    
    //run the kernel
    add<<<1, N>>>(dev_a, dev_b, dev_c);

    //copy result from device to host
    checkCudaErrors(cudaMemcpy(c, dev_c, N*sizeof(int), cudaMemcpyDeviceToHost));

    //show results
    for(int i=0; i < N; i++){

        printf("%d, ", c[i]);
    }

    printf("\n");
    
    //free the memory
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    
    return 0;
}