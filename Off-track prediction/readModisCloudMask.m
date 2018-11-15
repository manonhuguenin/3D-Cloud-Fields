function cloudmask = readModisCloudMask(maskFilename, byteList, area) 
% function cloudmask = readModisCloudMask(maskFilename, byteList) 
% 
% DESCRIPTION: 
% Reads the mask product information from a MODIS MOD35 HDF file 
% 
% REQUIRED INPUT: 
%    maskFilename (string)  Name of MODIS MOD35 HDF file 
% 
% ------------------------------------------------------------------------ 
% 
% OPTIONAL INPUT:  
%    byteList  Byte numbers of data to return.  If this argument is  
%               specified, all bits of the selected byte are  
%               returned.  If this argument is not specified, ONLY 
%               bits 1 & 2 of byte 1 (cloud mask probability of clear, 
%               with QA) is returned. 
% 
%               byteList can be either an array of byte #s 
%               (1 through 6) or the string 'all' to return all 
%               bytes.  Note that to get the 250m cloud mask, only  
%               byte 5 or 6 (not both) needs to be requested.   
%             
%               See list below (under "Output") for a description of the  
%               bits in each byte. 
%                
%               For each byte requested, QA information is also read in  
%               A separate QA array is not returned, instead this information 
%               is incorporated into the cloud mask fields that are returned. 
%               The cloud mask values corresponding to QA "not useful" or 
%               "not applied" are set to -1.    
% 
% ------------------------------------------------------------------------ 
% 
% OUTPUT: 
%    cloudmask (struct) with contents determined by the byte  
%    numbers selected in byteList: 
% 
%    BYTE 1 
%      cloudmask.flag (bit 0) 
%  0 = Not determined  
%                                    1            =            Determined            99 
%  .mask (bits 1 & 2) 
%                      -1 = Not Useful (from QA)  
%                                    0            =            Cloud            
%  1 = 66% Probability of clear 
%  2 = 95% Probability of clear 
%  3 = 99% Probability of clear 
%               .confidenceQA (QA byte 1, bits 1,2,3) 
%                       0 - 7 confidence level for cloudmask.mask 
%  .dayOrNight (bit 3) 
%  0 = Night   1 = Day  -1 = Not Useful (from QA) 
%  .sunglint (bit 4) 
%  0 = Yes     1 = No   -1 = Not Useful (from QA) 
%  .snowIce (bit 5) 
%  0 = Yes     1 = No   -1 = Not Useful (from QA) 
%  .landWater (bits 6 & 7) 
%                      -1 = Not Useful (from QA) 
%                                    0            =            Water            
%                                    1            =            Coastal            
%                                    2            =            Desert            
%                                    3            =            Land            
% 
%    BYTE 2 (0 = Yes;  1 = No; -1 = Not Applied, from QA) 
%      cloudmask.bit0 (Non-cloud obstruction flag) 
%  .bit1 (Thin cirrus detected, solar) 
%  .bit2 (Shadow found) 
%  .bit3 (Thin cirrus detected, IR) 
%  .bit4 (Adjacent cloud detected -- implemented 
%       post-launch to indicate cloud found within 
%      surrounding 1km pixels) 
%  .bit5 (Cloud Flag, IR threshold) 
%  .bit6 (High cloud flag, CO2 test) 
%  .bit7 (High cloud flag, 6.7 micron test) 
% 
%    BYTE 3 (0 = Yes;  1 = No; -1 = Not Applied, from QA) 
%      cloudmask.bit0 (High cloud flag, 1.38 micron test) 
%  .bit1 (High cloud flag, 3.7-12 micron test) 
%  .bit2 (Cloud flag, IR temperature difference) 
%  .bit3 (Cloud flag, 3.7-11 micron test) 
%  .bit4 (Cloud flag, visible reflectance test) 
%  .bit5 (Cloud flag, visible reflectance ratio test) 
%  .bit6 (0.935/0.87 reflectance test) 
%  .bit7 (3.7-3.9 micron test) 
% 
%    BYTE 4 (0 = Yes;  1 = No; -1 = Not Applied, from QA) 
%      cloudmask.bit0 (Cloud flag, temporal consistency) 
%  .bit1 (Cloud flag, spatial variability) 100 
%  .bit2 (Final confidence confirmation test) 
%  .bit3 (Cloud flag, night water spatial variability) 
%  .bit4 (Suspended dust flag) 
% 
%    BYTES 5 & 6 250m Cloud Flag Visible Tests 
%                (0 = Yes;  1 = No; -1 = Not Applied, from QA)  
%      cloudmask.visibleTest250m  250m resolution array  
% 
%      
%  24 April: removed this field, it is memory intensive and not 
%            too useful so far.   
%       .sumVisibleTest250m  1km resolution, sum of all 
%                                       16 elements in each 1km grid 
% 
% ------------------------------------------------------------------------ 
% 
% Time to run this code for:   Byte 1        1 minute 
%                              Bytes 1-4     1.5 minutes 
%                              Bytes 5 & 6   3.3 minutes 
%  
% Note: With 1G of RAM, I run out of memory if I try to read all bytes at 
%       once.  Instead, I read bytes 1-4, then 5-6 separately.  
% 
% ------------------------------------------------------------------------ 
% 
% Written By: 
%    Suzanne Wetzel Seemann    
%    swetzel@ssec.wisc.edu 
%    April 2001 
% 
% update 23 April 2001 -- added QA for bytes 5 & 6 
% update 24 April 2001 -- removed .sumVisibleTest250m field because it 
%                         is memory intensive and not very useful so far 
% 
% Code History: Based on a code by Shaima Nasiri (modis_mask_read.m) that  
%               reads Byte 1 of the cloud mask.   
% 
% RESTRICTIONS: 
%    Only tested on Matlab version 5.3.1 (R11.1) - performance under 
%    other versions of Matlab is unknown 
% 
% ------------------------------------------------------------------------ 
% 
% SAMPLE RUN STATEMENTS: 
%  dataPath = '/home/swetzel/data/gomo310/'; 
% 
%  readModisCloudMask([dataPath 'MOD35_L2.A2000310.1750.002.2000332030507.hdf'], ... 
%                     [1 4]);                      
%  readModisCloudMask([dataPath 'MOD35_L2.A2000310.1750.002.2000332030507.hdf'], ... 
%                     5);                      
%  readModisCloudMask([dataPath 'MOD35_L2.A2000310.1750.002.2000332030507.hdf'], ... 
%                     1,'all');                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
% Error check inputs 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
onlyBits1and2 = 0; 
 if nargin < 1 
    error(['readModisCloudMask requires at least one input: maskFilename']); 
 elseif nargin == 1 
    byteList = 1; 
    onlyBits1and2 = 1; 
 elseif nargin > 1 
    if ischar(byteList)  
       if strcmp(byteList,'all') 
            byteList = [1:6]; 
       else 
            error(['Second input argument, byteList must either ' ... 
               'be an array of integers 1-6 or the string ''all''']); 
       end 
    else 
       if any(byteList > 6) | any(byteList < 1) 
            error(['Second input argument, byteList must either ' ... 
               'be an array of integers 1-6 or the string ''all''']); 
       end 
    end 
 end 
