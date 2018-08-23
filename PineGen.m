classdef PineGen
    
    properties
        ppm = 100; %pixels per meter
        %size for the output image in pixels
        upperLimitX = 1248;
        upperLimitY = 381;
        lowerLimitX = 1;
        lowerLimitY = 1;
    end
    
    
    methods
        
        function im = drawBowl(obj, xc, yc, w, h, height)
            %initialize the output image
            u = obj.lowerLimitX:obj.upperLimitX;
            v = obj.lowerLimitY:obj.upperLimitY;
            
            [U,V] = meshgrid(u,v);
            im = zeros(size(U));
            
            %express the peak in terms of the image size in meters but
            %expressed in the image coordinate system
            a = w/obj.ppm; b = h/obj.ppm;
            %one arch of cosine
            alpha = (-a:0.001:a);
            beta =  (-b:0.001:b);
            [Alpha, Beta] = meshgrid(alpha, beta);
            %plot3(Alpha+xc,Beta+yc, height*cos(Alpha*pi/(2*a)).*cos(Beta*pi/(2*b)));
            %axis equal
            X = Alpha*obj.ppm + xc;
            Y = Beta*obj.ppm + yc;
            Z = height*cos(Alpha*pi/(2*a)).*cos(Beta*pi/(2*b));
            
            %express the result in the image coordinate system
            Xfloor = floor(X);
            Yfloor = floor(Y);
            ind = find(Xfloor>= obj.lowerLimitX & Xfloor <= obj.upperLimitX & Yfloor >= obj.lowerLimitY & Yfloor <= obj.upperLimitY);
            
            linearInd = sub2ind(size(im), Yfloor(ind), Xfloor(ind));
            
            im(linearInd) = Z(ind);
            
            
        end
        
        function x = generateRandomBetween(obj, low, high)
            x =  low + floor((high-low)*rand(1)+0.5);%generateRandomBetween(100, 110);
        end
        
        function generateRandomBlob(obj)
            % rng(1)
            i = 0;
%             figure(1)
%             clf;
%             figure(2)
%             clf;
            n = obj.generateRandomBetween(1, 10);
            
            while (i < n)
                
                
                %size of the tree
                w = obj.generateRandomBetween(100, 110);
                h = obj.generateRandomBetween(100, 110);
                
                %center of the tree
                x = obj.generateRandomBetween(obj.lowerLimitX, obj.upperLimitX - w);
                
                y = obj.generateRandomBetween(obj.lowerLimitY, obj.upperLimitY - h);
                
                
                %variacion en la posicion
                inc = 5;
                %incremento tamaño
                incT = 20;
                
                
                j = 0;
                
                
                while (j < obj.generateRandomBetween(5, 10))
                    height = 1.4 + 1.8* rand(1);
                    %ovalo azul
                    imj = obj.drawBowl(x + obj.generateRandomBetween(-inc, inc),...
                        y + obj.generateRandomBetween(-inc, inc), ...
                        w + obj.generateRandomBetween(-incT, 0),...
                        h + obj.generateRandomBetween(-incT, 0), height);
                    if i == 0
                        im = imj;
                    else
                        im = max(im, imj);
                    end
                    
                    %axis equal
                    
                    j = j + 1;
                    
                end
                
                
                i = i + 1;
                
                
            end
                  
            
            imagesc(im)
%Show mesh and figure for the generatedt image
%             figure(1)
%             mesh(im);
%             
%             figure(2)
%             imagesc(im)
%             drawnow;
%             
%             fn = sprintf('im%03d.png',1);
%             saveas(1,fn);
%             gn = sprintf('gim%03d.png',1);
%             saveas(2,gn);
            
        end
        
    end
end
