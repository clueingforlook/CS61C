/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	char format[3];
	unsigned int max_value;
	unsigned int cols,rows;
	// 打开文件
	Image *img = (Image *)malloc(sizeof(Image));
	 if (img == NULL) {
        printf("Memory allocation failed for Image.\n");
        return NULL;
    }
	FILE *ppm_file = fopen(filename,"r");
	if(ppm_file == NULL){
		printf("Error opening the file\n");
		free(img);
		return NULL;
	}
	// 读取格式
	fscanf(ppm_file,"%s",format);
	if(!(format[0] == 'P' && format[1] == '3')){
		printf("format Error\n");
		fclose(ppm_file);
		free(img);
		return NULL;
	}
	// 读取图像的宽度、高度和最大颜色值
	fscanf(ppm_file,"%u %u %u",&cols,&rows,&max_value);
	if(cols < 0 || rows < 0 || max_value != 255){
		printf("format error \n");
		fclose(ppm_file);
		free(img);
		return NULL;
	}
	// 设置图像的宽度和高度
	img->cols = cols;
	img->rows = rows;
	/**------------pkuflyingpig--------------*/
	int totpixels = img->rows * img->cols;
	img->image = (Color**)malloc(sizeof(Color*) * totpixels);
	for (int i = 0; i < totpixels; i++) {
		*(img->image + i) = (Color*)malloc(sizeof(Color));
		Color* pixel = *(img->image + i);
		fscanf(ppm_file, "%hhu %hhu %hhu", &pixel->R, &pixel->G, &pixel->B);
	}
	fclose(ppm_file);
	return img;
	

	/**
	// 为 image 数组分配内存（rows 行）
	img->image = (Color **)malloc(rows * sizeof(Color*));
	if(img->image == NULL){
		printf("failed to allocate rows \n");
		fclose(ppm_file);
		free(img);
		return NULL;
	}
	// 为 image 数组分配内存（cols 列）
	for(int i = 0; i < cols; i++){
		img->image[i] = (Color *)malloc(cols * sizeof(Color));
		if(img->image == NULL){
			printf("Memory allocation failed for image row %d.\n", i);
			// 释放之前的行
			for(int j = 0; j < i ; j++){
				free(img->image[j]);
			}
			fclose(ppm_file);
			free(img->image);
			free(img);
			return NULL;
		}
	}
	// 读取图像
	for(int i = 0;i < rows;i++){
		for(int j = 0;j<cols;j++){
			fscanf(ppm_file,"%hhu %hhu %hhu",&img->image[i][j].R,&img->image[i][j].G,&img->image[i][j].B);
		}
	}
	return img;
	*/
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	/**------------pkuflyingpig--------------*/
	printf("P3\n%d %d\n255\n", image->cols, image->rows);
	Color** p = image->image;
	for (int i = 0; i < image->rows; i++) {
		for (int j = 0; j < image->cols - 1; j++) {
			printf("%3hhu %3hhu %3hhu   ", (*p)->R, (*p)->G, (*p)->B);
			p++;
		}
		printf("%3hhu %3hhu %3hhu\n", (*p)->R, (*p)->G, (*p)->B);
		p++;
	}
	
	
	/**
	printf("P3\n%d %d\n255\n", image->cols, image->rows);
	for(int i = 0;i < image->rows;i++){
		for(int j = 0;j < image->cols;j++){
			printf("%3hhu %3hhu %3hhu",image->image[i][j].R,image->image[i][j].G,image->image[i][j].B);

			// Print three spaces between columns (except after the last column)
            if (j < image->cols - 1) {
                printf("   ");
            }
		}
		printf("\n");
	}*/

}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for(int i = 0;i < image->rows;i++){
		free(image->image[i]);
	}

    // 释放 image 数组的内存
    free(image->image);

    // 释放 Image 结构体本身的内存
    free(image);
}

/**
//--------PKUFlyingPig------------------
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE* imagefile = fopen(filename, "r");
	if (imagefile == NULL) {
		printf("fail to open %s.\n", filename);
		return NULL;
	}
	Image *img = (Image*) malloc(sizeof(Image));
	char format[3];
	int maxcolor;
	fscanf(imagefile, "%s", format);
	if (format[0] != 'P' || format[1] != '3') {
		printf("wrong ppm format\n");
		return NULL;
	}
	fscanf(imagefile, "%u", &img->cols);
	fscanf(imagefile, "%u", &img->rows);
	fscanf(imagefile, "%u", &maxcolor);
	if (img->cols < 0 || img->rows < 0 || maxcolor != 255) {
		printf("wrong ppm format\n");
		return NULL;
	}
	int totpixels = img->rows * img->cols;
	img->image = (Color**)malloc(sizeof(Color*) * totpixels);
	for (int i = 0; i < totpixels; i++) {
		*(img->image + i) = (Color*)malloc(sizeof(Color));
		Color* pixel = *(img->image + i);
		fscanf(imagefile, "%hhu %hhu %hhu", &pixel->R, &pixel->G, &pixel->B);
	}
	fclose(imagefile);
	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n%d %d\n255\n", image->cols, image->rows);
	Color** p = image->image;
	for (int i = 0; i < image->rows; i++) {
		for (int j = 0; j < image->cols - 1; j++) {
			printf("%3hhu %3hhu %3hhu   ", (*p)->R, (*p)->G, (*p)->B);
			p++;
		}
		printf("%3hhu %3hhu %3hhu\n", (*p)->R, (*p)->G, (*p)->B);
		p++;
	}

}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	int totpixels = image->rows * image->cols;
	for (int i = 0; i < totpixels; i++) {
		free(*(image->image + i));
	}
	free(image->image);
	free(image);
}
*/