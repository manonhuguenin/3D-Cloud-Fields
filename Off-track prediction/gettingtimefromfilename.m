function [time] = gettingtimefromfilename(filename)
%Get recording time from filename
newstr = erase(filename,'MOD03.A2011056.');
newstr = newstr(1:2);
time = str2double(newstr) + 1;
end

