use_random_seed Time.now.usec #more random

use_bpm 60


hh1 = ring(1,0,1,0, 1,1,1,0, 0,1,0,1, 1,1,1,0,)
k = ring(1,0,0,0, 0.6,0,0,0, 0,0,0,0, 0,0,0,0,)
s = ring(0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,)

live_loop :b do
  tick
  synth :cnoise, release:0.03, cutoff: :d7, amp: rrand(1.2, 2)*hh1.look*[1,1,1,0].choose
  synth :cnoise, release:0.3, cutoff: :d6, amp: 2*s.look
  synth :sine, note: :d2, release:0.5, amp: 7*k.look
  synth :bnoise, release:0.15, cutoff: :d4, amp: 7*k.look
  sleep 1.0/4
end

live_loop :amb do
  with_fx :gverb, room:40 do
    notes = (scale :d2, :minor, num_octaves: 3).shuffle
    sn = synth :dark_ambience , sustain:4, amp:2
    control sn, note: notes.tick
    sleep 1
  end
end

hmelamp = 0
live_loop :hmel do
  hmel = (scale :d5, :minor, num_octaves: 2).stretch(2).shuffle.take(2).sort
  32.times do
    n=hmel.tick
    play synth :fm, sustain:0, release:0.1, amp:1.5*hmelamp, note: n
    sleep 0.25
    play synth :dsaw, sustain:0, release:0.7, amp:1.5*hmelamp, note: n-24
    sleep 0.25
  end
end



div=0.1
dep=0
amp=0

notes = (scale :d4, :minor, num_octaves: 2).stretch(2).shuffle.take(4).sort

live_loop :mel do
  with_fx :compressor, threshold: 0.6, amp:0.6 do
    with_fx :reverb do
      with_fx :distortion, distort: 0.9  do
        with_fx :wobble, phase:4, pulse_width:8 do
          
          with_fx :echo, decay:8, phase:0.5 do
            
            play synth :fm, release:1, amp:amp, divisor: div, depth: dep, note: notes.tick
            sleep [2,4].choose
            div=div+0.002
            if div>0.5 then div = 0.2 end
            dep=dep+0.4
            if dep>30 then dep = 0 end
            amp=amp+0.1
            if amp>3 then amp = 0; hmelamp=1 end
          end
        end
      end
    end
  end
end

coef=1
bs = (scale :d2, :minor, num_octaves: 1).stretch(2).shuffle.take(3).sort.reflect.take(4).stretch(8)
live_loop :bs do
  play synth :pluck, coef:coef, sustain:0, release:0.5, amp:1.3, note: bs.tick
  sleep 0.25
  coef=coef-0.0025
  if coef<0.05 then coef = 0.7 end
end