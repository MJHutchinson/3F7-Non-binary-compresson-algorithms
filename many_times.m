fol = 'test_files\canterbury\';
files = dir(fol);
files(1) = [];

%compute bases
b = [2.^(1:16) 2:1:50];
%b = [b linspace(2^1, 2^16, 942) 2:1:50];
b = sort(unique(round(b)));
disp(['Testing coding on ' num2str(length(files)) ' files with ' num2str(length(b)) ' bases'])

l = length(b) + 1;
t = cell(l, (2*length(files) + 1));
for k = 2:l
    t{k, 1} = b(k - 1);
end

for o = 2:length(files)
    disp(['testing for ' files(o).name])
    
    t{1, 2*o} = files(o).name;
    f_name = [fol files(o).name];
    t_temp = compare_times(f_name, b);
    
    %copy values
    for k = 2:l
        t{k, 2*o} = t_temp(k - 1, 2);
        t{k, 2*o+1} = t_temp(k - 1, 3);
    end
    
    %t{2:l, 2*o:1+2*o} = t_temp;
end
save('data\times.mat','t')