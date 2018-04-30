function I=ReadSihamImages(NameOfCZI, ResizeFactor)

reader = bfGetReader(NameOfCZI);

I=[];

    for t=1:100
        try
            I(:,:,t)=bfGetPlane(reader, t);    
        catch
            break;    
        end
    end

I=imresize(I,ResizeFactor);
