#include<helper_cuda.h>
#include<stdio.h>
int main(void){

    cudaDeviceProp prop;

    int count;
    checkCudaErrors(cudaGetDeviceCount(&count));
    for(int i = 0; i < count ; i++){
        checkCudaErrors(cudaGetDeviceProperties(&prop, i));
        printf(prop.name);
    }
    printf("%d", count);
    return 0;

}