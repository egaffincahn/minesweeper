function run_minesweeper(difficulty)

try
    
    Screen('Preference', 'SkipSyncTests', 1);
    
    boards = make_boards(difficulty);
    boards = task_engine(boards,'first play');
    boards = ptb(boards,'start');
    
    %endvar: unfinished=0; lost=-1; won=1
    endvar = 0;
    while ~endvar
        while ~isempty(boards.process_cue)
            row2process = boards.process_cue(1,1);
            col2process = boards.process_cue(1,2);
            [boards endvar] = process_spot(boards,row2process,col2process);
            boards = ptb(boards,'update');
            if endvar; break; end
        end
        if endvar; break; end
        boards = update_probabilities(boards);
        if isempty(boards.process_cue)
            [boards endvar] = check_empty_cue(boards);
        end
    end
    if endvar==1; disp('WE WON!');
        ptb(boards,'won');
    end
    KbWait;
    sca;
catch err
    sca;
    rethrow(err);
end

