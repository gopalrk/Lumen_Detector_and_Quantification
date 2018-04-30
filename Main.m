

indir='R:\Common\1_PHD STUDENTS AND POST DOCS\Siham Yennek\20180131\CTRL1\';
Name_of_Trail='1';
ResizeFactor=1;
Thfactor=1.3;


mkdir([indir 'OP\']);
opdir=[indir 'OP\'];
D=dir([indir '*.czi']);



TotalResT=[];

for i=1:3%numel(D)
    
try
NameOfCZI=D(i).name;    

ResT=Process_SihamVolumes_CovexHull(NameOfCZI,indir, opdir, ResizeFactor, Thfactor);

TotalResT=[TotalResT;ResT];

catch
    continue;
end

end

writetable(TotalResT,[opdir 'TrailNo_' Name_of_Trail '.xlsx']);





