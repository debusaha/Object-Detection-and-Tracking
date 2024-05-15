%folders = 41; % Number of folders containing the images (or experimental data sets)
%imcount = zeros([folders 1]); % create a list of total number of images in each folder
skipped_images = []; % saves the frame number if images are skipped during the acquisition process by the camera
%---------------------------------------------------------------------------------------
%for f = 1:folders 
  n = 0;
  cnt1 = []; % empty matrix to store position data
  %--------------------------------------------------------------------------------------
  %if f < 10
      a = dir(['E:\2019-04-12\Debasish\00' num2str(f,'%d') '\*.jpg']); % automatically generates path to read the images
  else
      a = dir(['E:\2019-04-12\Debasish\0' num2str(f,'%d') '\*.jpg']); % automatically generates path to read the images
  end
   %------ This part of the code is to read the number of first and last
   %image file in a particular folder -------------------------------------
   B = extractfield(a,'name');
   A = zeros(1,size(B,2));
   for k = 1:size(B,2)
       A(k) = sscanf(B{k},'%f'); 
   end
  %------------------------------------------------------------------------
  %for k = 0:100 
  for k = min(A):max(A); % runs of all image files in a flder
      if f < 10
         filename = ['E:\2019-04-12\Debasish\00' num2str(f,'%d') '\' num2str(k,'%f') '.jpg'];
      else
         filename = ['E:\2019-04-12\Debasish\0' num2str(f,'%d') '\' num2str(k,'%f') '.jpg'];
      end
    %filename = ['D:\2019-02-26\Static\images\' num2str(k,'%f') '.jpg'];      
    if exist(filename,'file') ~= 0 % check if the file exists   
      aa = imread(filename); % read the file
      %figure(1), colormap('gray'), imagesc(aa);
      b = bpass(aa,1,35,70); % apply band pass filter
      %figure(2), colormap('gray'), image(b);
      pk = pkfnd(b,80,35); % find the peak 
      %s = size(pk);
      %x = ones(s(1),1)*24;
      %pos = [pk,x];
      %e = insertShape(aa, 'circle', pos, 'Color', {'red'},'LineWidth', 2);
      %figure(3), image(e);
      %--------------------------------------------------------------------
      if size(pk,1) ~= 0 % find the centeroid only if a peak/particle detected
        cnt = cntrd(b,pk,29); % find the centeroid (PARTICLE POSITION DATA)
        %--- This part of code for creating position data (a text file) and visualisation -------
        if size(cnt,1) ~=0 
        s1 = size(cnt);
        x1 = ones(s1(1),1)*12;
        cnt = cnt(1:end,1:end-2);
        pos1 = [cnt,x1];
        ff = insertShape(aa, 'circle', pos1, 'Color', {'green'},'LineWidth', 2); % visualisation
        figure(4), image(ff);
        drawnow;
        frame = ones(s1(1),1).*k;
        cnt = cat(2, cnt, frame);
        cnt1 = cat(1,cnt1, cnt); % accumulating all position data
        n = n + 1;
        else
            break;
        end
        %------------------------------------------------------------------
      else
        break;
      end
      %--------------------------------------------------------------------
    else
        skipped = [f k]; % write the skipped frame
        skipped_images = cat(1,skipped_images,skipped); % append all skipped frames
    end
    display(k);
  end
  imcount(f,1) = n;
  cntfilename = ['images_' num2str(f,'%d') '_cnt1.txt']; % generate filename to store position data
  dlmwrite(cntfilename,cnt1,'delimiter','\t','precision',7); % write the text file containing the position data
 end
xlswrite('imagecount.xls',imcount); % excel file for number of images in all folders
xlswrite('skipped_images_trap_center.xls',skipped_images); % excel file for the skipped images in all folders

