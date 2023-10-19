clear all
fid=fopen('C:\\Users\\User\\Desktop\\STL_model\\blankd12.stl', 'r');
number = 0;
count = 1;

header = fread(fid, 80);

for i = 1 : 4
    number = number + fread(fid, 1) * (256 ^ (i - 1));
end
vectors = zeros(number, 3);
elements = zeros(number, 9);
colors = zeros(number, 1);

while ~feof(fid)
    %tline = fgetl(fid);
    if (count > number)
        if(fgetl(fid) == -1)
            break;
        end
    end
    
    v = [0 0 0];
    for j = 1 : 3
        for i = 1 : 4
            v(j) = v(j) + fread(fid, 1) * (256 ^ (i - 1));
        end
        faction = 1;
        for c = 23 : -1 : 1
            faction = faction + bitget(v(j), c) * 2 ^ (c - 24);
        end
        v(j) = (-1) ^ bitget(v(j), 32) * 2 ^ (bi2de(bitget(v(j), 31:-1:24), 'left-msb') - 127) * faction;
    end
    vectors(count, :) = v;
    
    p = zeros(1, 9);
    for k = 1 : 3
        for j = 1 : 3
            for i = 1 : 4
                p(3 * (k - 1) + j) = p(3 * (k - 1) + j) + fread(fid, 1) * (256 ^ (i - 1));
            end
            faction = 1;
            for c = 23 : -1 : 1
                faction = faction + bitget(p(3 * (k - 1) + j), c) * 2 ^ (c - 24);
            end
            p(3 * (k - 1) + j) = (-1) ^ bitget(p(3 * (k - 1) + j), 32) * 2 ^ (bi2de(bitget(p(3 * (k - 1) + j), 31:-1:24), 'left-msb') - 127) * faction;
        end
    end
    elements(count, :) = p;
    
    color = 0;
    for i = 1 : 2
        color = color + fread(fid, 1) * (256 ^ (i - 1));
    end
    colors(count, :) = color;
    
    count = count + 1;
end

fclose(fid);

figure(1)

surf(elements(:, 1:3:7), elements(:, 2:3:8), elements(:, 3:3:9), 'FaceColor', 'g');
