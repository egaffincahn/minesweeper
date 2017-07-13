function boards = task_engine(boards,task,row,col)

switch task
    case 'possible probs'
        boards.possible_probs = [];
        for mine = 1:7
            for space = 2:8
                if mine < space; boards.possible_probs(end+1) = mine/space; end
            end
        end
        
    case 'first play'
        first_spot = randi(numel(boards.user_board));
        [row col] = ind2sub(size(boards.user_board),first_spot);
        boards.process_cue = [row col];
        
    case 'reset surrounds'
        %reset surrounding spot information
        boards.prob_map(row,col) = 0;
        boards.surroundings_info.accounted_mines = 0;
        boards.surroundings_info.unaccounted_mines = [];
        boards.surroundings_info.knowns_array = [];
        boards.surroundings_info.unknowns_array = [];
        boards.surroundings_info.surrounding_mines = boards.user_board(row,col);
        
    case 'processing cue'
        if ~isempty(boards.process_cue)
            add = 1;
            for i = 1:length(boards.process_cue(:,1))
                if all(boards.process_cue(i,:) == [row col])
                    add = 0; break %already in cue
                end
            end
            %add to top of cue (depth first) but in 2nd position b/c 1st
            %position is going to be deleted
            if add
                boards.process_cue(3:end+1,:) = boards.process_cue(2:end,:);
                boards.process_cue(2,:) = [row,col];
            end
        else
            boards.process_cue = [row,col];
        end        
end