% Check for valid MOD35 HDF file 
 if (~exist(maskFilename,'file')) 
    error(['Filename : ' maskFilename ' was not found']); 
 end 
 len_filename = length(maskFilename); 
 if (~strcmp( maskFilename(len_filename-3:len_filename), '.hdf')) 
    error(['Filename: ' maskFilename ' is not an HDF file']); 
 end 
%% Add byte 5 to byteList if byte 6 was given or add 
%% byte 6 to byteList if byte 5 was given 
  if ismember(5,byteList) & ~ismember(6,byteList) 
      byteList = [byteList 6]; 
  elseif ~ismember(5,byteList) & ismember(6,byteList) 
      byteList = [byteList 5]; 
  end 
%% Find the largest cloud mask and QA byte number, to minimize 
%% the amount of data we need to read in.   
  minBytes = min(byteList); 
  maxBytes = max(byteList); 
  cloudMaskDataByteList = [minBytes:1:maxBytes]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
% Open cloud mask file and read data, dimensions, and attributes 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
 SD_id = hdfsd( 'start', maskFilename, 'read' ); 
 if (SD_id < 0) 
    error(['HDF file' maskFilename ' was not opened.']); 
 end 
% data we want is 'Cloud_Mask' 
 mask_ex = hdfsd('nametoindex', SD_id, 'Cloud_Mask'); 
 mask_id = hdfsd('select',SD_id, mask_ex); 
 [name,rank,dimsizes,data_type,nattrs,status(1)] = hdfsd('getinfo',mask_id ); 
