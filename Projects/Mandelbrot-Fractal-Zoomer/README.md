# Mandelbrot Fractal Zoomer

In this project, you will be implementing the Mandelbrot function and translating the result to an image!

If you are an expert in math, you may be familiar with this magical function : M(Z, C) = Z^2 + C .  Here Z and C are both complex numbers. For an fixed complex number C, we start from Z= 0 + 0j and iterate on itself. That means after you get a value out, you stick it back in as Z and do it again, and again, etc. C always stays the same across iterations, though we are interested in how different C affect how the function behaves. If the output stays bounded (the absolute value of the complex number stays less than an arbitrary threshold, which we choose to be 2), then it’s in the Mandelbrot Set! If it isn’t, then what’s interesting to calculate is how many times does it needs to iterate until it surpasses the threshold.

This project is based on UCB CS61C project 1, you can check their [official website](https://cs61c.org/fa19/projects/proj1/) to get more guidance.

To get start, you can first create your own git repository and enter the following on your terminal :

```shell
$ git remote add starter https://github.com/61c-teach/fa19-proj1-starter
$ git pull starter master
```

Then just follow the guidance on its website and enjoy your C programming journey !!
