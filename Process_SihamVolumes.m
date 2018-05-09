% 
%NameOfCZI='T2Iono_T3SecCarba_Subset30.czi';


function ResT=Process_SihamVolumes(NameOfCZI,indir, opdir, ResizeFactor, Thfactor)


% 
 I=ReadSihamImages([indir NameOfCZI], ResizeFactor);



%opdir='W:\Image_Analysis_Gopal\fena\Main_Code\FENA\bfmatlab\OP\';

Res=[];

for i=1:size(I,3)
    
   close all;
    
   ImageNow=I(:,:,i);
   ImageNowProc=mat2gray(ImageNow);
   
   Th=graythresh(ImageNowProc);
   Th=Th*Thfactor;
   
   BW=ImageNowProc>Th;
   
   BWtemp=BW;
   BW=bwpropfilt(imfill(BW,'holes'),'eccentricity',[0 0.5]); %% This is done if there is a conflict with two roundish structure
   
   BW=BW & BWtemp;
   
      
   BW=bwareafilt(BW,1);   
      
   BW_Outer=imfill(BW,'holes');  
   
   
    kernel = [1;1;1];
    BW_Outer = imclose(BW_Outer, kernel);
    
    
   
   BW_Inner=BW_Outer-BW;
      
   
   bb=regionprops(BW_Outer,'boundingbox');
   bbidx=bb.BoundingBox;
   %%%% Make a window around bb
   bbidx(1)=bbidx(1)-10;
   bbidx(2)=bbidx(2)-10;
   bbidx(3)=bbidx(3)+20;
   bbidx(4)=bbidx(4)+20;
   
   
   if length(find(BW_Inner(:)))
   
   figure;   
   imshow(imcrop(ImageNow,bbidx),[]),
   set(gcf,'position',[1.00         38.33       1920.00        970.67]);
   hold on,
   visboundaries(imcrop(BW_Outer,bbidx),'Color','r');
   visboundaries(imcrop(BW_Inner,bbidx),'Color','b');
   
%    reg=regionprops(BW,'BoundingBox');   
%    imshow(imcrop(ImageNowProc,reg.BoundingBox),[])

    Res(i).OuterArea = bwarea(BW); %%% Please note why I used BW here and not BW_Outer
    [B,L,N,A] = bwboundaries(BW_Outer);
    Res(i).OuterPerim=size(B{1},1);   
    Res(i).InnerArea = bwarea(BW_Inner); %%% Please note why I used BW here and not BW_Outer
    [B,L,N,A] = bwboundaries(BW_Inner);
    Res(i).InnerPerim = size(B{1},1);    
    Res(i).FigureName={[opdir num2str(i) '_.png']}; 
    print(gcf,'-dpng',[opdir num2str(i) '_.png']);
    
   else
   figure;
   imshow(imcrop(ImageNow,bbidx),[]), 
   set(gcf,'position',[1.00         38.33       1920.00        970.67]);
   hold on,
   visboundaries(imcrop(BW_Outer,bbidx),'Color','r');
   %visboundaries(BW_Inner,'Color','b')
   
%    reg=regionprops(BW,'BoundingBox');   
%    imshow(imcrop(ImageNowProc,reg.BoundingBox),[])

    Res(i).OuterArea = bwarea(BW); %%% Please note why I used BW here and not BW_Outer
    [B,L,N,A] = bwboundaries(BW_Outer);
    Res(i).OuterPerim=size(B{1},1);   
    Res(i).InnerArea = 0; %%% Please note why I used BW here and not BW_Outer   
    Res(i).InnerPerim = 0;    
    Res(i).ResultImageCropped={[opdir num2str(i) '_Cropped_.png']}; 
    print(gcf,'-dpng',[opdir num2str(i) '_Cropped_.png']);
    Res(i).ImageName={NameOfCZI};
    Res(i).Time=i;
    
   end
   
   %%% Show Original
   
   bb=regionprops(BW_Outer,'boundingbox');
   bbidx=bb.BoundingBox;
   bbidx(1)=bbidx(1)-25;
   bbidx(2)=bbidx(2)-25;
   bbidx(3)=bbidx(3)+50;
   bbidx(4)=bbidx(4)+50;
    figure;
   imshow((ImageNow),[]);   
   set(gcf,'position',[1.00         38.33       1920.00        970.67]);
   hold on
   try
   h = imrect(gca,bbidx);
   setColor(h,'yellow');
   catch
       bbidx=bb.BoundingBox; 
       h = imrect(gca,bbidx);
       setColor(h,'yellow');    
   end
   
    Res(i).ResultImageOriginal={[opdir num2str(i) '_Original_.png']}; 
    print(gcf,'-dpng',[opdir num2str(i) '_Original_.png']);
    
    
end


ResT=struct2table(Res);
%writetable(ResT,[opdir 'OpTable.xlsx']);
