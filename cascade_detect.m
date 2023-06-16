function result = cascade_detect(image,weak_classifiers,class1,class2,class3,class4,class5)
[row, col] = size(image);
scores = zeros(row, col);
example = zeros(100,100);


for r = 1:row 
    for c = 1:col 
        top = r - 49;
        if top < 1
            top = 1;
        end
        bot = r + 50;
        if bot > row
            bot = row;
        end
        left = c - 49;
        if left < 1
            left = 1;
        end
        right = c + 50;
        if right > col
            right = col;
        end
        window = image(top:bot, left:right);
        window = double(window);
        if size(window) == size(example)
            scores(r,c) = cascade_classify(window,weak_classifiers,class1,class2,class3,class4,class5);
        end
    end
end

s = nonzeros(scores);
max_score = max(max(s));
[rows, cols] = find(scores == max_score);
result = zeros(1,2);
ro = round (max(rows));
co = round (max(cols));

result(1,1) = max(ro);
result(1,2) = max(co);
top = ro - 99;
bottom = ro +50;
left = co - 99;
right = co + 50;
final = draw_rectangle1(image, top, bottom, left, right);
figure(6);imshow(final, []);
end

