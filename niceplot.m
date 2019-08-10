function niceplot( X, Y, varargin )
%NICEPLOT Make a better looking plot in general.
%   Provide a cell-contained list if you want "hold-on" behaviour:
%   >>   niceplot( {myvec1, myvec2 ..} )
%   Name-Value arguments:
%     'MarkerFactor', f: x-axis percentage of plotted markers (0..1)
%   Otherwise follows simple plot conventions:
%   1. Single argument will be plotted as such.
%   2. Pair of arguments will be plotted against each other.
%
%   -- aj / May 2017 / NimbusLab.

  % change line colors for darker background
  set( groot, 'defaultAxesColorOrder', copper(3) )
  % check if marker plotting requested
  marker_requested = find(cellfun(@(x) strcmpi(x, 'MarkerFactor') , varargin));
  if marker_requested
    downsample_marker_idx = varargin{marker_requested+1};
  end
  
  % check if X is a cell, then plot individual elements
  if iscell(X)
    num_drawings = length(X);
    for idx = 1:num_drawings
      P = plot( X{idx}, 'LineWidth', 1.8 );
      hold on;
    end
    
  else
    if nargin >= 2
      P = plot( X, Y, 'LineWidth', 1.8 );
    elseif nargin == 1
      P = plot( X, 'LineWidth', 1.8 );
    else
      fprintf( 'This is not how you use this function. See help.\n' );
    end
  end

  % All prettifications go here
  ax = gca;
  ax.XMinorGrid = 'on'; ax.YMinorGrid = 'on'; ax.ZMinorGrid = 'on';
  ax.XGrid = 'on'; ax.YGrid = 'on'; ax.ZGrid = 'off';
  ax.FontSize = 16;
  ax.FontName = 'Serif';
  ax.Color = [0.85, 0.85, 0.85];
  ax.GridColor = [1, 1, 1]; ax.GridAlpha = 0.8;
  ax.MinorGridColor = [1 1 1]; ax.MinorGridAlpha = 0.8;
  if marker_requested
    P.Marker = 'o';
    P.MarkerIndices = 1:round(1/downsample_marker_idx):length(X);
  end
  
  % Okay, so it seems like there's much prettification one can do ..
  % Apparently, some more customisations can make plots more "professional".
  % These I'll add here for remembering:
  %  -- Prefer serif fonts (type `listfonts`), try cambria math.
  %   IEEE: "When preparing your graphics IEEE suggests that you use
  %   of one of the following Open Type fonts: Times Roman,
  %   Helvetica, Helvetica Narrow, Courier, Symbol, Palatino, Avant
  %   Garde, Bookman, Zapf Chancery, Zapf Dingbats, and New
  %   Century Schoolbook"
  %  -- set(h,'LineSmoothing','On') can smooth lines (why??)

end
