function plotMFs_custom(flc)
figure;
for i = 1:2
    subplot(2,2,i);
    xrange = flc.inputs(i).range;
    x = linspace(xrange(1), xrange(2), 200);
    hold on;
    for j = 1:length(flc.inputs(i).mf)
        mf = flc.inputs(i).mf{j};
        y = arrayfun(@(xi) evalMF(xi, mf), x);
        plot(x, y, 'LineWidth',1.5);
    end
    title(['Input: ' flc.inputs(i).name]);
    xlabel('Value'); ylabel('Membership');
    grid on;
end
for i = 1:2
    subplot(2,2,2+i);
    xrange = flc.outputs(i).range;
    x = linspace(xrange(1), xrange(2), 200);
    hold on;
    for j = 1:length(flc.outputs(i).mf)
        mf = flc.outputs(i).mf{j};
        y = arrayfun(@(xi) evalMF(xi, mf), x);
        plot(x, y, 'LineWidth',1.5);
    end
    title(['Output: ' flc.outputs(i).name]);
    xlabel('Value'); ylabel('Membership');
    grid on;
end
end