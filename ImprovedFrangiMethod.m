
%Convert RGB images to gray images;
for i=1:6
    for j=1:3
        I=imread(['OriginalDatabase\GW1_',num2str(i),'_',num2str(j),'.jpg']);
        I=rgb2gray(I);
        imwrite(I,['GrayDatabase\gsGW1_',num2str(i),'_',num2str(j),'.jpg']);
    end
end

%Improved Frangi Method
for i=1:6
    for j= 1:3
    I=imread (['GrayDatabase\gsGW1_',num2str(i),'_',num2str(j),'.jpg']); 
    I=double(I);
    options = struct('FrangiScaleRange', [1 2], 'FrangiScaleRatio', 0.5, 'FrangiBetaOne',0.5, 'FrangiBetaTwo', 15, 'verbose',true,'BlackWhite',false);
    [Ivessel,Scale,dir]=FrangiFilter2D(I,options);   
    Scale = mapminmax(Scale', 0, 1)';
    imwrite(Ivessel,['SigmaDifference\siGW1_',num2str(i),'_',num2str(j),'.jpg'])
    end
end

%Multi-thrshold and label the images
for i=1:6
    for j= 1:3
       I=imread (['SigmaDifference\siGW1_',num2str(i),'_',num2str(j),'.jpg']); 
       I=double(I);

       I_medfit = medfilt2(I,[3, 3]);

       thresh = multithresh(I_medfit,3);
       seg_I = imquantize(I_medfit,thresh(1));    
       RGB1 = label2rgb(seg_I);
       RGB1 = im2bw(RGB1);
       [hh,mm]=size(RGB1);
       RGB1=RGB1(6:hh-6,6:mm-6);
       RGB1 = bwareaopen(RGB1,20000);
       imwrite(RGB1,['MultiThreshold\mt1_',num2str(i),'_',num2str(j),'.jpg'])
    
       [L,num] = bwlabel(RGB1,4);
       STATS = regionprops(L,'Area');
       S=STATS.Area;
       labelnew=1;
       for k=1:num
          S=STATS(k).Area;
          if(S(1)<=100)
              L(L(:,:)==k)=0;
          else 
              L(L(:,:)==k)=labelnew;
              labelnew=labelnew+1;
          end
       end
       RGB1 = label2rgb(L);
       imwrite(RGB1,['LabeledDatabase\la1_',num2str(i),'_',num2str(j),'.jpg'])
    end
end