function axis = time(fs, n,data)
axis = 1:n;
axis = axis -1;
axis = axis/fs;
plot(axis,data)

end
