level:setuprooms()

level:setclapsounds(1, 'Classic', 'ClapHitP2', 70, 90, -10, 10, 'ClapHitCPU', 81, 79, 7, 5, 'ClapHit', 62, 84, 2, -50, true, false, true)
-- sets p1's clap sound to 'ClapHitP2', volume to 70%, pitch to 90%, panning to -10% and offset to 10
-- sets p2's clap sound to 'ClapHitCPU', volume to 81%, pitch to 79%, panning to 7% and offset to 5
-- sets cpu's clap sound to 'ClapHit', volume to 62%, pitch to 84%, panning to 2% and offset to -50
-- p1 and cpu are used, so set those to true, but p2 isn't, so set it to false

level:setgamesound(3, 'BigMistake', 'sndShaker', 99, 98, 1)

level:setbeatsound(5, 0, 'Kick', 50, 98, 1)

level:playsound(7, 'sndKickTight', 99, 98, 1, 0, 'CueSound')

level:setbpm(8, 120)

level:cue(9, 'SayReadyGetSetGoNew', 'IanExcited', 99, 1.5)

level:setcountingsound(16, 1, 'JyiCountTired', true, 99)

level:heartexplosioninterval(18, 'GatherNoCeil', 2)