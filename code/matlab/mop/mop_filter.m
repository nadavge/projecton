function norm_data = mop_filter(data)
max = 0;
targetMax = 128;
firstMax = -1;
			
% 			 FIND MAX VALUE
norm_data = zeros(size(data));
for  k = 1:length(data) - 1
    absolute = abs(data(k));
	if absolute > max
		max = absolute;
    end
end
maxReduce = 1 - targetMax / max;

for k = 1:length(data) 
	absolute = abs(data(k));
				
				% NOISE CUTTING
				%if (abs <= targetMax / 6) data[i] = 0;
				
				% NORMALIZATION
	factor = (maxReduce * absolute / max);
	dat = ((1 - factor) * data(k));
    absdat = abs(dat);
	if (absdat <= targetMax) 
		norm_data(k) = dat;
    end
				
				% NOISE REDUCTION
	if (absdat < targetMax / 2)
        norm_data(k) = (data(k) * absdat / (targetMax / 2.0));
    end
				
				% WEIGHTING FROM FIRST MAXIMUM
    if (absdat >= (targetMax*0.75)  && firstMax == -1) 
		firstMax = k;
    end
	if (firstMax >= 0) 
        data(k) = (data(k) * (1-min(((k-firstMax)*1.0/(length(data)/3)),1)));
    end
end
end