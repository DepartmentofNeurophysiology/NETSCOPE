%% all

getgset;
func = @median;

warning('off', 'MATLAB:MKDIR:DirectoryExists');
disp('figures');
for sparse = 1
    for i = 1:4
        for j = 1:3
            input = ['data_Tido\mutualinfo\' gset{i} '\' class{j}];
            if sparse==1
                output = ['figs\sparse\networkstats\' gset{i} '\' classs{j}];
            else
                output = ['figs\networkstats\' gset{i} '\' classs{j}];
            end
            gotablefigures(gset{i},class{j},classs{j},sparse);
        end
        gotablefc1(gset{i},func,sparse);
        degdosfigs(gset{i},sparse);
    end
end
warning('on', 'MATLAB:MKDIR:DirectoryExists');

%% new

getgset;
warning('off', 'MATLAB:MKDIR:DirectoryExists');
disp('figures');
for sparse = 0
    for i = 1:3
        gotablefc3(gset{i},sparse);
        degdosfigs(gset{i},sparse);
    end
end
gephifigs(sparse);
warning('on', 'MATLAB:MKDIR:DirectoryExists');
