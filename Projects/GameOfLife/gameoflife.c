/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"


int dx[8] = {-1, -1, -1, 0, 0, 1, 1, 1};
int dy[8] = {1, 0, -1, 1, -1, 1, 0, -1};

int ring(int n, int m) {
	return (n + m) % m;
}
//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	// 统计活细胞数量
	int alive_neighbors = 0;
	// 统计当前细胞生死状态
	int cur_status = 0;
	int next_status = 0;
	//if((image->image[row][col].R == 255)&&(image->image[row][col].G == 255)&&(image->image[row][col].B == 255)){
	if (((*(image->image + row * image->cols + col))->R == 255) &&
		((*(image->image + row * image->cols + col))->G == 255) &&
		((*(image->image + row * image->cols + col))->B == 255)){
		cur_status = 1;
	}else{
		cur_status = 0;
	}
	for(int i = 0; i < 8;i++){
		int neighbor_row = ring(row + dy[i],image->rows);
		int neighbor_col = ring(col + dx[i],image->cols);
		if (((*(image->image + neighbor_row * image->cols + neighbor_col))->R == 255) &&
			((*(image->image + neighbor_row * image->cols + neighbor_col))->G == 255) &&
			((*(image->image + neighbor_row * image->cols + neighbor_col))->B == 255)) {
			alive_neighbors++;
		}
		//if((image->image[neighbor_row][neighbor_col].R == 255)&&(image->image[neighbor_row][neighbor_col].G == 255)&&(image->image[neighbor_row][neighbor_col].B == 255)){
		//	alive_neighbors++;
		//}
	}
	Color *next_generation = (Color *)malloc(sizeof(Color));
	if((alive_neighbors == 2 || alive_neighbors == 3) && cur_status == 1){
		next_status = 1;
	}else if(cur_status == 1){
		next_status = 0;
	}else if(cur_status == 0 && alive_neighbors == 3){
		next_status = 1;
	}else{
		next_status = cur_status;
	}
	next_generation->R = next_generation->G = next_generation->B = next_status*255;
	return next_generation;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	int cols = image->cols;
	int rows = image->rows;
	/**
	Image *new_img = (Image *)malloc(sizeof(Image));
	new_img->cols = image->cols;
	new_img->rows = image->rows;*/

	/**------------pkuflyingpig--------------*/
	Image *newimg = (Image *)malloc(sizeof(Image));
	newimg->cols = image->cols;
	newimg->rows = image->rows;
	newimg->image = (Color**)malloc(sizeof(Color*) * (image->rows) * (image->cols));
	Color** p = newimg->image;
	for (int i = 0; i < newimg->rows; i++)
		for (int j = 0; j < newimg->cols; j++) {
			*p = evaluateOneCell(image, i, j, rule);
			p++;
		}
	return newimg;
	
	
	/**
	new_img->image = (Color **)malloc(rows * sizeof(Color *));  // 分配行指针
	for (int i = 0; i < rows; i++) {
    	new_img->image[i] = (Color *)malloc(cols * sizeof(Color));  // 为每一行分配内存
	}
	
	for(int i = 0;i < rows;i++){
		for(int j = 0;j < cols;j++){
			new_img->image[i][j] = *evaluateOneCell(image, i, j,rule);
		}
	}
	return new_img;
	*/
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/

int main(int argc, char **argv)
{
	//YOUR CODE HERE
	/**if(argc != 3){
		printf("invalid argument number,expecting 2 arguments\n");
		return -1;
	}*/
	// 读取图像文件

    char *filename = argv[1];
	
    Image *img = readData(filename);
	
    if (!img) {
        printf("Failed to load image.\n");
        return -1;
    }
	
	 // 解析规则
    uint32_t rule = strtol(argv[2], NULL, 16);

	
	 // 计算下一代图像
    Image *next_gen = life(img, rule);

    // 输出下一代图像
    writeData(next_gen);

    // 释放内存
    freeImage(img);
    freeImage(next_gen);

    return 0;
}


/**
 //--------PKUFlyingPig------------------
int ring(int n, int m) {
	return (n + m) % m;
}
//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	Color *nextState = (Color*)malloc(sizeof(Color));
	int aliveNeighboursR = 0, aliveNeighboursG = 0, aliveNeighboursB = 0;
	int isAliveR, isAliveG, isAliveB;
	int idxR, idxG, idxB;

	aliveNeighboursR = 0;
	isAliveR = (*(image->image + row * image->cols + col))->R == 255;
	isAliveG = (*(image->image + row * image->cols + col))->G == 255;
	isAliveB = (*(image->image + row * image->cols + col))->B == 255;

	for (int i = 0; i < 8; i++) {
		int newrow = ring(row + dx[i], image->rows);
		int newcol = ring(col + dy[i], image->cols);
		if ((*(image->image + newrow * image->cols + newcol))->R == 255) {
			aliveNeighboursR++;
		}
		if ((*(image->image + newrow * image->cols + newcol))->G == 255) {
			aliveNeighboursG++;
		}
		if ((*(image->image + newrow * image->cols + newcol))->B == 255) {
			aliveNeighboursB++;
		}
	}
	idxR = 9 * isAliveR + aliveNeighboursR;
	idxG = 9 * isAliveG + aliveNeighboursG;
	idxB = 9 * isAliveB + aliveNeighboursB;

	if (rule & (1<<idxR)) {
		nextState->R = 255;
	} else {
		nextState->R = 0;
	}

	if (rule & (1<<idxG)) {
		nextState->G = 255;
	} else {
		nextState->G = 0;
	}

	if (rule & (1<<idxB)) {
		nextState->B = 255;
	} else {
		nextState->B = 0;
	}
	
	return nextState;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	Image *newimg = (Image *)malloc(sizeof(Image));
	newimg->cols = image->cols;
	newimg->rows = image->rows;
	newimg->image = (Color**)malloc(sizeof(Color*) * (image->rows) * (image->cols));
	Color** p = newimg->image;
	for (int i = 0; i < newimg->rows; i++)
		for (int j = 0; j < newimg->cols; j++) {
			*p = evaluateOneCell(image, i, j, rule);
			p++;
		}
	return newimg;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
/**
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if (argc != 3) {
		printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\nrule is a hex number beginning with 0x; Life is 0x1808.");
		return 1;
	}
	Image *img = readData(argv[1]);
	uint32_t rule = strtol(argv[2], NULL, 16);
	Image *nextImg = life(img, rule);
	writeData(nextImg);
	freeImage(img);
	freeImage(nextImg);
	return 0;
}*/

