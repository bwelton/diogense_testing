#include <stdio.h>
#include <stdint.h>
#define ALLOC_SIZE 1024000
#define CUDA_SUCCESS cudaSuccess 
__global__  void AddOneKernel(uint64_t * a) {
	//for (int i = threadIdx.x; i < ALLOC_SIZE; i++) {
    while(1){
    a[0] = 1;
    }	
	//}
}

int main() {
  uint64_t *x, *d_x, *d_y;
  if (CUDA_SUCCESS != cudaMallocHost(&x, ALLOC_SIZE*sizeof(uint64_t)))
    fprintf(stderr, "Could not alloc memory\n");
  //x = (uint64_t*)malloc(ALLOC_SIZE*sizeof(uint64_t));
  if (CUDA_SUCCESS != cudaMalloc(&d_x, ALLOC_SIZE*sizeof(uint64_t)))
    fprintf(stderr, "ERROR\n");
  for (int i = 0; i < ALLOC_SIZE; i++) {
    x[i] = 1;
  }
  cudaStream_t stream;
  cudaStreamCreate(&stream);
  if (CUDA_SUCCESS != cudaMemcpy(d_x, x, ALLOC_SIZE*sizeof(uint64_t),cudaMemcpyHostToDevice)) 
       fprintf(stderr, "MISTAKE\n");
  AddOneKernel<<<1,1,0,stream>>>(d_x);
  //cudaMemcpy(d_y, x, ALLOC_SIZE*sizeof(uint64_t),cudaMemcpyHostToDevice);
  fprintf(stderr, "Running MempcyAsync\n");
  if (CUDA_SUCCESS != cudaMemcpyAsync(x, d_x, ALLOC_SIZE*sizeof(uint64_t),cudaMemcpyDeviceToHost, 0))
    fprintf(stderr, "MISTAKE\n");
  fprintf(stderr, "Exiting Memcpy Async\n");
  cudaDeviceSynchronize();
  fprintf(stderr, "Coming from device Synchronize\n");
}
