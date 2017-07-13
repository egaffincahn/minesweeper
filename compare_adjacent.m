function boards = compare_adjacent(boards,m,a,b)

% m = difference in unaccounted mines a-b
% a = non-shared spots with b
% b = non-shared spots with a

if ~isempty(a)
    lenA = length(a(:,1));
end
if ~isempty(b)
    lenB = length(b(:,1));
end

if     m < 0 && isempty(a) && isempty(b)
    disp('Error: m, a, b combination not possible.')
    
elseif m < 0 && isempty(a) && lenB > 0
    if m == length(b(:,1))
        boards = process_non_overlapping(boards,b,'mines');
    end
    
elseif m < 0 && lenA > 0 && isempty(b)
    disp('Error: m, a, b combination not possible.')
    
elseif m < 0 && lenA > 0 && lenB > 0
    if m == length(b(:,1))
        boards = process_non_overlapping(boards,a,'process');
        boards = process_non_overlapping(boards,b,'mines');
    end
    
elseif m == 0 && isempty(a) && isempty(b)
    %no move
    
elseif m == 0 && isempty(a) && lenB > 0
    boards = process_non_overlapping(boards,b,'process');
    
elseif m == 0 && lenA > 0 && isempty(b)
    boards = process_non_overlapping(boards,a,'process');
    
elseif m == 0 && lenA > 0 && lenB > 0
    %no move
    
elseif m > 0 && isempty(a) && isempty(b)
    disp('Error: m, a, b combination not possible.')
    
elseif m > 0 && isempty(a) && lenB > 0
    disp('Error: m, a, b combination not possible.')
    
elseif m > 0 && lenA > 0 && isempty(b)
    if m == length(a(:,1))
        boards = process_non_overlapping(boards,a,'mines');
    end
    
elseif m > 0 && lenA > 0 && lenB > 0 %%%% m>0
    if m == length(a(:,1))
        boards = process_non_overlapping(boards,b,'process');
        boards = process_non_overlapping(boards,a,'mines');
    end
end

function boards = process_non_overlapping(boards,spot,task)

for spot_index = 1:length(spot(:,1))
    row = spot(spot_index,1);
    col = spot(spot_index,2);
    switch task
        case 'process'
            boards = task_engine(boards,'processing cue',row,col);
        case 'mines'
            boards.user_board(row,col) = 666;
    end
end