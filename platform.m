classdef platform
    %����ƽ̨
    properties
        v;
        h;
        angle;
    end
    methods
        function obj = radar()
            %��������ʵ��
            % �˴���ʾ��ϸ˵��
            obj.fc = 1*10^9;
            obj.PRF = 57.6;
            obj.kr = 6*10^12;
            obj.tr = 5*10^-6;
        end
    end
end
