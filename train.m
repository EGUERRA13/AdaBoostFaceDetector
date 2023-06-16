
%creating face and nonface folder paths
face_folder = [training_directory filesep 'training_faces'];
nonface_folder = [training_directory filesep 'training_nonfaces'];

%loading all faces into a matrix
if ~isfolder(face_folder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', face_folder);
    uiwait(warndlg(errorMessage));
    return;
end
filePattern = fullfile(face_folder, '*.bmp');
bmpFiles = dir(filePattern);
%faces = zeros(100,100,length(bmpFiles));
%face_integrals = zeros(100,100,length(bmpFiles));
faces = zeros(100,100,2000);
face_integrals = zeros(100,100,2000);
%for number_of_files = 1:length(bmpFiles)
for number_of_files = 1:2000
    baseFileName = bmpFiles(number_of_files).name;
    fullFileName = fullfile(face_folder, baseFileName);
    afile = imread(fullFileName);
    [face_vertical, face_horizontal] = size(afile);
    fprintf(1, 'Now reading %s\n', fullFileName);
    image = im2double(afile);
    face_integral = integral_image(image);
    for column = 1 : face_horizontal
        for row = 1 : face_vertical
            faces(row,column,number_of_files) = image(row, column);
            face_integrals(row,column,number_of_files) = face_integral(row,column);
        end
    end
end



%loading all nonfaces into a matrix
if ~isfolder(nonface_folder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', nonface_folder);
    uiwait(warndlg(errorMessage));
    return;
end
filePattern2 = fullfile(nonface_folder, '*.jpg');
jpgFiles = dir(filePattern2);
%nonfaces = zeros(100,100,length(bmpFiles));
%nonface_integrals = zeros(100,100,length(bmpFiles));
nonfaces = zeros(100,100,100);
nonface_integrals = zeros(100,100,100);
%for number_of_files = 1:length(bmpFiles)
for number_of_files = 1:100
    baseFileName2 = jpgFiles(number_of_files).name;
    fullFileName2 = fullfile(nonface_folder, baseFileName2);
    bfile = read_gray(fullFileName2);
    targetSize = [100,100];
    r = centerCropWindow2d(size(bfile),targetSize);
    cropped = imcrop(bfile,r);
    fprintf(1, 'Now reading %s\n', fullFileName2);
    image2 = cropped;
    nonface_vertical = size(image2,1);
    nonface_horizontal = size(image2,2);
    face_integral = integral_image(image2);
    for column = 1 : nonface_horizontal
        for row = 1 : nonface_vertical
            nonfaces(row,column,number_of_files) = image2(row, column);
            nonface_integrals(row,column,number_of_files) = face_integral(row, column);
        end
    end    
end



face_size = [100, 100];

number = 1000;
weak_classifiers = cell(1, number);
for i = 1:number
    weak_classifiers{i} = generate_classifier(face_vertical, face_horizontal);
end
save weak weak_classifiers

example_number = size(faces, 3) + size(nonfaces, 3);
labels = zeros(example_number, 1);
labels (1:size(faces, 3)) = 1;
labels((size(faces, 3)+1):example_number) = -1;
examples = zeros(face_vertical, face_horizontal, example_number);
examples (:, :, 1:size(faces, 3)) = face_integrals;
examples(:, :, (size(faces, 3)+1):example_number) = nonface_integrals;

classifier_number = numel(weak_classifiers);

responses =  zeros(classifier_number, example_number);

for example = 1:example_number
    integral = examples(:, :, example);
    for feature = 1:classifier_number
        classifier = weak_classifiers {feature};
        responses(feature, example) = eval_weak_classifier(classifier, integral);
    end

end

boosted_classifier = AdaBoost(responses, labels, 50);
save boosted boosted_classifier


%bootstrapping process
filePattern = fullfile(face_folder, '*.bmp');
bmpFiles = dir(filePattern);
for number_of_files = 1:2200
    if (number_of_files < 2000)
        
    else
        baseFileName = bmpFiles(number_of_files).name;
        fullFileName = fullfile(face_folder, baseFileName);
        afile = read_gray(fullFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        face_integral = integral_image(afile);
        prediction = boosted_predict(afile, boosted_classifier, weak_classifiers, 50);
        if (prediction < 0)
            for column = 1 : face_horizontal
                for row = 1 : face_vertical
                    faces(row,column,number_of_files) = afile(row, column);
                    face_integrals(row,column,number_of_files) = face_integral(row, column);
                end
            end
        end
    end
end



filePattern = fullfile(nonface_folder, '*.jpg');
jpgFiles = dir(filePattern);
for number_of_files = 1:110
    if (number_of_files < 100)
    else
        baseFileName = jpgFiles(number_of_files).name;
        fullFileName = fullfile(nonface_folder, baseFileName);
        afile = read_gray(fullFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        nonface_integral = integral_image(afile);
        prediction = boosted_predict(afile, boosted_classifier, weak_classifiers, 50);
        if (prediction >= 0)
            for column = 1 : face_horizontal
                for row = 1 : face_vertical
                    nonfaces(row,column,number_of_files) = afile(row, column);
                    nonface_integrals(row,column,number_of_files) = face_integral(row, column);
                end
            end
        end
    end

end

example_number = size(faces, 3) + size(nonfaces, 3);
labels = zeros(example_number, 1);
labels (1:size(faces, 3)) = 1;
labels((size(faces, 3)+1):example_number) = -1;
examples = zeros(face_vertical, face_horizontal, example_number);
examples (:, :, 1:size(faces, 3)) = face_integrals;
examples(:, :, (size(faces, 3)+1):example_number) = nonface_integrals;

classifier_number = numel(weak_classifiers);

responses =  zeros(classifier_number, example_number);

for example = 1:example_number
    integral = examples(:, :, example);
    for feature = 1:classifier_number
        classifier = weak_classifiers {feature};
        responses(feature, example) = eval_weak_classifier(classifier, integral);
    end

end

boosted_classifier2 = AdaBoost(responses, labels, 50);
save boosted2 boosted_classifier2

filePattern = fullfile(face_folder, '*.bmp');
bmpFiles = dir(filePattern);
for number_of_files = 1:2400
    if (number_of_files < 2200)
    else
        baseFileName = bmpFiles(number_of_files).name;
        fullFileName = fullfile(face_folder, baseFileName);
        afile = read_gray(fullFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        face_integral = integral_image(afile);
        prediction = boosted_predict(afile, boosted_classifier2, weak_classifiers, 50);
        if (prediction < 0)
            for column = 1 : face_horizontal
                for row = 1 : face_vertical
                    faces(row,column,number_of_files) = afile(row, column);
                    face_integrals(row,column,number_of_files) = face_integral(row, column);
                end
            end
        end
    end
end



filePattern = fullfile(nonface_folder, '*.jpg');
jpgFiles = dir(filePattern);
for number_of_files = 1:120
    if (number_of_files < 110)
    else
        baseFileName = jpgFiles(number_of_files).name;
        fullFileName = fullfile(nonface_folder, baseFileName);
        afile = read_gray(fullFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        nonface_integral = integral_image(afile);
        prediction = boosted_predict(afile, boosted_classifier2, weak_classifiers, 50);
        if (prediction >= 0)
            for column = 1 : face_horizontal
                for row = 1 : face_vertical
                    nonfaces(row,column,number_of_files) = afile(row, column);
                    nonface_integrals(row,column,number_of_files) = face_integral(row, column);
                end
            end
        end
    end
end

example_number = size(faces, 3) + size(nonfaces, 3);
labels = zeros(example_number, 1);
labels (1:size(faces, 3)) = 1;
labels((size(faces, 3)+1):example_number) = -1;
examples = zeros(face_vertical, face_horizontal, example_number);
examples (:, :, 1:size(faces, 3)) = face_integrals;
examples(:, :, (size(faces, 3)+1):example_number) = nonface_integrals;

classifier_number = numel(weak_classifiers);

responses =  zeros(classifier_number, example_number);

for example = 1:example_number
    integral = examples(:, :, example);
    for feature = 1:classifier_number
        classifier = weak_classifiers {feature};
        responses(feature, example) = eval_weak_classifier(classifier, integral);
    end

end

boosted_classifier3 = AdaBoost(responses, labels, 50);
save boosted3 boosted_classifier3

class1 = AdaBoost(responses, labels, 10);
class2 = AdaBoost(responses, labels, 20);
class3 = AdaBoost(responses, labels, 30);
class4 = AdaBoost(responses, labels, 40);
class5 = AdaBoost(responses, labels, 50);
save cascade class1 class2 class3 class4 class5

