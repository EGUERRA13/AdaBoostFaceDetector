
load weak
load cascade
load boosted
load boosted2
load boosted3

negative_histogram = read_double_image('negatives.bin');
positive_histogram = read_double_image('positives.bin');

test_face_folder = [training_directory filesep 'test_face_photos'];
test_cropped_folder = [training_directory filesep 'test_cropped_faces'];
test_nonfaces_folder = [training_directory filesep 'test_nonfaces'];
%{
correct = 0;
false_positive = 0;
false_negative = 0;
tic;
filePattern = fullfile(test_cropped_folder, '*.bmp');
bmpFiles = dir(filePattern);
disp("Running detection on cropped faces")
for number_of_files = 1:length(bmpFiles)
    baseFileName = bmpFiles(number_of_files).name;
    fullFileName = fullfile(test_cropped_folder, baseFileName);
    image = read_gray(fullFileName);
    prediction = boosted_predict(image, boosted_classifier3, weak_classifiers, 50);
    if prediction >= 0
        correct = correct+1;
    else
        false_negative = false_negative + 1;
    end
end

filePattern = fullfile(test_nonfaces_folder, '*.jpg');
jpgFiles = dir(filePattern);
disp("Running detection on non faces")
for number_of_files = 1:length(jpgFiles)
    baseFileName = jpgFiles(number_of_files).name;
    fullFileName = fullfile(test_nonfaces_folder, baseFileName);
    image = read_gray(fullFileName);
    targetSize = [100,100];
    r = centerCropWindow2d(size(image),targetSize);
    cropped = imcrop(image,r);
    image2 = cropped;
    prediction = boosted_predict(image2, boosted_classifier3, weak_classifiers, 50);
    if prediction < 0
        correct = correct+1;
    else
        false_positive = false_positive + 1;
    end
end
toc
disp("Number of correct =")
disp(correct)
disp("Number of false negatives =")
disp(false_negative)
disp("Number of false positives = ")
disp(false_positive)

accuracy = correct / 806

%}

photo1 = read_gray([test_face_folder filesep 'clintonAD2505_468x448.jpg']);
photo2 = read_gray([test_face_folder filesep 'DSC01181.jpg']);
photo3 = read_gray([test_face_folder filesep 'DSC01418.jpg']);
photo4 = read_gray([test_face_folder filesep 'DSC01418.jpg']);
photo5 = read_gray([test_face_folder filesep 'DSC03292.jpg']);
photo6 = read_gray([test_face_folder filesep 'DSC03318.jpg']);
photo7 = read_gray([test_face_folder filesep 'DSC03457.jpg']);
photo8 = read_gray([test_face_folder filesep 'DSC04545.jpg']);
photo9 = read_gray([test_face_folder filesep 'DSC04546.jpg']);
photo10 = read_gray([test_face_folder filesep 'DSC06590.jpg']);
photo11 = read_gray([test_face_folder filesep 'DSC06591.jpg']);
photo12 = read_gray([test_face_folder filesep 'IMG_3793.jpg']);
photo13 = read_gray([test_face_folder filesep 'IMG_3794.jpg']);
photo14 = read_gray([test_face_folder filesep 'IMG_3840.jpg']);
photo15 = read_gray([test_face_folder filesep 'jackie-yao-ming.jpg']);
photo16 = read_gray([test_face_folder filesep 'katie-holmes-tom-cruise.jpg']);
photo17 = read_gray([test_face_folder filesep 'mccain-palin-hairspray-horror.jpg']);
photo18 = read_gray([test_face_folder filesep 'obama8.jpg']);
photo19 = read_gray([test_face_folder filesep 'phil-jackson-and-michael-jordan.jpg']);
photo20 = read_gray([test_face_folder filesep 'the-lord-of-the-rings_poster.jpg']);

%{
[result, boxes] = boosted_detector_demo(photo1, 1, boosted_classifier3, weak_classifiers, [117, 112], 2);
figure(1); imshow(result, []);

[result, boxes] = boosted_detector_demo(photo18, .8, boosted_classifier3, weak_classifiers, [100, 100], 1);
figure(1); imshow(result, []);


[result, boxes] = boosted_detector_demo(photo20, 1, boosted_classifier3, weak_classifiers, [100, 99], 7);
figure(1); imshow(result, []);


[result, boxes] = boosted_detector_demo(photo17, .8, boosted_classifier3, weak_classifiers, [100, 100], 2);
figure(1); imshow(result, []);


[result, boxes] = boosted_detector_demo(photo9, .6, boosted_classifier3, weak_classifiers, [100, 100], 1);
figure(1); imshow(result, []);

[result, boxes] = boosted_detector_demo(photo2, .6, boosted_classifier3, weak_classifiers, [100, 100], 2);
figure(1); imshow(result, []);

[result, boxes] = boosted_detector_demo(photo3, .3, boosted_classifier3, weak_classifiers, [100, 100], 2);
figure(1); imshow(result, []);
%}

photo_test = imread([test_face_folder filesep 'IMG_3793.jpg']);
skin_detection = detect_skin(photo_test, positive_histogram,  negative_histogram);
skin_threshold = .8; 
skin_pixels = skin_detection > skin_threshold;
figure(2); imshow(skin_pixels, []);


[result, boxes] = boosted_detector_demo_skin(skin_pixels, photo12, .9, boosted_classifier3, weak_classifiers, [100, 100], 4);
figure(1); imshow(result, []);
[result, boxes] = boosted_detector_demo(photo12, .9, boosted_classifier3, weak_classifiers, [100, 100], 4);
figure(3); imshow(result, []);
%{

cascade_detect(photo4,weak_classifiers,class1,class2,class3,class4,class5)
cascade_detect(photo5,weak_classifiers,class1,class2,class3,class4,class5);


%}