nbytes = dimsizes(1); 
npixels_across =  dimsizes(2); 
npixels_along = dimsizes(3);  
start = [minBytes-1; 0 ; 0];  
count = [1 ; 1 ; 1]; 
edge = [1 ; npixels_across ;  npixels_along]; 
 if (nargin == 3) 
    start(2) = min( [max([area(1) 0]) (npixels_across - 1)] ); 
    start(3) = min( [max([area(2) 0]) (npixels_along - 1)] ); 
    edge(2) = min( [max([area(3) 0]) (npixels_across - start(2))] ); 
    edge(3) = min( [max([area(4) 0]) (npixels_along - start(3))] ); 
 end 
%  if maxBytes <= nbytes  
%    edge = [maxBytes-minBytes+1; npixels_along; npixels_across]; 
%  else  
%    error(['maxBytes cannot be greater than the number of bytes in the file']); 
%  end 
 [cloudMaskData,status(2)] = hdfsd('readdata',mask_id,start,count,edge); 
 cloudMaskData  = double(cloudMaskData); 
 attr_ex = hdfsd('findattr', mask_id, 'scale_factor'); 
 [scale, status(3)] = hdfsd('readattr', mask_id,attr_ex) ; 
 attr_ex = hdfsd('findattr', mask_id, 'long_name'); 
 [longname, status(4)] = hdfsd('readattr', mask_id,attr_ex) ; 
 attr_ex = hdfsd('findattr', mask_id, 'Cell_Along_Swath_Sampling'); 
 [sampling, status(5)] = hdfsd('readattr', mask_id,attr_ex) ; 
 attr_ex = hdfsd('findattr', mask_id, 'add_offset'); 
 [offset, status(6)] = hdfsd('readattr', mask_id,attr_ex) ; 
 if offset ~= 0 | scale ~= 1 
    error(['Cloud_Mask offset ~= 0 or slope ~= 1']); 
 end  
% stop accessing data  
 status(7) = hdfsd('endaccess',mask_id); 
 if any(status == -1) 
   error('Trouble reading Cloud_Mask data, dimensions, or attributes'); 
 end 
 clear status 
% close HDF file 
 status = hdfsd('end', SD_id); 
 if (status < 0) 
    warning(['HDF file' maskFilename ' was not closed.']); 
 end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
