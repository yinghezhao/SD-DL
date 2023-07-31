function str_=num2abc2(num)
string={'A','B','C','D','E','F','G',...
        'H','I','J','K','L','M','N','O',...
        'P','Q','R','S','T','U','V','W','X','Y','Z'};
str_=[];
    while num>0
        m=mod(num,26);
        if m==0
            m=26;
        end
        str_=[str_ string{m}];
        num=(num-m)/26;
    end
    str_=fliplr(str_);
end