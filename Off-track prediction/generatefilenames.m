function [filesnames02,filesnames03] = generatefilenames(filenames35)
%Generates the filenames from MOD35 to MOD02 and MOD03
NFiles = size(filenames35);
NFiles = NFiles(1);
filesnames02 = cell(NFiles,1);
filesnames03 = cell(NFiles,1);
for i = 1:NFiles
    str = filenames35{i};
    newstr=erase(str,'MOD35_L2.');
    newstr=newstr(1:13);
    str02=strcat('MOD021KM.',newstr);
    str03=strcat('MOD03.',newstr);
    filesnames02{i}=str02;
    filesnames03{i}=str03;
end

end

