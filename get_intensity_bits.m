function out = get_intensity_bits(val,chan)

% this function will eventually contain the information/fitting from the
% gamma calibration routine, but for now, just scales linearly, and selects
% by channel ('G' or 'B')

switch chan
    case 'B'
        val = min(val,1);
        val = max(val,0);
        out = round((val./10^-4.9674).^(1/2.0870));
        out = min(out,255);
        out = max(out,0);
    case 'Br' % reverse
        out = (val .^ 2.0870) * (10 ^ -4.9674);
    case 'G'
        val = min(val,1);
        val = max(val,0);
        out = round((0.8037*val./10^-4.9514).^(1/2.0829));
        out = min(out,255);
        out = max(out,0);
    case 'Gr' % reverse
        out = (val .^ 2.0829) * (10 ^ -4.9514) / 0.8037;
end