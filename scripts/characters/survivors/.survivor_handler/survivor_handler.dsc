survivor_hit:
    type: task
    debug: false
    definitions: target
    script:
        - flag <[target]> blockout.game.survivor.hits:+:1
        - adjust <[target]> play_hurt_animation:0
        - if <[target].flag[blockout.game.survivor.hits]> == 1:
            - cast speed amplifier:4 duration:4s <[target]> no_icon hide_particles

        - while <[target].flag[blockout.game.survivor.hits]> == 1:
            - cast slow amplifier:0 d:0.8s <[target]> no_icon hide_particles
            - playeffect effect:block_crumble special_data:<map[material=red_concrete]> <[target].location.above[0.15]> offset:0.25 quantity:5
            - wait 1s

        - if <[target].flag[blockout.game.survivor.hits]> >= 2:
            - flag <[target]> blockout.game.survivor.knocked
            - flag <[target]> blockout.game.survivor.hits:0
            - while <[target].has_flag[blockout.game.survivor.knocked]> && <[target].is_online>:
                - define loc <[target].location.above[1]>
                - flag <[loc]> knocked_player expire:2t
                - flag <[loc]> pickup:<[target]> expire:1t

                - if <[loop_index].mod[10]> == 0:
                    - if <[target].flag[blockout.game.survivor.recover].if_null[0].is_more_than_or_equal_to[95]>:
                        - run update_recover_bar def:0|<[target]>
                    - else:
                        - run update_recover_bar def:1|<[target]>

                - if <[loc].material.name> == air:
                    - adjust <[target]> noclip:false
                    - modifyblock barrier <[loc]>
                    - wait 1t
                    - modifyblock air <[loc]>
                - else:
                    - wait 1t

                # - adjust <[target]> swimming:true


update_recover_bar:
    type: task
    debug: false
    definitions: amount|survivor
    script:
        - flag <[survivor]> blockout.game.survivor.recover:+:<[amount]>
        - if <[survivor].flag[blockout.game.survivor.recover]> >= 103:
            - flag <[survivor]> blockout.game.survivor.knocked:!
            - flag <[survivor]> blockout.game.survivor.hits:1
            - flag <[survivor]> blockout.game.survivor.recover:!
            - stop
        - if <[survivor].flag[blockout.game.survivor.recover]> <= 0:
            - flag <[survivor]> blockout.game.survivor.recover:0

        - define repairing_ui <&chr[a003].font[bars]><&translate[space.33].font[space:default]>
        - define fillerChar <&translate[space.-1].font[space:default]><&chr[a010].font[bars]>

        - define fillerAmount <[survivor].flag[blockout.game.survivor.recover]>
        - define fillerWidth 26
        - define totalWidth 214
        - define defaultFillerPos 0
        - define defaultFillerBuffer <&translate[space.<[defaultFillerPos]>].font[space:default]>
        - define fillerCharNew <[fillerChar].repeat[<[fillerAmount]>]>

        - actionbar <&translate[space.<[fillerAmount].mul[2]>].font[space:default]><[repairing_ui]><&translate[space.-<[totalWidth].add[<[fillerWidth]>]>].font[space:default]><[defaultFillerBuffer]><[fillerCharNew]><&translate[space.-<[fillerWidth].add[<[defaultFillerPos]>]>].font[space:default]><&translate[space.<[totalWidth].add[<[fillerWidth]>]>].font[space:default]> targets:<[survivor]>

recover_fail:
    type: task
    debug: false
    definitions: player|target
    script:
        - run update_recover_bar def:-10|<[target]>
        - playeffect effect:block_crumble special_data:<map[material=red_concrete]> <[target].location.above[0.15]> offset:0.25 quantity:25
        - flag <[player]> blockout.skill_check:!
        - mount <[player]> cancel
        - bmmodel entity:<[player]> remove

