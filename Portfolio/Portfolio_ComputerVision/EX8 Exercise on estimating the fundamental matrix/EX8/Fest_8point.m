
% Arguments:
%          x1, x2 - Two sets of corresponding 3xN set of homogeneous
%          points.
%         
%          x      - If a single argument is supplied it is assumed that it
%                   is in the form x = [x1; x2]
% Returns:
%          F      - The 3x3 fundamental matrix such that x2'*F*x1 = 0.
%          e1     - The epipole in image 1 such that F*e1 = 0
%          e2     - The epipole in image 2 such that F'*e2 = 0
function [F,e1,e2] = Fest_8point(varargin)
    
    [x1, x2, npts] = checkargs(varargin(:));
        
    % Normalise each set of points so that the origin 
    % is at centroid and mean distance from origin is sqrt(2). 
    % normalise2dpts also ensures the scale parameter is 1.
    [x1, T1] = normalise2dpts(x1); % P.56 Normalization of Points
    [x2, T2] = normalise2dpts(x2);
    
    % Build the constraint matrix
    A = [x2(1,:)'.*x1(1,:)'   x2(1,:)'.*x1(2,:)'  x2(1,:)' ...
         x2(2,:)'.*x1(1,:)'   x2(2,:)'.*x1(2,:)'  x2(2,:)' ...
         x1(1,:)'             x1(2,:)'            ones(npts,1) ];       

      
    
	[U,D,V] = svd(A,0); 
    
    % Extract fundamental matrix from the column of V corresponding to
    % smallest singular value.
    F = reshape(V(:,9),3,3)';
    
    % Enforce constraint that fundamental matrix has rank 2 by performing
    % a svd and then reconstructing with the two largest singular values.
    [U,D,V] = svd(F,0);
    F = U*diag([D(1,1) D(2,2) 0])*V';
    
    % Denormalise
    F = T2'*F*T1;
    
    if nargout == 3  	% Solve for epipoles
	[U,D,V] = svd(F,0);
	e1 = hnormalise(V(:,3));
	e2 = hnormalise(U(:,3));
    end
    
%--------------------------------------------------------------------------

    
