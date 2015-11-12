editable('random_hold_mintime','random_hold_maxtime','release_time','num_rewards','reward_dur');

% timing
wait_for_touch = 5000;
hold_before_dot = 500;
rand_before_dot = 0;
wait_for_fix = 1000;
require_fix = 100;
rand_require_fix = 0;
before_dot_time = ceil(hold_before_dot + rand()*rand_before_dot);
fix_time = ceil(require_fix + rand()*rand_require_fix);

% other
fix_window_rad = 3;

% objects
fix_spot = 1;

% reward
num_rewards = 1;
reward_dur = 120;

% codes
fix_on = 35;
fix_off = 36;

correct = 0;
broke_fix = 3;
no_lever = 1;
broke_lever = 5;

hotkey('r', 'goodmonkey(100);');

[ontarget, rt] = eyejoytrack('acquiretouch', [1], [3.0], wait_for_touch);
if ~ontarget,
    toggleobject(fix_spot, 'eventmarket', fix_off);
    trialerror(no_lever); %no touch
    rt=NaN;
    return
end

toggleobject(fix_spot, 'eventmarker', fix_on);
[ontarget, rt] = eyejoytrack('acquirefix', [1], [fix_window_rad], 'holdtouch', [1], [3.0], wait_for_fix);
if ~ontarget(1)
    toggleobject(fix_spot, 'eventmarket', fix_off);
    trialerror(no_fix);
    rt = NaN;
    return
end
if ~ontarget(2),
    toggleobject(fix_spot, 'eventmarket', fix_off);
    trialerror(broke_lever);
    rt = NaN;
    return
end

[ontarget, rt] = eyejoytrack('holdfix', [1], [fix_window_rad], ...
                             'holdtouch', [1], [3.0]);
if ~ontarget(1),
    toggleobject(fix_spot, 'eventmarket', fix_off);
    trialerror(broke_fix);
    rt = NaN;
    return
end
if ~ontarget(2),
    toggleobject(fix_spot, 'eventmarket', fix_off);
    trialerror(broke_lever);
    rt = NaN;
    return
end

trialerror(correct);
toggleobject(fix_spot, 'eventmarket', fix_off);
goodmonkey(reward_dur);
eventmarker(reward_given);