recover_handler:
    type: task
    debug: false
    definitions: player | target
    script:
        - if <[target].has_flag[blockout.game.survivor.knocked]>:
            - spawn item_display[item=air] <[player].location> save:seat

            - bmmodel entity:<[player]> model:blockout_anims
            - bmstate model:blockout_anims state:generator_fix entity:<[player]> loop:loop
            - mount <[player]>|<entry[seat].spawned_entity>

            - flag <[player]> blockout.game.survivor.recovering_target:<[target]>

            - while <[player].has_flag[blockout.game.survivor.recovering_target]> && <[target].has_flag[blockout.game.survivor.knocked]>:
                - run update_recover_bar def:3|<[target]>
                - cast slow <[target]> amplifier:255 d:10t no_icon hide_particles
                - wait 10t
            - bmmodel entity:<[player]> remove model:blockout_anims
            - mount <[player]> cancel
            - flag <[player]> blockout.game.survivor.recovering_target:!

update_heal_bar:
    type: task
    debug: false
    definitions: amount|healed|healer
    script:
        - flag <[healed]> blockout.game.survivor.heal.progress:+:<[amount]>
        - if <[healed].flag[blockout.game.survivor.heal.progress]> >= 103:
            - flag <[healed]> blockout.game.survivor.hits:0
            - flag <[healed]> blockout.game.survivor.heal.progress:!
            - stop
        - if <[healed].flag[blockout.game.survivor.heal.progress]> <= 0:
            - flag <[healed]> blockout.game.survivor.heal.progress:0

        - define healed_ui <&chr[a005].font[bars]><&translate[space.33].font[space:default]>
        - define healer_ui <&chr[a004].font[bars]><&translate[space.33].font[space:default]>
        - define fillerChar <&translate[space.-1].font[space:default]><&chr[a010].font[bars]>

        - define fillerAmount <[healed].flag[blockout.game.survivor.heal.progress]>
        - define fillerWidth 26
        - define totalWidth 214
        - define defaultFillerPos 0
        - define defaultFillerBuffer <&translate[space.<[defaultFillerPos]>].font[space:default]>
        - define fillerCharNew <[fillerChar].repeat[<[fillerAmount]>]>

        - actionbar <&translate[space.<[fillerAmount].mul[2]>].font[space:default]><[healed_ui]><&translate[space.-<[totalWidth].add[<[fillerWidth]>]>].font[space:default]><[defaultFillerBuffer]><[fillerCharNew]><&translate[space.-<[fillerWidth].add[<[defaultFillerPos]>]>].font[space:default]><&translate[space.<[totalWidth].add[<[fillerWidth]>]>].font[space:default]> targets:<[healed]>

        - actionbar <&translate[space.<[fillerAmount].mul[2]>].font[space:default]><[healer_ui]><&translate[space.-<[totalWidth].add[<[fillerWidth]>]>].font[space:default]><[defaultFillerBuffer]><[fillerCharNew]><&translate[space.-<[fillerWidth].add[<[defaultFillerPos]>]>].font[space:default]><&translate[space.<[totalWidth].add[<[fillerWidth]>]>].font[space:default]> targets:<[healer]>

heal_handler:
    type: task
    debug: false
    definitions: player | target
    script:
        - if <[target].flag[blockout.game.survivor.hits]> == 1:
            - spawn item_display[item=air] <[player].location.above[0.5]> save:seat1
            - spawn item_display[item=air] <[target].location.above[0.5]> save:seat2

            - bmmodel entity:<[player]> model:blockout_anims
            - bmstate model:blockout_anims state:generator_fix entity:<[player]> loop:loop
            - bmmodel entity:<[target]> model:blockout_anims
            - bmstate model:blockout_anims state:sneak entity:<[target]> loop:hold
            - mount <[player]>|<entry[seat1].spawned_entity>
            - mount <[target]>|<entry[seat2].spawned_entity>

            - flag <[player]> blockout.game.survivor.heal.healing_target:<[target]>
            - flag <[target]> blockout.game.survivor.heal.being_healed:<[player]>


            - while <[player].has_flag[blockout.game.survivor.heal]> && <[target].flag[blockout.game.survivor.hits].equals[1]>:
                - if <util.random_chance[1]>:
                    - ~run skill_check
                - else if <player.has_flag[blockout.skill_check.fail]>:
                    - run heal_fail def:<[player]>|<[target]>
                    - flag <player> blockout.skill_check:!
                    - stop
                - run update_heal_bar def:3|<[target]>|<[player]>

                - cast slow <[target]> amplifier:255 d:10t no_icon hide_particles
                - wait 5t
            - inject heal_fail