%% Read all bits from the selected bytes 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
%% For each byte, before reading the bits, we must separate 
%% the bytes and adjust image array for use in Matlab :  
%%  convert values to double precision  
%% rotate and flip the image 
%%  convert from MOD35's signed integers to Matlab's unsigned  
%%         integers where [0:127 -128:-1] is mapped to [0:1:255] 
  clear cloudmask  
  cloudmask.filename = maskFilename;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 
  %% Cloud_Mask: BYTE 1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 
  if any(byteList == 1)  
     byteInd = find(1 == cloudMaskDataByteList); 
     byte1 = flipud(rot90(squeeze(cloudMaskData(:,:,byteInd)) )); 
     % find negative integers and remap them 
     ind = find(byte1 < 0); 
     byte1(ind) = 256 + byte1(ind); 
     clear ind 
     %% BITS 1,2 - Unobstructed FOV Quality Flag 
     %%   0 = Cloud 
     %%   1 = 66% Probability of clear 
     %%   2 = 95% Probability of clear 
     %%   3 = 99% Probability of clear 
     bit3 = bitget(byte1,3);  
     bit2 = bitget(byte1, 2); 
     clear99prob_ind = find(bit3 & bit2); 
     clear95prob_ind = find(bit3 & ~bit2); 
     clear66prob_ind = find(~bit3 & bit2); 
     cloud_ind = find(~bit3 & ~bit2); 
     cloudmask.byte1.mask = NaN * ones(size(byte1)); 
     cloudmask.byte1.mask(clear99prob_ind) = 3; 
     cloudmask.byte1.mask(clear95prob_ind) = 2; 
     cloudmask.byte1.mask(clear66prob_ind) = 1; 
     cloudmask.byte1.mask(cloud_ind) = 0; 
     clear bit3 bit2 clear99prob_ind clear95prob_ind clear66prob_ind cloud_ind 
     if onlyBits1and2 == 0 
        %% BIT 0 - CloudMask Flag 
        %%   0 = Not determined 
        %%   1 = Determined 
        cloudmask.byte1.flag = bitget(byte1, 1); 
        %% BIT 3 - Day or Night Path 
        %%   0 = Night   1 = Day 
        cloudmask.byte1.dayOrNight = bitget(byte1,4); 
        %% BIT 4 - Sunglint Path 
        %%   0 = Yes     1 = No 
        cloudmask.byte1.sunglint = bitget(byte1,5); 
        %% BIT 5 - Snow/Ice Background Path 
        %%   0 = Yes     1 = No 
        cloudmask.byte1.snowIce = bitget(byte1,6); 
        %% BITS 6,7 - Land or Water Path 
        %%   0 = Water 
        %%   1 = Coastal 
        %%   2 = Desert 
        %%   3 = Land 
        cloudmask.byte1.landWater = NaN * ones(size(byte1)); 
        bit7 = bitget(byte1,7); bit8 = bitget(byte1,8); 
        land_ind  = find(bit8 & bit7); 
        desert_ind = find(bit8 & ~bit7); 
        coastal_ind = find(~bit8 & bit7); 
        water_ind = find(~bit8 & ~bit7); 
        cloudmask.byte1.landWater(land_ind) = 3; 
        cloudmask.byte1.landWater(desert_ind) = 2; 
        cloudmask.byte1.landWater(coastal_ind) = 1; 
        cloudmask.byte1.landWater(water_ind) = 0; 
        clear bit7 bit8 land_ind desert_ind coastal_ind water_ind 
     end 
     clear byte1 
  end % byte 1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  
  %% Cloud_Mask: BYTES 2-4  
  %%   0 = Yes     1 = No 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 
  if any(byteList == 2 | byteList == 3 | byteList == 4) 
     indBytes234 = find(byteList == 2 | byteList == 3 | byteList == 4); 
     for j = 1:length(indBytes234) 
        byteInd = find(byteList(indBytes234(j)) == cloudMaskDataByteList); 
        byteData = flipud(rot90(squeeze(cloudMaskData(:,:,byteInd)) )); 
    clear    byteInd    
        % find negative integers and remap them 
        ind = find(byteData < 0); 
        byteData(ind) = 256 + byteData(ind); 
        clear ind 
        if byteList(indBytes234(j)) < 4  
           %% 8 bits (0-7) in bytes 2 and 3   
           numBits = 8; 
        else 
           %% 5 bits (0-4) in byte 4 
           numBits = 5; 
        end 
        % assign data to cloudmask structure: cloudmask.byte#.bit# 
        for k = 1:numBits 
           eval(['cloudmask.byte' num2str(byteList(indBytes234(j))) ... 
             '.bit' num2str(k-1) ' = bitget(byteData,k);']); 
        end 
        clear byteData  
      end %% for 
  end  %% bytes 2, 3, 4 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 
  %% Cloud_Mask: BYTES 5 & 6: 250-m Cloud Flag, Visible Tests 
  %%   0 = Yes     1 = No 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 
  if any(byteList == 5) | any(byteList == 6) 
  %% BYTE 5 
     byteInd = find(5 == cloudMaskDataByteList); 
     byte5 = flipud(rot90(squeeze(cloudMaskData(:,:,byteInd)) )); 
     clear byteInd 
     % find negative integers and remap them 
     ind = find(byte5 < 0); 
     byte5(ind) = 256 + byte5(ind); 
     clear ind 
     %% create an array of all NaNs 4x the size of one element  
     %% repmat is faster than ones*NaN 
     elementSize = size(bitget(byte5,1)); 
     cloudmask.visibleTest250m = repmat(0,elementSize*4); 
     xStartInds = [1 1 1 1 2 2 2 2]; 
     yStartInds = [1 2 3 4 1 2 3 4]; 
     %% insert each element into the array of NaNs. 
     for j = 1:8 
        %allbits(j,:,:) = bitget(byte5,j); 
        cloudmask.visibleTest250m([xStartInds(j):4:elementSize(1)*4], ... 
                     [yStartInds(j):4:elementSize(2)*4]) = bitget(byte5,j);  
     end 
     clear byte5 
  %% BYTE 6 
     byteInd = find(6 == cloudMaskDataByteList); 
     byte6 = flipud(rot90(squeeze(cloudMaskData(:,:,byteInd)) )); 
     clear byteInd 
     % find negative integers and remap them 
     ind = find(byte6 < 0); 
     byte6(ind) = 256 + byte6(ind); 
     clear ind 
     byte6bits = [9:16]; 
     xStartInds = [3 3 3 3 4 4 4 4]; 
     yStartInds = [1 2 3 4 1 2 3 4]; 
     %% insert each element into the array of NaNs. 
     for j = 1:8  
        %allbits(byte6bits(j),:,:) = bitget(byte6,j); 
        cloudmask.visibleTest250m([xStartInds(j):4:elementSize(1)*4], ... 
               [yStartInds(j):4:elementSize(2)*4]) = bitget(byte6,j);  
     end 
     clear byte6 
     %cloudmask.sumVisibleTest250m = squeeze(sum(allbits,1));  
  end  %% byte 5,6 
  clear cloudMaskData 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
