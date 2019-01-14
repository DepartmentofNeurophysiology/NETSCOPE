function savefigas(f,out)

%disp('warning: no files saved');
%return;

folder = fileparts(out);
if exist(folder,'dir')~=7
    mkdir(folder);
end

%set(f,'visible','on');
saveas(f,out,'fig');
saveas(f,out,'png');
saveas(f,out,'svg');
%saveas(f,out,'epsc');
%saveas(f,out,'pdf');