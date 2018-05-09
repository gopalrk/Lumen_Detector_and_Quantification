function I=ReadImages(NameOfCZI, ResizeFactor)

reader = bfGetReader(NameOfCZI);

MaximumTimePoint=100; %% This should be changed according to data

I=[];

    for t=1:MaximumTimePoint
        try
            I(:,:,t)=bfGetPlane(reader, t);    
        catch
            break;    
        end
    end

I=imresize(I,ResizeFactor);
