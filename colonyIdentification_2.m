% colonyIdentification_2.m
% 

%[X,map] = imread('1.tif');
%if ~isempty(map)
%    RGB_Picture = ind2rgb(X,map);
%end
%imshow(RGB_Picture);

RGB_Picture = imread('3.jpg'); % read picture
RGB_Picture_2 = RGB_Picture(:,:,1:3)
imshow(RGB_Picture_2);       % show what you read

% Get RGB Value
RGB_Picture_R = RGB_Picture(:,:,1);
RGB_Picture_G = RGB_Picture(:,:,2);
RGB_Picture_B = RGB_Picture(:,:,3);

% Show R,G,B,Original Picture
figure('Name','RGB and Oringinal Pictures');
subplot(2,2,1),imshow(RGB_Picture_R),title('Red component');
subplot(2,2,2),imshow(RGB_Picture_G),title('Green component');
subplot(2,2,3),imshow(RGB_Picture_B),title('Blue component');
subplot(2,2,4),imshow(RGB_Picture_2),title('Original Picture');

% Change Picture format

figure('Name','Gray Scale Picture');
Gary_Picture = rgb2gray(RGB_Picture_2);
imshow(Gary_Picture);
BW_Picture = im2bw(Gary_Picture,0.70);
figure('Name','Black White Picture');
imshow(BW_Picture);
figure;
imshowpair(Gary_Picture,BW_Picture,'montage');

% Delete noise(Small pixel graphics)
BW_Picture_deleted = bwareaopen(BW_Picture,200);
figure('Name','Black White Picture after delete samll pixel graphics');
imshow(BW_Picture_deleted);

% Find graphics edge and label
[B,L] = bwboundaries(BW_Picture_deleted) % only focus on outside edge.
figure('Name','')
imshow(label2rgb(L,@jet,[.5 .5 .5]))
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end


stats = regionprops(L,'Area','Centroid');

threshold = 0.94;

% loop over the boundaries
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  
  % compute the roundness metric
  metric = 4*pi*area/perimeter^2;
  
  % display the results
  metric_string = sprintf('%2.2f',metric);

  % mark objects above the threshold with a black circle
  if metric > threshold
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
  end
  
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold')
  
end

title(['Round rate closer to 1 indicate that ',...
       'the object is approximately round'])