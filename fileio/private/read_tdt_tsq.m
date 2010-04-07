function tsq = read_tdt_tsq(filename, begblock, endblock)

% READ_TDT_TSQ reads the headers from a Tucker_Davis_technologies TSQ file
%
% Use as
%   tsq = read_tdt_tsq(filename, begblock, endblock)

% Here are the possible values of the data format long:
% DFORM_FLOAT     0
% DFORM_LONG      1
% DFORM_SHORT     2
% DFORM_BYTE      3
% DFORM_DOUBLE    4
% DFORM_QWORD     5

if nargin<2 || isempty(begblock)
  begblock = 1;
end

if nargin<3 || isempty(endblock)
  endblock = inf;
end

fid = fopen(filename, 'rb');
offset = (begblock-1)*40; % bytes
fseek(fid, offset, 'cof');
buf = fread(fid, [40, (endblock-begblock+1)], 'uint8=>uint8');
fclose(fid);

buf_size      = buf(1:4,:);
buf_type      = buf(5:8,:);
buf_code      = buf(9:12,:);
buf_channel   = buf(13:14,:);
buf_sortcode  = buf(15:16,:);
buf_timestamp = buf(17:24,:);
buf_offset    = buf(25:32,:);
buf_format    = buf(33:36,:);
buf_frequency = buf(37:40,:);

tsq_size       = typecast(buf_size     (:), 'int32');
tsq_type       = typecast(buf_type     (:), 'int32');
tsq_code       = typecast(buf_code     (:), 'int32'); % this can sometimes be interpreted as 4 chars
tsq_channel    = typecast(buf_channel  (:), 'int16');
tsq_sortcode   = typecast(buf_sortcode (:), 'int16');
tsq_timestamp  = typecast(buf_timestamp(:), 'double');
tsq_offset     = typecast(buf_offset   (:), 'int64');  % or double
tsq_format     = typecast(buf_format   (:), 'int32');
tsq_frequency  = typecast(buf_frequency(:), 'single');

tsq = struct(  'size'      , num2cell(tsq_size      ), ... 
               'type'      , num2cell(tsq_type      ), ... 
               'code'      , num2cell(tsq_code      ), ... 
               'channel'   , num2cell(tsq_channel   ), ... 
               'sortcode'  , num2cell(tsq_sortcode  ), ... 
               'timestamp' , num2cell(tsq_timestamp ), ... 
               'offset'    , num2cell(tsq_offset    ), ... 
               'format'    , num2cell(tsq_format    ), ... 
               'frequency' , num2cell(tsq_frequency ));

