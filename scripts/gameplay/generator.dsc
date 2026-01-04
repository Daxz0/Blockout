

generator_detection:
    type: world
    debug: false
    events:
        on player right clicks flagged:!blockout.generator entity_flagged:generator:
            - define generator <context.entity>
            - stop if:<[generator].has_flag[status.disabled]>
            - stop if:<[generator].has_flag[status.completed]>
            - stop if:<[generator].flag[generator.workers].is_more_than_or_equal_to[4]>
            - ratelimit <player> 1s

            - define seat_organized <[generator].flag[seats].sort_by_value[get[seat].location.distance[<player.location>]]>
            - foreach <[seat_organized]> as:data:
                - foreach next if:<[data.seat].has_flag[seater]>

                - flag <[data.seat]> seater:<player>
                - flag <player> blockout.generator.seat:<[data.seat]>
                - flag <player> blockout.generator.entity:<[generator]>

                - bmmodel entity:<player> model:blockout_anims
                - bmstate model:blockout_anims state:generator_fix entity:<player> loop:loop
                - mount <player>|<[data.seat]>
                - flag <[generator]> generator.workers:++
                - foreach stop

            - define base_speed 1.5
            - define base_skill_check_chance 30

            - while <player.has_flag[blockout.generator]>:
                - if <util.random_chance[<[base_skill_check_chance]>]>:
                    - ~run skill_check
                - else if <player.has_flag[blockout.skill_check.fail]>:
                    - run generator_fail
                    - flag <player> blockout.skill_check:!
                    - stop
                - run update_generator_bar def:1|<[generator]>
                - wait <[base_speed]>
        on player input flagged:blockout.generator:
            - define generator <player.flag[blockout.generator.entity].if_null[0]>
            - if <context.forward> || <context.backward> || <context.left> || <context.right> || <context.sneak>:
                - if <player.has_flag[blockout.skill_check]>:
                    - run generator_fail
                    - flag <player> blockout.skill_check:!
                    - stop
                - run exit_generator def:<player>
            - else if <context.jump> && <player.has_flag[blockout.skill_check]>:
                - ratelimit <player> 1s
                - define data <script[skill_check_points].data_key[check_points].get[<player.flag[blockout.skill_check.check]>]>
                - define error 4
                - define base_range_min <[data.base.min].sub[<[error]>]>
                - define base_range_max <[data.base.max].add[<[error]>]>

                - define crit_range_min <[data.crit.min].sub[<[error]>]>
                - define crit_range_max <[data.crit.max].add[<[error]>]>
                - define value <player.flag[blockout.skill_check.value]>

                - if <[value]> < <[crit_range_max]>  && <[value]> > <[crit_range_min]>:
                    - flag <player> blockout.skill_check:!
                    - run update_generator_bar def:3|<[generator]>
                    - playsound sound:entity.experience_orb.pickup <player> pitch:1.5
                    - playsound sound:entity.zombie.break_wooden_door <player> pitch:2
                - else if <[value]> < <[base_range_max]>  && <[value]> > <[base_range_min]>:
                    - flag <player> blockout.skill_check:!
                    - run update_generator_bar def:1|<[generator]>
                    - playsound sound:entity.experience_orb.pickup <player>
                - else:
                    - run generator_fail
                    - playsound sound:entity.villager.no <player>
                    - flag <player> blockout.skill_check:!

            - else:
                - determine passively cancelled

update_generator_bar:
    type: task
    debug: false
    definitions: amount|generator
    script:
        - flag <[generator]> generator.progress:+:<[amount]>
        - if <[generator].flag[generator.progress]> >= 100:
            - flag <[generator]> status.completed
            - megstate state:active model:<[generator].modeled_entity.model>
            - foreach <[generator].flag[seats]> as:data:
                - if <[data.seat].has_flag[seater]>:
                    - run exit_generator def:<[data.seat].flag[seater]>
            - stop
        - if <[generator].flag[generator.progress]> < 0:
            - flag <[generator]> generator.progress:0


        - bossbar auto generator_<[generator].uuid> progress:<[generator].flag[generator.progress].div[100]> color:BLUE title:Repairing...<element[ ].repeat[32]> players:<player>

exit_generator:
    type: task
    debug: false
    definitions: player
    script:
        - flag <[player].flag[blockout.generator.seat]> seater:!
        - flag <[player].flag[blockout.generator.entity]> generator.workers:--
        - mount <[player]> cancel
        - bossbar remove generator_<[player].flag[blockout.generator.entity].uuid> players:<[player]>

        - flag <[player]> blockout.generator:!
        - flag <[player]> blockout.skill_check:!
        - bmmodel entity:<[player]> model:blockout_anims remove

generator_fail:
    type: task
    debug: false
    script:
        - define generator <player.flag[blockout.generator.entity].if_null[0]>
        - run update_generator_bar def:-<[generator].flag[generator.progress].mul[0.1].round>|<[generator]>
        - wait 2t
        - megstate model:<[generator].modeled_entity.model> state:fail
        - flag <[generator]> status.disabled expire:3s
        - foreach <[generator].flag[seats]> as:data:
            - if <[data.seat].has_flag[seater]>:
                - run exit_generator def:<[data.seat].flag[seater]>
        - playeffect effect:explosion <[generator].location.above[0.5]> quantity:1 offset:0
        - playsound sound:entity.generic.explode <[generator].location>
        - playeffect effect:campfire_cosy_smoke <[generator].location.above[0.8]> quantity:50
        - wait 0.3s
        - playeffect effect:flame <[generator].location.above[0.8]> quantity:50 velocity:0,0.1,0 offset:3
        - playeffect effect:smoke <[generator].location.above[0.8]> quantity:50


summon_generator:
    type: task
    debug: false
    definitions: loc
    script:
        - define loc <player.location>
        - spawn item_display[item=air] <[loc]> save:gen
        - megmodel entity:<entry[gen].spawned_entity> model:generator_temp
        - flag <entry[gen].spawned_entity> generator.progress:0
        - flag <entry[gen].spawned_entity> generator.workers:0

        - define loc <[loc].above[0.5]>
        - spawn item_display[item=air] <[loc].left[2].face[<[loc]>]> save:display
        - flag <entry[gen].spawned_entity> seats.1.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].right[2].face[<[loc]>]> save:display
        - flag <entry[gen].spawned_entity> seats.2.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].forward_flat[2].face[<[loc]>]> save:display
        - flag <entry[gen].spawned_entity> seats.3.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].backward_flat[2].face[<[loc]>]> save:display
        - flag <entry[gen].spawned_entity> seats.4.seat:<entry[display].spawned_entity>

