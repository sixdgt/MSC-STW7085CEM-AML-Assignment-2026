function plotControlSurface_custom(flc)
temp_range = linspace(15,35,30);
light_range = linspace(0,1000,30);
[HC, DIM] = deal(zeros(length(temp_range), length(light_range)));
for i = 1:length(temp_range)
    for j = 1:length(light_range)
        [hc, dim] = evaluateFLC(flc, temp_range(i), light_range(j));
        HC(i,j) = hc;
        DIM(i,j) = dim;
    end
end
figure;
subplot(1,2,1);
surf(light_range, temp_range, HC, 'EdgeColor','none');
xlabel('Light (Lux)'); ylabel('Temp (°C)'); zlabel('Heater/Cooler (%)');
title('Control Surface: Heating/Cooling');
subplot(1,2,2);
surf(light_range, temp_range, DIM, 'EdgeColor','none');
xlabel('Light (Lux)'); ylabel('Temp (°C)'); zlabel('Dimmer (%)');
title('Control Surface: Lighting');
end