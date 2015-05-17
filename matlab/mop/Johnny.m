function [calc_degree] = Johnny(tdoa, arcLength)
    %================================================
    % SETUP
    %================================================
    v = 343; %Speed of sound in air
    
%     arcLength = 4;
    
    halfArc = arcLength/2;
    p = [[-1 -1 1 1]; [-1 1 -1 1]] * halfArc;
    plot(p(1,:),p(2,:),'*');
    hold on
    
    %Sensor closested to emittor
    [~,c] = min(tdoa);
    %Removing the time for wich the sensors did not know of the signal
    t = tdoa-tdoa(c); %The actual timestamps the signals have to work with
    %================================================
    % COMPUTING POSITION ... see paper
    %================================================
    ijs = 1:4;
    ijs(c) = [];
    A = zeros(size(ijs,1), 2);
    b = zeros(size(ijs,1), 1);
    iRow = 0;
    rankA = 0;
    for i = ijs
        for j = ijs
            iRow = iRow + 1;
            A(iRow,:) = 2*(v*(t(j)-t(c))*(p(:,i)-p(:,c))'-v*(t(i)-t(c))*(p(:,j)-p(:,c))');
            b(iRow,1) = v*(t(i)-t(c))*(v*v*(t(j)-t(c))^2-p(:,j)'*p(:,j)) ...
                +	(v*(t(i)-t(c))-v*(t(j)-t(c)))*p(:,c)'*p(:,c) ...
                +	v*(t(j)-t(c))*(p(:,i)'*p(:,i)-v*v*(t(i)-t(c))^2);
            rankA = rank(A);
            if(rankA >= 2)
                break;
            end
        end
        if(rankA >= 2)
            break;
        end
    end

    x_hat_inv = A\b; %Calculated position of emitter
    if (sign(x_hat_inv(1)) ~= sign(p(1,c)) && ...
            sign(x_hat_inv(2)) ~= sign(p(2,c)))
        x_hat_inv = -x_hat_inv;
    end
    calc_degree = radtodeg(angle((x_hat_inv(1)+ 1i*x_hat_inv(2))));
    
    r = (x_hat_inv(1)^2+x_hat_inv(2)^2)^0.5;
    axis equal
%     plot(x_hat_inv(1), x_hat_inv(2), '*r');
    line([0, x_hat_inv(1)*10/r], [0,x_hat_inv(2)*10/r]);
    title(calc_degree);
    
%     % enter real location for debug:
%     x = input('x: ');
%     y = input('y: ');
%     hold on
%     plot(x,y,'*g')
    
    % width = 200;
    % maxDim = max(max(abs(x_star), abs(x_hat_inv)));
    % if (maxDim + 10 > width)
    %     width = maxDim + 10;
    % end
    % height = width;
    % 
    % axis([-width, width, -height, height]);
    % plot(p(1,:), p(2,:), '.b');
    % title('Acoustic Simulator');
    % legend('Estimated shot location', 'Actual shot location', 'Sensors');
end