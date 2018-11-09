function boards = make_boards(difficulty)

%mine_board (double)
switch lower(difficulty)
    case 'easy'
        width = 9;
        height = 9;
        mines = 10;
    case 'medium'
        width = 16;
        height = 16;
        mines = 40;
    case 'hard'
        width = 25;
        height = 25;
        mines = 120;
    case 'custom'
        fprintf('EASY:   9x9 with 10 mines.\n');
        fprintf('MEDIUM: 16x16 with 40 mines.\n');
        fprintf('HARD:   25x25 with 120 mines.\n');
        width = input('How many spaces wide should the board be? ');
        height = input('How many spaces high should the board be? ');
        area = int2str(width*height);
        %max mines is 1 mine per spot
        mines_text = sprintf('How many mines should the board have? Maximum is %s. ',area);
        mines = input(mines_text);
end

boards = task_engine([],'possible probs');

%user board: unknown = -1; mine = 666; known clue = clueboard
%prob map: unknown = -1; known = probability
boards.user_board = (-1)*ones(width,height);
boards.prob_map = (-1)*ones(width,height);
boards.width = width;
boards.height = height;
boards.mines = mines;
boards.process_cue = [];

%creates the list of mine locations, randomizes it, and places it in array
list_spots = randperm(width*height);
for int = 1:length(list_spots)
    if list_spots(int) <= mines
        list_spots(int) = 1;
    else
        list_spots(int) = 0;
    end
end
boards.mine_board = reshape(list_spots,width,height);
%clue_board: mine = 666; known = surrounding mines
boards.clue_board = zeros(width,height);
boards.clue_board(boards.mine_board==1) = 666;
for row = 1:height
    for col = 1:width
        if boards.clue_board(row,col) == 0
            boards.temp_surrounding_mines = 0;
            boards = surround_processing_engine(boards,row,col,'create');
            if boards.temp_surrounding_mines %puts value in, otherwise leaves as 0
                boards.clue_board(row,col) = boards.temp_surrounding_mines;
            end
        end
    end
end

