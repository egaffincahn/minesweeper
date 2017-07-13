% Essentially, this function is clicking a spot on the board to see what
% clue or mine it has.

function [boards endvar] = process_spot(boards,row,col)

endvar = 0;
spot_clue = boards.clue_board(row,col);

%0 mines adjacent, which means you have to open it up. Engine doesn't open
%them, just adds them to cue.
if spot_clue == 0
    boards.user_board(row,col) = 0;
    boards.prob_map(row,col) = 0;
    boards = surround_processing_engine(boards,row,col,'empties');
    
elseif spot_clue == 666 %MINE!
    boards.user_board(row,col) = spot_clue;
    disp('Computer lost!')
    endvar = -1;
    boards = ptb(boards,'lost');
    return
    
else %between 1 and 8 mines surrounding the spot
    boards.user_board(row,col) = spot_clue;
    boards.prob_map(row,col) = 0;
end

boards.process_cue(1,:) = []; %remove spot from the cue

if any(any(boards.user_board == -1))
    boards = update_probabilities(boards);
else
    endvar = 1;
end
