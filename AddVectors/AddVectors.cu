#include <stdlib.h>
#include <stdio.h>

__global__ void addVectors(int *a, int *b, int *c, int n) {
	int thread = threadIdx.x;

	if(thread < n)
		c[thread] = a[thread] + b[thread];
}

int main() {
	int *a = NULL;
	int *b = NULL;
	int *c = NULL;
	int *dev_a = NULL;
	int *dev_b = NULL;
	int *dev_c = NULL;
	int size = 10;


	a = (int *) malloc(sizeof(int) * size);
	b = (int *) malloc(sizeof(int) * size);
	c = (int *) malloc(sizeof(int) * size);

	for(int i = 0; i < size; i++) {
		a[i] = i;
		b[i] = i;
	}

	cudaMalloc(&dev_a, size * sizeof(int));
	cudaMalloc(&dev_b, size * sizeof(int));
	cudaMalloc(&dev_c, size * sizeof(int));

	cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_c, c, size * sizeof(int), cudaMemcpyHostToDevice);

	addVectors<<<1, 1024>>>(dev_a, dev_b, dev_c, size);

	cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);

	printf("Your result vector is: \n");
	for(int i = 0; i < size; i++)
		printf("c[%d] = %d\n", i, c[i]);


	free(a);
	free(b);
	free(c);
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	return 0;
}
