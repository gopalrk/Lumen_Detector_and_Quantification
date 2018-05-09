function ResT=Process_Volumes(NameOfCZI,indir, opdir, ResizeFactor, Thfactor, ExperimentName)


warning off;


disp('                                           ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(['Processing ' NameOfCZI]);
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('                                           ');


I=ReadImages([indir NameOfCZI], ResizeFactor);

%opdir='W:\Image_Analysis_Gopal\fena\Main_Code\FENA\bfmatlab\OP\';

Res=[];
ResT=[];

for i=1:size(I,3)
    
   
   try
    
   ImageNow=I(:,:,i);
   ImageNowProc=mat2gray((ImageNow));
   
   Th=graythresh(ImageNowProc);
   Th=Th*Thfactor;
   
     
   BW=ImageNowProc>Th;
 
   
    kernel = [1;1;1];
    BW = imclose(BW, kernel);
%    BW = imdilate(BW, kernel);

    BWtemp0=BW;
    
        
   
   %BW=bwpropfilt(imfill(BW,'holes'),'eccentricity',[0 0.7]); %% This is done if there is a conflict with two roundish structure
   BW=imfill(BW,'holes');
   BW=bwareafilt(BW,1); 
   
   solidity_=regionprops(BW,'Solidity');
   OuterSolidity=solidity_.Solidity;
   
   BWtemp=BW & BWtemp0;
     
   
   if OuterSolidity<0.90 
       
       while OuterSolidity<0.9           
        seD = strel('disk',3);
        BW = imdilate(imfill(BW,'holes'), seD);
        solidity_=regionprops(BW,'solidity');
        OuterSolidity=solidity_.Solidity;
        %imshow(BW,[]);title(num2str(OuterSolidity));       
       end
       BW_Outer=BW;
       
       BW=BWtemp;
       
        solidity_=regionprops(BW,'solidity');
        OuterSolidity=solidity_.Solidity;
       
       while OuterSolidity<0.5
        seD = strel('disk',3);
        BW = imdilate(BW, seD);
        solidity_=regionprops(BW,'solidity');
        OuterSolidity=solidity_.Solidity;
       end
       
       TempOuter=bwareafilt(imerode(BW_Outer,seD),1);
       
       BW_Inner=TempOuter-BW;
       
   else
       BW_Outer=BW;
       BW_Inner=BW_Outer-BWtemp;
       
   end
         
   
   
    Res(i).Time = i;
    Res(i).ImageName={NameOfCZI};
    Res(i).OuterDiameter=NaN;
    Res(i).InnerDiameter=NaN;
    Res(i).InnerDiameterVSOuter=NaN;
    Res(i).SegmentationOP={''};
    Res(i).OuterArea=NaN;
    Res(i).OuterPerim=NaN;
    Res(i).InnerArea=NaN;
    Res(i).InnerPerim=NaN;
    Res(i).OuterAreaThickness=NaN;
    Res(i).ExperimentName=ExperimentName;
    
    
   
   statsOuter = regionprops(BW_Outer, 'EquivDiameter');
   statsInner = regionprops(BW_Inner, 'EquivDiameter');
   
%    if isempty(statsInner)
%        ResT=[];
%         disp(['PROBLEM in Processing ' NameOfCZI ' hence skipped: Unable to segment inner diameter of 1st timepoint' ]);
%        return;
%    end




   Res(i).OuterDiameter=statsOuter.EquivDiameter;
   Res(i).InnerDiameter=statsInner.EquivDiameter;   
   Res(i).InnerDiameterVSOuter = Res(i).InnerDiameter/Res(i).OuterDiameter;
   
    disp([ 'Time= ' num2str(i) ' Outer diam= ' num2str( Res(i).OuterDiameter)  '    Inner diam= '  num2str(Res(i).InnerDiameter)]);
    
    
   
   
   %%%%%%%%%%%  DisPlay of Result %%%%%%%%%%%%%%%%%%%%%
   
   bb=regionprops(BW_Outer,'boundingbox');
   bbidx=bb.BoundingBox;
   %%%% Make a window around bb
   bbidx(1)=bbidx(1)-10;
   bbidx(2)=bbidx(2)-10;
   bbidx(3)=bbidx(3)+20;
   bbidx(4)=bbidx(4)+20;
   
   
   f=figure(2);   
   set(f, 'Visible', 'off');
   
   imshow(imcrop(ImageNowProc, bbidx),[]),
   %set(gcf,'position',[1.00         38.33       1920.00        970.67]);
   hold on,
   visboundaries(imcrop(BW_Outer, bbidx),'Color','r');
   
   if ~isempty(BW_Inner(:))
   visboundaries(imcrop(BW_Inner, bbidx),'Color','b');
   end
   
    Res(i).SegmentationOP={[opdir 't_' num2str(i) '_' NameOfCZI '_.png']}; 
    print(f,'-dpng',[opdir 't_' num2str(i) '_' NameOfCZI '_.png']);
    close(f);

    Res(i).OuterArea = bwarea(BW_Outer); %%% Please note why I used BW here and not BW_Outer
    [B,L,N,A] = bwboundaries(BW_Outer);
    Res(i).OuterPerim=size(B{1},1); 
    
    Res(i).InnerArea=0;
    Res(i).InnerPerim=0;
    if ~isempty(BW_Inner(:))
    Res(i).InnerArea = bwarea(BW_Inner); %%% Please note why I used BW here and not BW_Outer
    [B,L,N,A] = bwboundaries(BW_Inner);
    Res(i).InnerPerim = size(B{1},1);  
    end
    
    Res(i).OuterAreaThickness=Res(i).OuterArea-Res(i).InnerArea;
    Res(i).Time = i;
    Res(i).ImageName={NameOfCZI};
    
   catch
       continue;
   end
   
end


ResT=struct2table(Res);   
   