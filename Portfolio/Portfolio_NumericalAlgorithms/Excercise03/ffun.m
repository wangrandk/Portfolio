function f = ffun(l,y,dl,M,k,L0,g,top_holdes_fast)
%FFUN
% f = ffun(l,y,dl,M,k,L0,g):
%   - anvendes til Opg. C (modellerer funktionen f)
% input:
%     l                : en søjlevektor med længde n+1
%     y                : en søjlevektor med længde n+1
%     dl               : længden af et stykke af Slinky'en
%     M,k,L0,g         : konstanter
%     top_holdes_fast  : boolean der angiver om toppen holdes fast
%                        = true (top holdes fast)
%                        = false (top hænger frit)
% output:
%     f                : en søjlevektor med længde n+1
%
if nargin < 8 || isempty(top_holdes_fast), top_holdes_fast = false; end;
if size(l,2) ~= 1 || size(y,2) ~= 1
    error('ffun : input l and y must be column vectors')
end
if ~isscalar(dl) || ~isscalar(M) || ~isscalar(k) || ~isscalar(L0) || ~isscalar(g)
    error('ffun : input dl,M,k,L0 and g must be scalars')
end
if top_holdes_fast
    y(1) = 0;                    % top is fixed
end
grad = gradient(y-l,dl);
if ~top_holdes_fast
    grad(1) = 0;                 % top is loose
end
grad(end) = 0;                   % bottom is loose
gradgrad = gradient(grad,dl);
f=(k*L0*L0/M)*gradgrad+g;
