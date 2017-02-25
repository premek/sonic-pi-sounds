# Welcome to Sonic Pi v2.10
#reboot

#more random
use_random_seed Time.now.usec

use_bpm 120

d = "~/zvuk/back"

define :b do |i|
  n = 16
  s = line(0, 1, steps: n)[i]
  f = s + (1.0 / n)
  sample d, :loop, beat_stretch: 8, rate:1, start: s, finish: f, amp:1.5, attack:0, sustain:0, release:0.15
  sleep 0.5
  
end

b1=ring(8,9,14,15,  8,9,10,11)
b2=ring(0,1, 2, 3,   4, 5, 6, 7)
b3=ring(12,15,14,15)

live_loop :sl do
  b b3.tick
end


hh1 = ring(0,0,1,1, 0,0,1,0, 0,0,1,0, 0,1,1,1,)

live_loop :hh do
  tick
  with_synth :cnoise do
    h=hh1.look
    play 1, release:0.1, amp: 1*rrand(0.9, 1.1)*h
    play 1, release:0.1, amp: 0.4*rrand(0.9, 1.1)*(h*-1+1)
  end
  sleep 1.0/4
end

live_loop :z do
  with_synth :pluck do
    with_fx :reverb, room:0.3 do
      t=:d
      play t, release:0.2, amp: 1.5
      sleep 1.0/8
      play t+12, release:0.2, amp: 1.6
    end
  end
  sleep 1.0/8
end

live_loop :vo do
  sync :sl
  sample d, ring(:amaz, :back, :back2, :unb, :wow).choose, rate: 1.05, amp: 1.4
  sleep 16
end


