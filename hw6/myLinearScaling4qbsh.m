function [minDist, bestPitch, allDist] = myLinearScaling4qbsh(queryPitch, dbPitch, lowerRatio, upperRatio, resolution, distanceType)
	sf=linspace(lowerRatio, upperRatio, resolution);
	queryLen=length(queryPitch);
	allDist = repmat(double(intmax()), 1, resolution);
    
	for i=1:resolution
		%Find the length of the scaled query (scaledQuery)
		scaledQueryLen=floor(queryLen*sf(i));
        
		%Get out of the loop if scaledQuery is longer than dbPitch
		if scaledQueryLen > length(dbPitch)
			break;
        end
        
		%Obtain scaledQuery by interp1
		scaledQuery=interp1(1:queryLen, queryPitch, linspace(1, queryLen, scaledQueryLen));
		%Find the difference (diffPitch) between scaledQuery and dbPitch
 		diffPitch=scaledQuery-dbPitch(1:scaledQueryLen); 		
       
		%Find the median of diffPitch
		if distanceType==1 % L1-norm
			justification=median(diffPitch);
		else % L2-norm
			justification=mean(diffPitch);
		end
		allDist(i)=(sum(abs(diffPitch-justification).^distanceType))/double(scaledQueryLen);
		scaledTransposedQuery{i}=scaledQuery-justification;
    end
   
  
    [minDist, minIndex]=min(allDist);
    bestPitch=scaledTransposedQuery{minIndex};
    
end