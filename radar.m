classdef radar
    %�״����
    properties
        PRF ;
        fc;
        kr;
        tr;
        fr;
    end
    methods
        function obj = radar(PRF,fc,kr,tr,fr)
            %��������ʵ��
            % �˴���ʾ��ϸ˵��
            obj.fc = fc;
            obj.PRF = PRF;
            obj.kr = kr;
            obj.tr = tr;
            obj.fr = fr;
        end
    end
end

