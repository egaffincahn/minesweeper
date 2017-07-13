function boards = update_probabilities(boards)

%if user board is 0, prob map is 0
boards.prob_map(~boards.user_board) = 0;

%if user board is mine, prob map is 1
boards.prob_map(boards.user_board==666) = 1;

%if user board is 1-8, do some calculations:
[row col] = find(1<=boards.user_board & boards.user_board<=8);
for ind = 1:length(row)
    %has to call both because it needs to add up ALL the
    %surrounding spots (first call) before developing the probs
    %for placing in empty spots (second call)
    boards = task_engine(boards,'reset surrounds',row(ind),col(ind));
    boards = surround_processing_engine(boards,row(ind),col(ind),'surround');
    if ~isempty(boards.surroundings_info.unknowns_array)
        %there are surrounding unknowns, otherwise spot remains prob = 0;
        boards.surroundings_info.unaccounted_mines =... %calc unaccounted mines
            boards.surroundings_info.surrounding_mines -...
            boards.surroundings_info.accounted_mines;
        boards.surroundings_info.probability =... %calc probs of empty spaces
            boards.surroundings_info.unaccounted_mines /...
            size(boards.surroundings_info.unknowns_array,1);
        boards = surround_processing_engine(boards,row(ind),col(ind),'probabilities');
    end
end