heal_fail:
    type: task
    debug: false
    definitions: player | target
    script:
        - mount <[player]> cancel
        - flag <[player]> blockout.game.survivor.heal:!
        - bmmodel entity:<[player]> remove model:blockout_anims
        - mount <[target]> cancel
        - flag <[target]> blockout.game.survivor.heal:!
        - bmmodel entity:<[target]> remove model:blockout_anims
        - actionbar targets:<[target]> " "
        - actionbar targets:<[player]> " "
        - title targets:<[player]> title:<empty>

survivor_handler:
    type: world
    debug: false
    events:
        on player right clicks block location_flagged:pickup flagged:blockout.team.survivor:
            - ratelimit <player> 10t
            - define player <context.location.flag[pickup]>
            - run recover_handler def:<player>|<[player]>
        on player right clicks player flagged:blockout.team.survivor:
            - ratelimit <player> 10t
            - define target <context.entity>
            - run heal_handler def:<player>|<[target]>
            - run recover_handler def:<player>|<[target]>


        on player input flagged:blockout.game.survivor.recovering_target:
            - define target <player.flag[blockout.game.survivor.recovering_target]>
            - if <context.forward> || <context.backward> || <context.left> || <context.right> || <context.sneak>:
                - mount <player> cancel
                - flag <player> blockout.game.survivor.recovering_target:!
                - bmmodel entity:<player> remove model:blockout_anims
                - cast slow remove <[target]>

        on player input flagged:blockout.game.survivor.heal:
            - if <player.has_flag[blockout.game.survivor.heal.healing_target]>:
                - define target <player.flag[blockout.game.survivor.heal.healing_target]>

                - if <context.forward> || <context.backward> || <context.left> || <context.right> || <context.sneak>:
                    - if <player.has_flag[blockout.skill_check]>:
                        - run heal_fail def:<player>|<[target]>
                        - run update_heal_bar def:-10|<player>|<[target]>
                        - playeffect effect:block_crumble special_data:<map[material=red_concrete]> <[target].location.above[0.15]> offset:0.25 quantity:25
                        - playsound sound:entity.zombie.break_wooden_door pitch:0.4 volume:0.5 <player.location>
                        - playsound sound:entity.villager.no <player>
                        - flag <player> blockout.skill_check:!
                        - stop
                    - run heal_fail def:<player>|<[target]>
                - else if <context.jump> && <player.has_flag[blockout.skill_check]>:
                    - ratelimit <player> 1s
                    - define data <script[skill_check_points].data_key[check_points].get[<player.flag[blockout.skill_check.check]>]>
                    - define error 3
                    - define base_range_min <[data.base.min].sub[<[error]>]>
                    - define base_range_max <[data.base.max].add[<[error]>]>

                    - define crit_range_min <[data.crit.min].sub[<[error]>]>
                    - define crit_range_max <[data.crit.max].add[<[error]>]>
                    - define value <player.flag[blockout.skill_check.value]>

                    - if <[value]> < <[crit_range_max]>  && <[value]> > <[crit_range_min]>:
                        - flag <player> blockout.skill_check:!
                        - run update_heal_bar def:10|<player>|<[target]>
                        - playsound sound:entity.experience_orb.pickup <player> pitch:1.5
                        - playsound sound:entity.zombie.break_wooden_door <player> pitch:2
                    - else if <[value]> < <[base_range_max]>  && <[value]> > <[base_range_min]>:
                        - flag <player> blockout.skill_check:!
                        - run update_heal_bar def:3|<player>|<[target]>
                        - playsound sound:entity.experience_orb.pickup <player>
                    - else:
                        - run heal_fail def:<player>|<[target]>
                        - run update_heal_bar def:-10|<player>|<[target]>
                        - playeffect effect:block_crumble special_data:<map[material=red_concrete]> <[target].location.above[0.15]> offset:0.25 quantity:25
                        - playsound sound:entity.villager.no <player>
                        - flag <player> blockout.skill_check:!
                    - determine cancelled

                - else:
                    - determine passively cancelled
            - else:
                - if <context.forward> || <context.backward> || <context.left> || <context.right> || <context.sneak>:
                    - run heal_fail def:<player>|<[target]>
