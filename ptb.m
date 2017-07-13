function boards = ptb(boards,task)

switch task
    case 'start'
        ID = max(Screen('Screens'));
        [boards.ptb.w boards.ptb.rect] = Screen('OpenWindow',ID);%,[],[0 0 100 100]);
        boards.ptb.xc = boards.ptb.rect(3)/2;
        boards.ptb.yc = boards.ptb.rect(4)/2;
        boards.ptb.flag = imresize(imread('flag.jpg'),20/300);
end

%do this for ALL tasks
sz = 20;
xlen   = sz*boards.width;
ylen   = sz*boards.height;
xstart = boards.ptb.xc - xlen/2;
ystart = boards.ptb.yc - ylen/2;
xend   = boards.ptb.xc + xlen/2;
yend   = boards.ptb.yc + ylen/2;

%draw grid
for v = 1:boards.width+1
    Screen('DrawLine',boards.ptb.w,100,xstart+sz*(v-1), ystart,...
                                       xstart+sz*(v-1), yend)
end
for h = 1:boards.height+1
    Screen('DrawLine',boards.ptb.w,100,xstart, ystart+sz*(h-1),...
                                       xend,   ystart+sz*(h-1))
end

switch task
    case 'update'
        %add greys for zeros and numbers
        [row col] = find(0 <= boards.user_board & boards.user_board <= 8);
        for ind = 1:length(row)
            loc = [xstart+sz*(col(ind)-1)   ystart+sz*(row(ind)-1) ...
                   xstart+sz*(col(ind))     ystart+sz*(row(ind))];
            Screen('FillRect',boards.ptb.w,225,loc);
            num = boards.user_board(row(ind),col(ind));
            if num > 0 % it's a number
                Screen('DrawText',boards.ptb.w,num2str(num),loc(1),loc(2),0);
            end
        end
        
        %add flags
        [row col] = find(boards.user_board == 666);
        flg = Screen('MakeTexture',boards.ptb.w,boards.ptb.flag);
        for ind = 1:length(row)
            loc = [xstart+sz*(col(ind)-1)   ystart+sz*(row(ind)-1) ...
                   xstart+sz*(col(ind))     ystart+sz*(row(ind))];
            Screen('DrawTexture',boards.ptb.w,flg,[],loc);
        end
end

switch task
    case 'won'
        won = 'Computer won!';
        won_len = Screen('TextBounds',boards.ptb.w,won);
        Screen('DrawText',boards.ptb.w,won,...
            boards.ptb.xc-won_len(3)/2,boards.ptb.yc/10);
    case 'lost'
        lost = 'Computer lost...';
        lost_len = Screen('TextBounds',boards.ptb.w,lost);
        Screen('DrawText',boards.ptb.w,lost,...
            boards.ptb.xc-lost_len(3)/2,boards.ptb.yc/10);
end

[~,~,keyCode] = KbCheck;
if keyCode(KbName('p'))
    paused = 'Paused. Press any key to continue.';
    paused_len = Screen('TextBounds',boards.ptb.w,paused);
    Screen('DrawText',boards.ptb.w,paused,...
        boards.ptb.xc-paused_len(3)/2,boards.ptb.yc*19/10);
    Screen('Flip',boards.ptb.w);
    WaitSecs(1);
    KbWait;
end

Screen('Flip',boards.ptb.w,[],1);