% QA: Open cloud mask file and read QA data, dimensions, and attributes 
% 
% NOTE: It is repetitive to do QA separately after all of the 'Cloud_Mask' 
%        data, however it would take too much memory to keep  
%        'Quality_Assurance' and 'Cloud_Mask' (qaData and cloudMaskData)  
%        arrays around simultaneously 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% 
 SD_id = hdfsd( 'start', maskFilename, 'read' ); 
 if (SD_id < 0) 
    error(['HDF file' maskFilename ' was not opened.']); 
 end 
% data we want is 'Quality_Assurance' 
 mask_ex = hdfsd('nametoindex', SD_id, 'Quality_Assurance'); 
 mask_id = hdfsd('select',SD_id, mask_ex); 
 [name,rank,dimsizes,data_type,nattrs,status(1)] = hdfsd('getinfo',mask_id ); 
%  npixels_along = dimsizes(1); 
%  npixels_across = dimsizes(2);  
%  nbytes = dimsizes(3); 
  start = [0 ; 0 ; minBytes-1];  
  count = [1 ; 1 ; 1]; 
%  
%  if maxBytes <= nbytes  
%    edge = [npixels_along; npixels_across; maxBytes-minBytes+1]; 
%  else  
%    error(['maxBytes cannot be greater than the number of bytes in the file']); 
%  end 
 edge = [npixels_across ;  npixels_along; maxBytes-minBytes+1]; 
 if (nargin == 3) 
    start(1) = min( [max([area(1) 0]) (npixels_across - 1)] ); 
    start(2) = min( [max([ar
ea(2) 0]) (npixels_along - 1)] ); 
    edge(1) = min( [max([area(3) 0]) (npixels_across - start(2))] ); 
    edge(2) = min( [max([area(4) 0]) (npixels_along - start(3))] ); 
