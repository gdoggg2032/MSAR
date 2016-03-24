function matrixReshaped = myShape(matrix)
    s = size(matrix);
    pagesize = s(1)*s(2);
    % matrixReshaped = [matrix(1:1*pagesize);matrix(1*pagesize+1:2*pagesize);matrix(2*pagesize+1:3*pagesize)];
    matrixReshaped = reshape(matrix, pagesize,[])';
    return;
    
    


