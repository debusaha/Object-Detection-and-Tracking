k = 35503;

for k = 35503:36502
    filename = ['C:\Users\itsde\Desktop\Trapping\Trapping\' num2str(k,'%d') '.jpg'];

    aa = imread(filename); % read the file
    figure(1), colormap('gray'), imagesc(aa);

    b = bpass(aa,1,35,50); % apply band pass filter
    figure(2), colormap('gray'), image(b);

    pk = pkfnd(b,50,35); % find the peak 
    s = size(pk);
    x = ones(s(1),1)*24;
    pos = [pk,x];
    e = insertShape(aa, 'circle', pos, 'Color', {'red'},'LineWidth', 2);

    figure(3), image(e);
    BW = imbinarize(b, 50);

    figure(4), imshow(BW, 'Colormap', [0 0 0; 1 1 1]);
    BW_image_uint8 = uint8(BW);

    filename = ['C:\Users\itsde\Desktop\Trapping\MASK\' num2str(k,'%d') '.jpg'];
    imwrite(BW_image_uint8, filename);
end