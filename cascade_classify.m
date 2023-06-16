function result = cascade_classify(window,weak_classifiers,class1,class2,class3,class4,class5)
integral = integral_image(window);

classifier_number = size(class1, 1);
classifier_index = class1(classifier_number, 1);
classifier_alpha = class1(classifier_number, 2);
classifier_threshold = class1(classifier_number, 3);
classifier = weak_classifiers{classifier_index};

result1 = eval_weak_classifier(classifier, integral);
if (result1 > 90)
    classifier_number = size(class2, 1);
    classifier_index = class2(classifier_number, 1);
    classifier_alpha = class2(classifier_number, 2);
    classifier_threshold = class2(classifier_number, 3);
    classifier = weak_classifiers{classifier_index};

    result2 = eval_weak_classifier(classifier, integral);
    if (result2 > 90)
        classifier_number = size(class3, 1);
        classifier_index = class3(classifier_number, 1);
        classifier_alpha = class3(classifier_number, 2);
        classifier_threshold = class3(classifier_number, 3);
        classifier = weak_classifiers{classifier_index};
        result3 = eval_weak_classifier(classifier, integral);
        if (result3 > 90)
            classifier_number = size(class4, 1);
            classifier_index = class4(classifier_number, 1);
            classifier_alpha = class4(classifier_number, 2);
            classifier_threshold = class4(classifier_number, 3);
            classifier = weak_classifiers{classifier_index};
            result4 = eval_weak_classifier(classifier, integral);
            if (result4 > 90)
                classifier_number = size(class5, 1);
                classifier_index = class5(classifier_number, 1);
                classifier_alpha = class5(classifier_number, 2);
                classifier_threshold = class5(classifier_number, 3);
                classifier = weak_classifiers{classifier_index};
                result = eval_weak_classifier(classifier, integral);
            else
                result = 0;
            end
        else
            result = 0;
        end
    else
        result = 0;
    end
else
    result = 0;
end


end

