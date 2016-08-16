function orChg = findOrChg(orientation,prevOr)

orChg = orientation-prevOr;
if orChg >= 90
    orChg = orChg-180;
elseif orChg <= -90
    orChg = orChg+180;
end

end