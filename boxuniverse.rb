use_bpm 120
use_osc "localhost", 47120


chords = ring(
  chord(:e4, :m), chord(:g4, :major), chord(:c4, :major), chord(:a3, :minor),
  chord(:e4, :m), chord(:a4, :m), chord(:b4, :major), chord(:e4, :major),
)

lpfc =40
hpfc = -100
hpfo = lpfo = 12/2



hhsl = 1
bamp=0
pamp=0
camp=0

with_fx :rlpf, cutoff:[[lpfc, 130].min,0].max, res: 0.1 do |lpf|
  with_fx :rhpf, cutoff:[[hpfc, 130].min,0].max do |hpf|
    
    live_loop :m do
      ch=chords.stretch(4).tick
      
      
      4.times do |i|
        n=ch[i]
        
        if (i==0) then
          osc "/melo", n
          synth :saw, release:1.5, note:n-24, amp:1.4
          synth :chiplead, attack:0, width:2, release:2, note:n+24, amp:0.8*camp
        else
          synth :blade, release: 1, sustain:1, note:n
          synth :pluck, note:n
        end
        sleep 1.0/4
      end
    end
    
    
    
    live_loop :in do
      lpfc=lpfc+lpfo
      hpfc=hpfc+hpfo
      control lpf, cutoff:[[lpfc, 130].min,0].max
      control hpf, cutoff:[[hpfc, 130].min,0].max
      sleep 1
    end
    
    live_loop :hh do
      sample :drum_cymbal_closed, amp: 2
      sleep hhsl
    end
    
    live_loop :pad do
      chords.each do |ch|
        [ch[0], ch[1], ch[2], ch[0]-12].each do |n|
          synth :blade, attack:1, release:6, note:n-12, amp:1*pamp
          synth :growl, attack:2, release:6, note:n+12, amp:0.5*pamp
        end
        sleep 4
      end
    end
    
  end
end


live_loop :k do
  with_fx :distortion, distort:0.8 do
    sample :drum_heavy_kick, amp: bamp*2.3
  end
  4.times do
    sample :drum_heavy_kick, amp: bamp*2
    sleep 1
  end
end

live_loop :s do
  sleep 1
  sample :drum_snare_soft, amp: bamp*3
  sleep 1
end


beatupdate=true
live_loop :snc do
  osc "/stat", lpfc, hpfc, bamp, pamp
  4.times do |i|
    if beatupdate then osc "/beat", i end
    sleep 1
  end
end


sec=4*4*2

sleep sec
hpfo = lpfo=0
lpfc=130
hpfc=0
bamp=1

sleep sec
pamp = 1
hhsl *=0.5

sleep sec
hhsl *=0.5
camp=1

sleep sec
lpfo = -6
bamp=0
beatupdate=false







