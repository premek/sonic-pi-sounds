# https://soundcloud.com/premek-v/random-song-1
# randomly generated melody and bass


#more random
use_random_seed Time.now.usec

use_bpm 104
ts="trisamples1"


hh1 = ring(1,0,1,0, 1,0,1,0, 0,1,0,1, 1,0,1,0,)
k = ring(1,0,0,0, 0.6,0,0,0, 0,0,0,0, 0,0,0,0,)
s = ring(0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,)
cl = ring(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,)

live_loop :b do
  tick
  with_synth_defaults cutoff: 122 do
    with_synth :cnoise do
      play 1, release:0.07, amp: rrand(0.8, 1.2)*hh1.look
    end
  end
  
  sample ts, "Kick 005 Deep", rate:0.7, amp: 6*k.look
  sample ts, "Snare 007", rate:0.6, amp: 4*s.look
  sample ts,"Clap 009", rate:0.9 ,amp: 2*cl.look
  
  sleep 1.0/4
end

live_loop :mel do
  with_fx :gverb, room:20 do
    notes = (scale :g3, :minor, num_octaves: rrand(1,2)).stretch(2).shuffle
    sn = synth :blade , sustain:rrand(1,4), note: :c1, amp:1.2
    4.times do
      control sn, note: notes.tick
      sleep 1
    end
  end
  
end


live_loop :bs do
  bs = (scale :g3, :minor, num_octaves: 1).stretch(2).shuffle.take(3).sort.reflect.take(4).stretch(8)
  sn = synth :fm , sustain:4*8, note: :c1
  (4*8).times do
    control sn, note: bs.tick
    control sn, amp_slide: 0
    control sn, amp: 1.4
    control sn, amp_slide: 0.5
    control sn, amp: 0
    sleep 0.5
  end
end
