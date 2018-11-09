%the cue to process spots is empty. that means the game is over (won) or
%it's stuck, meaning it's time to use the smart algorithm. If that doesn't
%help, then it's time to guess... so add a spot to the cue.

function [boards endvar] = check_empty_cue(boards)

endvar = 0;
if any(any(boards.user_board == -1))
    boards = smart_algorithm(boards);
    if isempty(boards.process_cue) %time to guess
        if size(find(boards.user_board==666),1) == boards.mines
            %found==total: all unknowns are safe
            [row col] = find(boards.user_board==-1);
            for add = 1:length(row)
                boards = task_engine(boards,'processing cue',row(add),col(add));
            end
        elseif boards.mines - size(find(boards.user_board==666),1) ==...
                size(find(boards.user_board==-1),1)
            %total-found==unknowns: all unknowns are mines
            [row col] = find(boards.user_board==-1);
            for add = 1:length(row)
                boards.user_board(row(add),col(add)) = 666;
            end
        else
            disp('No good moves... time to guess')
            boards = ptb(boards,'guess');
            %stuck with no moves so it's time to guess. pick the spot with the lowest
            %probability of having a mine based on the probmap.
            %get minimum prob on board:
            known_real_probs_index = boards.prob_map > 0;
            known_real_probs = boards.prob_map(known_real_probs_index);
            min_knowns_prob = min(min(known_real_probs));
            %get prob of finding mine in unknown locations (not a great method):
            unknown_prob_map = size(find(boards.prob_map==-1),1);
            if unknown_prob_map == 0 %don't divide by 0
                unknowns_prob = 1;
            else
                accounted_mines = sum(boards.prob_map(boards.prob_map~=-1));
                unaccounted_mines = boards.mines - accounted_mines(end);
                unknowns_prob = unaccounted_mines / unknown_prob_map;
            end
            %get min of all
            min_prob = min([unknowns_prob min_knowns_prob]);
            %guess randomly if you know it's whole-board probability based on
            %its non-adherence to a probability of one single space
            if ~any(min_prob==boards.possible_probs)
                min_prob = -1;
            end
            [row2guess col2guess] = find(boards.prob_map==min_prob);
            ind2guess = randi(length(row2guess));
            boards.process_cue(end+1,:) = [row2guess(ind2guess) col2guess(ind2guess)];
        end
    else %smart alg found some new spots
        boards = update_probabilities(boards);
    end
else
    endvar = 1;
end