end 
 [qaData,status(2)] = hdfsd('readdata',mask_id,start,count,edge); 
 qaData  = double(qaData); 
 attr_ex = hdfsd('findattr', mask_id, 'scale_factor'); 
 [qascale, status(3)] = hdfsd('readattr', mask_id,attr_ex) ; 
 attr_ex = hdfsd('findattr', mask_id, 'long_name'); 
 [qalongname, status(4)] = hdfsd('readattr', mask_id,attr_ex) ; 
 attr_ex = hdfsd('findattr', mask_id, 'Cell_Along_Swath_Sampling'); 
 [qasampling, status(5)] = hdfsd('readattr', mask_id,attr_ex) ; 
 attr_ex = hdfsd('findattr', mask_id, 'add_offset'); 
 [qaoffset, status(6)] = hdfsd('readattr', mask_id,attr_ex) ; 
 if qaoffset ~= 0 | qascale ~= 1 
    error(['Quality_Assurance offset ~= 0 or slope ~= 1']); 
 end  
% stop accessing data  
 status(7) = hdfsd('endaccess',mask_id); 
 if any(status == -1) 
   error('Trouble reading Quality_Assurance data, dimensions, or attributes'); 
 end 
 clear status 
% close HDF file 
 status = hdfsd('end', SD_id); 
 if (status < 0) 
    warning(['HDF file' maskFilename ' was not closed.']); 
 end 
 if any(byteList == 1)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% 
     %% 'Quality_Assurance': BYTE 1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% 
     byteInd = find(1 == cloudMaskDataByteList); 
     qabyte1 = flipud(rot90(squeeze(qaData(byteInd,:,:)) )); 
     % find negative integers and remap them 
     ind = find(qabyte1 < 0); 
     qabyte1(ind) = 256 + qabyte1(ind); 
     clear ind 
     %% BIT 0 - Cloud Mask QA 
     %% 0 = not useful    1 = useful 
     %% Assign all not useful values to -1 byte1 fields  
     notUsefulInds = find(~bitget(qabyte1,1)); 
     cloudmask.byte1.mask(notUsefulInds) = -1; 
     if onlyBits1and2 == 0 
        cloudmask.byte1.dayOrNight(notUsefulInds) = -1; 
        cloudmask.byte1.sunglint(notUsefulInds) = -1; 
        cloudmask.byte1.snowIce(notUsefulInds) = -1; 
        cloudmask.byte1.landWater(notUsefulInds) = -1; 
        %% BITS 1,2,3 - Cloud Mask Confidence 
        bit2 = bitget(qabyte1,2);  
        bit3 = bitget(qabyte1,3);  
        bit4 = bitget(qabyte1,4);  
        ind0 = find(~bit4 & ~bit3 & ~bit2); 
        ind1 = find(~bit4 & ~bit3 & bit2); 
        ind2 = find(~bit4 & bit3 & ~bit2); 
        ind3 = find(~bit4 & bit3  & bit2); 
        ind4 = find(bit4 & ~bit3 & ~bit2); 
        ind5 = find(bit4 & ~bit3 & bit2); 
        ind6 = find(bit4 & bit3 & ~bit2); 
        ind7 = find(bit4 & bit3 & bit2); 
        clear bit2 bit3 bit4 
        cloudmask.byte1.confidenceQA = NaN * ones(size(qabyte1));  
        cloudmask.byte1.confidenceQA(ind0) = 0;  
        cloudmask.byte1.confidenceQA(ind1) = 1;  
        cloudmask.byte1.confidenceQA(ind2) = 2;  
        cloudmask.byte1.confidenceQA(ind3) = 3;  
        cloudmask.byte1.confidenceQA(ind4) = 4;  
        cloudmask.byte1.confidenceQA(ind5) = 5;  
        cloudmask.byte1.confidenceQA(ind6) = 6;  
        cloudmask.byte1.confidenceQA(ind7) = 7;  
        clear ind0 ind1 ind2 ind3 ind4 ind5 ind6 ind7  
    end 
    clear qabyte1 notUsefulInds 
  end  %% qa byte 1 
  if any(byteList == 2 | byteList == 3 | byteList == 4) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% 
     %% Quality_Assurance: BYTES 2-4 
     %%  
     %% 0 = Not Applied   1 = Applied 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% 
     indBytes234 = find(byteList == 2 | byteList == 3 | byteList == 4); 
     for j = 1:length(indBytes234) 
        qaByteInd = find(byteList(indBytes234(j)) == cloudMaskDataByteList); 
        qaByteData = flipud(rot90(squeeze(qaData(qaByteInd,:,:)) )); 
    clear    qaByteInd    
        % find negative integers and remap them 
        ind = find(qaByteData < 0); 
        qaByteData(ind) = 256 + qaByteData(ind); 
        clear ind 
        if byteList(indBytes234(j)) < 4  
           %% 8 qa bits (0-7) in qa bytes 2 and 3     
           numBits = 8; 
        else 
           %% 5 qa bits (0-4) in qa byte 4 
           numBits = 5; 
        end 
        %% For QA "not applied", set corresponding value in    
        %% cloudmask.byte#.bit# to -1  
        for k = 1:numBits 
           eval(['cloudmask.byte' num2str(byteList(indBytes234(j))) ... 
             '.bit' num2str(k-1) '(find(~bitget(qaByteData,k))) = -1;']); 

        end % for k 
        clear qaByteData  
      end %% for j 
  end  %% bytes 2, 3, 4 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 
  %% Quality_Assurance: BYTES 5 & 6: 250-m Cloud Flag, Visible Tests 
  %%   0 = Not Applied     1 = Applied  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 
  if any(byteList == 5) | any(byteList == 6) 
  save tempCMdata  
  keep2 cloudMaskDataByteList qaData 
  clear cloudmask 
  %% BYTE 5 
     qaByteInd = find(5 == cloudMaskDataByteList); 
     qaByteData = flipud(rot90(squeeze(qaData(qaByteInd,:,:)) )); 
     clear qaByteInd 
     % find negative integers and remap them 
     ind = find(qaByteData < 0); 
     qaByteData(ind) = 256 + qaByteData(ind); 
     clear ind 
     %% create an array of all NaNs 4x the size of one element  
     %% repmat is faster than ones*NaN 
     elementSize = size(bitget(qaByteData,1)); 
     temporaryQA = repmat(0,elementSize*4); 
     xStartInds = [1 1 1 1 2 2 2 2]; 
     yStartInds = [1 2 3 4 1 2 3 4]; 
     %% insert each element into the array of NaNs. 
     for j = 1:8 
        temporaryQA([xStartInds(j):4:elementSize(1)*4], ... 
                      [yStartInds(j):4:elementSize(2)*4]) = bitget(qaByteData,j);  
     end 
     
     clear qaByteData  
  %% BYTE 6 
     qaByteInd = find(6 == cloudMaskDataByteList); 
     qaByteData = flipud(rot90(squeeze(qaData(qaByteInd,:,:)) )); 
     clear qaByteInd 
     % find negative integers and remap them 
     ind = find(qaByteData < 0); 
     qaByteData(ind) = 256 + qaByteData(ind); 
     clear ind 
     xStartInds = [3 3 3 3 4 4 4 4]; 
     yStartInds = [1 2 3 4 1 2 3 4]; 
     %% insert each element into the array of NaNs. 
     for j = 1:8  
        temporaryQA([xStartInds(j):4:elementSize(1)*4], ... 
                    [yStartInds(j):4:elementSize(2)*4]) = bitget(qaByteData,j);  
     end 
     clear qaByteData qaData 
     notAppliedInds = find(~temporaryQA); 
     load tempCMdata 
     cloudmask.visibleTest250m(notAppliedInds) = -1; 
     clear notAppliedInds temporaryQA 
  end  %% byte 5,6 