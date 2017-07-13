function boards = surround_processing_engine(boards,row,col,task)

height = boards.height;
width = boards.width;
boards.surroundings_info.check_index = 1;

%Finds each surrounding location and calls task if the adjacent
%location exists on the board.
%process above
if row ~= 1
    boards = call_task(boards,row-1,col,task);
end
boards.surroundings_info.check_index = boards.surroundings_info.check_index + 1;
%process diag top right
if row ~= 1 && col ~= width
    boards = call_task(boards,row-1,col+1,task);
end
boards.surroundings_info.check_index = boards.surroundings_info.check_index + 1;
%process right
if col ~= width
    boards = call_task(boards,row,col+1,task);
end
boards.surroundings_info.check_index = boards.surroundings_info.check_index + 1;
%process diag bottom right
if row ~= height && col ~= width
    boards = call_task(boards,row+1,col+1,task);
end
boards.surroundings_info.check_index = boards.surroundings_info.check_index + 1;
%process bottom
if row ~= height
    boards = call_task(boards,row+1,col,task);
end
boards.surroundings_info.check_index = boards.surroundings_info.check_index + 1;
%process diag bottom left
if row ~= height && col ~= 1
    boards = call_task(boards,row+1,col-1,task);
end
boards.surroundings_info.check_index = boards.surroundings_info.check_index + 1;
%process left
if col ~= 1
    boards = call_task(boards,row,col-1,task);
end
boards.surroundings_info.check_index = boards.surroundings_info.check_index + 1;
%process diag top left
if row ~= 1 && col ~= 1
    boards = call_task(boards,row-1,col-1,task);
end


%Takes the given adjacent row and column information and
%calls the specific task.
function boards = call_task(boards,row,col,task)

switch task
    case 'create'
        boards = create_clue_board(boards,row,col);
    case 'empties'
        boards = open_empties(boards,row,col);
    case 'surround'
        boards = get_surrounding_info(boards,row,col);
    case 'probabilities'
        boards = write_probabilities(boards,row,col);
end


%functions that can be called by TASK
function boards = create_clue_board(boards,row,col)

if boards.mine_board(row,col) == 1
    boards.temp_surrounding_mines = boards.temp_surrounding_mines + 1;
end


function boards = open_empties(boards,row,col)

if boards.user_board(row,col) == -1 %user board is unknown, open it
    boards = task_engine(boards,'processing cue',row,col);
end


function boards = get_surrounding_info(boards,row,col)

if boards.user_board(row,col) == -1
    boards.surroundings_info.unknowns_array(end+1,:) = [row col];
elseif boards.user_board(row,col) == 666
    boards.surroundings_info.accounted_mines =...
        boards.surroundings_info.accounted_mines + 1;
elseif boards.user_board(row,col) ~= 0 %1-8 surrounding mines and is processed
    boards.surroundings_info.knowns_array(end+1,:) = [row col];
end


function boards = write_probabilities(boards,row,col)

%gives the probability to each surrounding spot that is unknown.
probability = boards.surroundings_info.probability;
add2cue = 0;
if boards.prob_map(row,col) == -1; %hasn't been set yet
    boards.prob_map(row,col) = probability;
    switch probability
        case 0
            add2cue = 1;
        case 1
            boards.user_board(row,col) = 666;
    end
elseif 0 < boards.prob_map(row,col) && boards.prob_map(row,col) < 1
    switch probability
        case 0
            boards.prob_map(row,col) = probability;%%% IS THIS A PROBLEM?
            add2cue = 1;
        case 1
            boards.prob_map(row,col) = probability;
            boards.user_board(row,col) = 666;
        otherwise %between 1 and 0
            boards.prob_map(row,col) = max(boards.prob_map(row,col),probability);
    end
end
if add2cue
    boards = task_engine(boards,'processing cue',row,col);
end