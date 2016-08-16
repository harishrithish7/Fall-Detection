function [fallDetected,posFalls] = updateCheckPosFalls(posFalls,noPosFalls,noFrFallSeq,orChg,areaChg,speed,thOrChg,thAreaChg,thSpeed)
nxtPosFallNo = 0;
nxtPosFalls = struct([]);
fallDetected = false;
for posFallInd=1:noPosFalls
    posFalls(posFallInd).avgOrChg = ((posFalls(posFallInd).avgOrChg*posFalls(posFallInd).noFrames)+orChg)...
        /(posFalls(posFallInd).noFrames+1);
    posFalls(posFallInd).avgAreaChg = ((posFalls(posFallInd).avgAreaChg*posFalls(posFallInd).noFrames)+areaChg)...
        /(posFalls(posFallInd).noFrames+1);
    posFalls(posFallInd).speed = ((posFalls(posFallInd).speed*posFalls(posFallInd).noFrames)+speed)...
        /(posFalls(posFallInd).noFrames+1);
    posFalls(posFallInd).noFrames = posFalls(posFallInd).noFrames+1;
    
    if posFalls(posFallInd).noFrames == noFrFallSeq
        %check if fall is detected or not
        if ((abs(posFalls(posFallInd).avgOrChg) >= thOrChg && ...
                abs(posFalls(posFallInd).avgAreaChg) >= thAreaChg) && posFalls(posFallInd).speed >= thSpeed)
            %send notification
            fallDetected = true;
            sprintf('Fall Detected')
            %making next possible falls empty
            nxtPosFalls = struct([]);
            nxtPosFallNo = 0;
            break;
        end
    else
        nxtPosFallNo = nxtPosFallNo+1;
        if isempty(nxtPosFalls)
            nxtPosFalls = posFalls(posFallInd);
        else
            nxtPosFalls(nxtPosFallNo) = posFalls(posFallInd);
        end
    end
end

posFalls = nxtPosFalls;
end