%=======================================================================
% 2014-11-22: Guangsha Shi: Extract and historical stock data from
% Yahoo Finance.
% Make sure you have Internet connection!
% This code requires an input file stock_list.dat which is a list
% of all the stocks you are interested in.
%=======================================================================

function [] = extract_yahoo()
clear all
close all

data = construct_price_matrix();
size(data)

save data.mat data

end

function stock_array = read_stock_list()
% The function read_stock_list() reads the file stock_list.dat
% and stores the stock symbols in an array.

fileID = fopen('stock_list.dat');
stock_array = fread(fileID,'*char')';
fclose(fileID);
stock_array = strread(stock_array, '%s', 'delimiter', '\n');

end

function price_relative = construct_price_matrix()
% The function construct_price_matrix() constructs
% the matrix of price relatives of the stocks listed in the
% file stock_list.dat.

stock_array = read_stock_list();
stock_size = size( stock_array, 1 );

price_relative = [];
%day_size = 4996;
day_size = 5023;
%day_size = 2729;
%day_size = 1218;
%day_size = 757;

fileID = fopen('output_stock_list.dat','w');

for i = 1 : stock_size
    i
    name = char( stock_array( i ) )
%    fullURL = strcat( 'http://table.finance.yahoo.com/table.csv?s=', name, '&d=9&e=31&f=2014&g=', 'd', '&a=0&b=1&c=1995&ignore=.csv');
%    fullURL = strcat( 'http://table.finance.yahoo.com/table.csv?s=', name, '&d=9&e=31&f=2014&g=', 'd', '&a=0&b=1&c=2004&ignore=.csv');
%    fullURL = strcat( 'http://table.finance.yahoo.com/table.csv?s=', name, '&d=2&e=10&f=2016&g=', 'd', '&a=0&b=1&c=2012&ignore=.csv');
%    fullURL = strcat( 'http://table.finance.yahoo.com/table.csv?s=', name, '&d=9&e=31&f=2014&g=', 'd', '&a=0&b=1&c=2010&ignore=.csv');
    fullURL = strcat( 'http://table.finance.yahoo.com/table.csv?s=', name, '&d=2&e=10&f=2016&g=', 'd', '&a=0&b=1&c=1995&ignore=.csv');
    str = urlread(fullURL);
    str = strread(str, '%s', 'delimiter', ',');
    size_str = size(str, 1);
    str = reshape( str, [7, size_str / 7] )';
    size_str / 7
    if ( size_str / 7 < day_size )
        continue;
    end
    fprintf( fileID, '%s\n', name );
    price = str2double( str(2:day_size, 7) );
    price = flipud( price );
    price_relative = [ price_relative price(2:(day_size-1))./price(1:(day_size-2)) ];
end

fclose(fileID);

end