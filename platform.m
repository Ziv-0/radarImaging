classdef platform
    %����ƽ̨
    properties
        v;
        h;
        angle;
        R0;
    end
    methods
        function obj = platform(v,R0)
            %��������ʵ��
            % �˴���ʾ��ϸ˵��
            obj.v = v;
            obj.R0 = R0;
            obj.h = 5000;
            obj.angle = 1.1071;
        end
    end
end
