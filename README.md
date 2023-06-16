A computer vision project in which I implemented a face detector in MATLAB that was trained using the AdaBoost algorithm and rectangle filters.
Skin detection, bootstrapping, and cascade classifiers were implemented in the program for improvement in accuracy and speed. 

My group and I designed an algorithm that essentially built on itself and improved through training. Our group was able to create the
adaboost detector by first loading in the training face and nonface images as a 3D matrix for storage efficiency. 
Our group decided to use 1000 face images and 100 nonface images. We believed that this would be a good amount for both faces since we’re not using all of 
them but we’re not using too little as we need a good number of images to properly train the algorithm. Non face images were cropped into the same size
of face images for efficiency. Along with the faces themselves, the face and nonface integrals were stored in a 3D matrix as well. 
Once this training data was processed we generated 500 weak classifiers since we believed this would be an effective amount to train the images.
We then processed the responses and labels then fed it into the Adaboost function to create our initial boosted classifier. We decided to display
the best 50 results to get a good understanding of how the classifiers are acting. To create an even more effective detector, we
incorporated bootstrapping. To incorporate bootstrapping we tested each image in the training faces and
training nonfaces folder with our initial boosted classifier then reprocessed the images that were incorrect
back into our training data. We did this process multiple times to create an even stronger detector. Each
bootstrapping cycle we removed 50 faces and 10 nonfaces and put in 50 new incorrectly identified faces
and 10 new incorrectly identified nonfaces. We chose these amounts because they’re in the 5-10% range
as we don’t want to be replacing a lot of training images at once since it could negatively affect the
detector.
