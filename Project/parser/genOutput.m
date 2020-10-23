fid=fopen('MyFile.txt','w');

data = audioread('t28000.wav');
data = data(:,1);
data = data * 1000;
data = round(data);

for i = 0:32767
    if (i + 1) > length(data)
        fprintf(fid,'%i : %i2;\n', i,0);
    else
        fprintf(fid,'%i : %i2;\n', i,data(i+1));
    end
    i
end

data = audioread('reggae8000.wav');
data = data(:,1);
data = data * 1000;
data = round(data);

for i = 0:32767
    if (i + 1) > length(data)
        fprintf(fid,'%i : %i2;\n', i+32768,0);
    else
        fprintf(fid,'%i : %i2;\n', i+32768,data(i+1));
    end 
    i
end