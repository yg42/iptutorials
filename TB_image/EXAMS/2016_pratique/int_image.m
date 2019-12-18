function II=int_image(I)
% function of computation of integral image
I2 =  zeros(size(I)+1);
II = I2;
I2(2:end, 2:end) = I;

for i=2:size(I2,1)
    for j=2:size(I2,2)
        II(i,j)=I2(i,j)+II(i-1,j)+II(i,j-1)-II(i-1,j-1);
    end
end

%test(II, integralImage(I));

    function test(I1, I2)
        disp('test difference:')
        d = sum(sum(abs(I2-I1)))
    end

end
