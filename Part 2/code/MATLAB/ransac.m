function van_pt = ransac(B)

vp = zeros(size(B,1)*(size(B,1)-1)/2,3);
count = zeros(size(B,1)*(size(B,1)-1)/2,1);
val = 1;

for i=1:(size(B,1)-1)
    
    for j=(i+1):size(B,1)
        
        l_1 = B(i,:); l_2 = B(j,:);
        vp(val,:) = cross(l_1,l_2);
                        
        for k=1:size(B,1)
            
            if ( (k~=i) && (k~=j) )
                
                temp = abs(dot(vp(val,:),B(k,:)));
                %disp(sum(temp));
                if sum(temp) <= 1e-2
                    count(val) = count(val)+1;
                end
                
            end
            
        end
        
        val = val+1;
        
    end