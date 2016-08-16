function fgClose = modifyMask(fgMask,strelType,strelSize)

%finding foregorund mask, filling holes and closing gaps

fgFill = imfill(fgMask,'holes');
fgClose = imclose(fgFill,strel(strelType,strelSize));

end