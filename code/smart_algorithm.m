function boards = smart_algorithm(boards)

%get the real clues that are on the user board
[row col] = find(1 <= boards.user_board & boards.user_board <= 8);
for ind = length(row):-1:1
    boards = task_engine(boards,'reset surrounds',row(ind),col(ind));
    boards = surround_processing_engine(boards,row(ind),col(ind),'surround');
    boards.surroundings_info.unaccounted_mines =... %calc unaccounted mines
            boards.surroundings_info.surrounding_mines -...
            boards.surroundings_info.accounted_mines;
    if boards.surroundings_info.unaccounted_mines == 0
        %delete it if its surroudings are complete
        row(ind) = []; col(ind) = [];
    end
end

% scroll through spots that have clues and unknowns adjacent
for ind = 1:length(row)
    %get the adjacent spots within 2 away
    adj_ind = abs(row(ind) - row) <= 2 & abs(col(ind) - col) <= 2 & ...
        ~(row(ind) == row & col(ind) == col);
    adj = [row(adj_ind) col(adj_ind)]; %row,cols of adj spots
    %check (non)overlapping unknowns
    boards = task_engine(boards,'reset surrounds',row(ind),col(ind));
    boards = surround_processing_engine(boards,row(ind),col(ind),'surround');
    spotA = boards.surroundings_info;
    spotA.unaccounted_mines = spotA.surrounding_mines - spotA.accounted_mines;
    for comp = 1:size(adj,1)
        boards = task_engine(boards,'reset surrounds',adj(comp,1),adj(comp,2));
        boards = surround_processing_engine(boards,adj(comp,1),adj(comp,2),'surround');
        spotB = boards.surroundings_info;
        spotB.unaccounted_mines = spotB.surrounding_mines - spotB.accounted_mines;
        unaccounted_dif = spotA.unaccounted_mines - spotB.unaccounted_mines;
        non_overlapping_A = find_non_overlapping(spotA,spotB);
        non_overlapping_B = find_non_overlapping(spotB,spotA);
        boards = compare_adjacent(boards,unaccounted_dif,...
            non_overlapping_A,non_overlapping_B);
    end
end

function non_overlapping_1 = find_non_overlapping(spot1,spot2)

non_overlapping_1 = [];
for unknown1 = 1:size(spot1.unknowns_array,1)
    overlapping = 0;
    for unknown2 = 1:size(spot2.unknowns_array,1)
        if all(spot1.unknowns_array(unknown1,:) ==...
                spot2.unknowns_array(unknown2,:))
            overlapping = 1;
            break
        end
    end
    if ~overlapping
        non_overlapping_1(end+1,:) = spot1.unknowns_array(unknown1,:); %#ok<AGROW>
    end
end
