
use_bpm 140
use_sample_pack "./"

live_loop :c do
  sleep 8
end


live_loop :l do
  with_fx :reverb, room:0.4 do
    with_fx :slicer, phase: 1, pulse_width: 1.0/2 do
      sync :c
      sample "loop", beat_stretch: 16, amp:5
      sleep 2
      #sample "loop", beat_stretch: 16, amp:2
      sleep 2
      #sample "loop", beat_stretch: 16, amp:2
      sleep 2
      #sample "loop", beat_stretch: 16, amp:2
      sleep 10
      # end
    end
  end
end

live_loop :dr do
  sync :c
  sample "dr", beat_stretch: 8, amp:7
  sleep 2
  #sample "dr", beat_stretch: 8, amp:5
  sleep 2
  #sample "dr", beat_stretch: 8, amp:5
  sleep 2
  #sample "dr", beat_stretch: 8, amp:4
  sleep 2
  
end


live_loop :hh do
  use_synth :noise
  sync :c
  (16*4).times do
    play :c, release:0.25/2, amp: 1.4*rrand(0.8, 1.2) * ring(1, 0.3, 0.5, 0.2).tick
    sleep 2.0/16
  end
end

live_loop :ttt do
  use_synth :pluck
  
  with_fx :reverb, room:0.8 do
    sync :c
    (16*4*8).times do |i|
      play :g+rrand(0.85, 1.15), release: 0.25, amp: 4.5*rrand(0.7, 1.4) * ring(1, 0.2, 0.4, 0.2).tick
      sleep 2.0/16
    end
  end
end

live_loop :kk do
  with_fx :band_eq, freq:70, res:0.05, db:15, pre_amp:0.4 do
    sync :c
    sample "kk", amp:5, rate: rrand(0.85, 1.15)
    sleep 32
  end
end
