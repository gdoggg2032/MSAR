% step a
t=0:0.1:4*pi;
y=sin(t)+rand(1, length(t));
plot(t, y, '.-');

% step b
localmaxs = [];
for i = 2 : 1 : length(y)-1
    if y(i) > y(i-1) & y(i) > y(i+1)
        localmaxs = [localmaxs, i];
    end
end
plot(t, y, '.-', t(localmaxs), y(localmaxs),'o');

% step c
for p=localmaxs
    text(t(p), y(p), sprintf('(%.2f, %.2f)', t(p), y(p)));
end