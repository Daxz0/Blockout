blockout_piglin_killer:
    type: task
    debug: false
    script:
        - definemap character_data:
            ## STEALTH
            # reverse scaling, all killers begin with a 30 block danger radius, each stealth subtracts 1.3*stealth from the 30
            stealth: 2

            ## SPEED
            # speed begins at 0.115 (or l15% the survviros speed), each speed adds an additional 0.05 to the base
            # survivor speed is 0.10
            speed: 4

            ## SWING SPEED
            # cooldown between swings, sounds kinda counterintituative but wtv
            # base stat begins at 2.5 seconds for MISSED SWINGS
            # hit swings base begins at 3 seconds
            # each additional swing speed stat subtracts 0.15 from both bases
            swing_speed: 5



            # hidden stats

            ## RESILIANCE
            # how much slow the killer recieves for attacking
            # base of 2 seconds, subtracts 0.05 every stat
            resiliance: 7



## abilities

# plants flag on downed survivor and hooks them
# charges using tusks


blockout_piglin_disguise:
    type: task
    debug: false
    script:
        - bmmodel entity:<player> model:piglin_killer
        - adjust <player.bm_entity.model.bone[head]> visible:false