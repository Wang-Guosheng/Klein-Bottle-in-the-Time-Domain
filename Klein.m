function Klein
% Plot a Klein bottle
    time = linspace(0, 2*pi, 200);
    center = @(t)3*[cos(t), zeros(size(t)), sin(t).*sin(t/2).^6];
        % The central axis is taken as a water drop curve.
    circcolor = hsv(length(time));
    figure;
    k = 0;
    while k < 2
        for t = time
            normCirc(center(t), center(t + .1) - center(t), .6*sin(t + 1.2) + .8,...
                circcolor(1 + round(t/time(2)), :));
            axsetting; drawnow;
        end
        k = k + 1;
    end
    cla; hold on;
    for t = time
        normCirc(center(t), center(t + .1) - center(t), .6*sin(t + 1.2) + .8,...
            circcolor(1 + round(t/time(2)), :));
        drawnow;
    end
    X = cell2mat(get(allchild(gca), 'XData'));
    Y = cell2mat(get(allchild(gca), 'YData'));
    Y = Y.*(Y > 0);
    Y(Y == 0) = NaN; Y0 = Y;
    Z = cell2mat(get(allchild(gca), 'ZData'));
    cla;
    for compress = (1:20)./20
        Y = Y0*(1 - compress);
        hold off;
        for k = 1:length(X)
            plot3(X(k, :), Y(k, :), Z(k, :), 'color', circcolor(k, :));
            hold on;
        end
        axsetting; drawnow;
    end
    Y0(Y0 ~= 0) = 1;
    Y0 = Y0.*repmat(3*sin(time)', [1, 100]);
    for compress = (1:20)./20
        Y = Y0*compress;
        hold off;
        for k = 1:length(X)
            plot3(X(k, :), Y(k, :), Z(k, :), 'color', circcolor(k, :));
            hold on;
        end
        axsetting;
        if compress > .5
            title('M\"obius Ring', 'interpreter', 'latex');
        end
        drawnow;
    end
end

function normCirc(center, vec, radius, color)
% Plot a circle with unit radius normal to the input vector.
    phi = linspace(0, 2*pi)';
    [alpha, beta] = normPlane(vec);
    circ = radius.*(cos(phi)*alpha + sin(phi)*beta) + repmat(center, [length(phi), 1]);
    plot3(circ(:,1), circ(:,2), circ(:,3), 'color', color);
end

function [alpha, beta] = normPlane(vec)
% Return two normalized orthorgonal vectors each ortho-
% gonal to the input vector.
    if length(vec) ~= 3
        error("normPlane can only take 3 dimensional vectors.")
    elseif ~norm(vec)
        error("Norm of the input vector must not be 0")
    end
    flag = 2;
    if vec(1)
        flag = 0;
    elseif vec(2)
        flag = 1;
    end
    [a, b, c] = deal(vec(flag + 1), ...
                    vec(mod(flag + 1, 3) + 1), ...
                    vec(mod(flag + 2, 3) + 1));
    alpha = [b, -a, 0]/norm([b, -a, 0]);
    beta = [c, 0, -a]/norm([c, 0, -a]);
end

function axsetting
    axis([-1,1,-1,1,-1,1]*5);
    daspect([1,1,1]);
    view(162,18);
    title('Klein Bottle');
    set(findall(gcf,'-property','FontName'),'FontName','Unicode Symbols');
end