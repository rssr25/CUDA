#include<stdio.h>
#include<helper_cuda.h>

#define N 10

__global__ void add(int *a, int *b, int *c){

    int tid = blockIdx.x;
    if(tid < N){
        c[tid] = a[tid] + b[tid];
    }
    
}

int main(void){

//define variables
int a[N], b[N], c[N];
int *dev_a, *dev_b, *dev_c;

//allocate memory to the arrays that go to the device
checkCudaErrors(cudaMalloc( (void**)&dev_a, N* sizeof(int) ));
checkCudaErrors(cudaMalloc( (void**)&dev_b, N* sizeof(int) ));
checkCudaErrors(cudaMalloc( (void**)&dev_c, N* sizeof(int) ));

//filling the arrays a and b with data on the host
for(int i = 0; i < N; i++){
    a[i] = i;
    b[i] = i * 10;
}

//copy this data to the device
checkCudaErrors(cudaMemcpy(dev_a, a, N*sizeof(int), cudaMemcpyHostToDevice));
checkCudaErrors(cudaMemcpy(dev_b, b, N*sizeof(int), cudaMemcpyHostToDevice));

//run the kernel
add<<<N, 1>>>(dev_a, dev_b, dev_c);

//get the data from the device
checkCudaErrors(cudaMemcpy(c, dev_c, N*sizeof(int), cudaMemcpyDeviceToHost));

//display the data
for(int j = 0; j < N; j++){
    printf("%d\t", c[j]);
}
printf("\n");

//free the memory
cudaFree(dev_c);
cudaFree(dev_b);
cudaFree(dev_a);

return 0;
}