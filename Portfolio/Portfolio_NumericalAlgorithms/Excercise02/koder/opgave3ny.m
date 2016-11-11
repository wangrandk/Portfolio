% n=input('Angiv matrixstørrelsen n: ');
for i=1:4
    n1=[100 200 400 800];
    n=n1(i);
        % Matrix + løsning:
        A=rand (n)/10;
        b=rand (1,n)';
        % Metode 1: Backslash:
        % fprintf('For metode 1:\n');
        tic;
        x1=A\b;
        toc;
        Tabel(i,1)=toc;
        % Metode 2: Inverse:
        % fprintf('For metode 2:\n');
        tic;
        x2=inv(A)*b;
        toc;
        Tabel(i,2)=toc;
        % Metode 3: Determinant:
        % fprintf('For metode 3:\n');
        tic;
        DetermA=det(A);
        for j=1:n
            Am=A;
            Am(:,j)=b;
            x(j)=det (Am)/DetermA;
        end
        toc;
        Tabel(i,3)=toc;
end
format long
print(Tabel(:,:), 'Data','n=100 n=200 n=400 n=800','Backslash Inverse Determinant')
% Hvor meget hurtigere er backslash metoden når n=800?
Tabel(4,2)/Tabel(4,1);
% Imellem 1.3 og 2.7 gange hurtigere.