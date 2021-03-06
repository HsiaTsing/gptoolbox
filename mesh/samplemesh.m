function [ IDS, D ] = samplemesh( V,F,n, use_min_max, use_geodesic )
  % SAMPLEMESH Takes n sample over the surface
  % There are no guarantees of the spacing of samples but they
  % tend to be uniformly spaced
  %
  % [IDS] = samplemesh(V,F,n)
  %
  % Input:
  %   V  vertex list
  %   F  face list
  %   n  number of samples
  %   use_min_max  whether to use min max {true}
  %   use_geodesic  whether to use geodesic {true}
  % Output:
  %   IDS  indices of the sampled vertices
  %
  
  if(~exist('use_min_max','var') || isempty(use_min_max))
      use_min_max = true;
  end
  
  if(~exist('use_geodesic','var') || isempty(use_geodesic))
      use_geodesic = true;
  end
  
  IDS = zeros(n,1);
  IDS(1) = 1;
  
  D = zeros(size(V,1),n);
  if(use_geodesic)
      D(:,1) = perform_fast_marching_mesh(V,F, IDS(1),struct('nb_iter_max',Inf));
  else
      D(:,1) = sqrt(sum((repmat(V( IDS(1),:),size(V,1),1)-V(:,:)).^2,2));
  end
  
  index = 1:size(V,1);
  index(1) = [];
  
  for i=2:n
      if (use_min_max)
          [~,jj] =  max(min(D(index,1:(i-1)),[], 2 ), [], 1) ;
          j = index(jj(1));
          index(jj(1)) = [];
      else
          S = sum(1.0./(D(:,1:(i-1)).^2),2);
          [~, j] = min(S);
      end
      IDS(i) = j;
      if(use_geodesic)
          progressbar(i-1,n-1,50);
          D(:,i) = ...
            perform_fast_marching_mesh(V,F,IDS(i),struct('nb_iter_max',Inf));
      else
          D(:,i) = sqrt(sum((repmat(V( IDS(i),:),size(V,1),1)-V(:,:)).^2,2));
      end
  end
  
  [IDS, order] = unique(IDS);
  D = D(:,order);
  D(IDS == 0 ) = [];
  IDS(IDS == 0 ) = [];
