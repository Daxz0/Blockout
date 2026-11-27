blockout_start_game:
    type: task
    debug: false
    script:
        - run assign_teams
        - run blockout_reset def:all

assign_teams:
    type: task
    debug: false
    script:
        - define killer <server.online_players.random>
        - run team_switcher_survivor def:<[killer]>
        - foreach <server.online_players.exclude[<[killer]>]> as:player:
            - flag <[player]> blockout:!
            - run team_switcher_survivor def:<[player]>


blockout_reset:
    type: task
    debug: false
    definitions: type
    script:

        - define type <[type].if_null[all]>
        - if <[type]> == all:
            - define type_list <list[generators|hooks|pallets]>
        - else:
            - define type_list <list[<[type]>]>

        # make sure every chunk is loaded so the old entities can be found and removed
        - foreach <[type_list]> as:t:
            - foreach <server.flag[blockout.object.<[t]>].if_null[<map>]> as:loc:
                - chunkload <[loc].chunk> duration:30s
        - wait 2t

        - define total 0
        - foreach <[type_list]> as:t:
            - define new_map <map>

            - foreach <server.flag[blockout.object.<[t]>].if_null[<map>]> key:id as:loc:
                # ---- remove the old one ----
                - define old <entity[<[id]>].if_null[null]>
                - if <[old]> != null && <[old].is_spawned>:
                    - define fake <[old].flag[glow_fake].if_null[null]>
                    - if <[fake]> != null:
                        - fakespawn <[fake]> cancel players:<server.online_players>
                    - foreach <[old].flag[seats].if_null[<map>]> as:seat_data:
                        - define seat <[seat_data].get[seat].if_null[null]>
                        - if <[seat]> != null && <[seat].is_spawned>:
                            - remove <[seat]>
                    - remove <[old]>

                # ---- spawn a fresh one at the same spot ----
                - choose <[t]>:
                    - case generators:
                        - run blockout_spawn_generator def:<[loc]> save:result
                    - case hooks:
                        - run blockout_spawn_hook def:<[loc]> save:result
                    - case pallets:
                        - run blockout_spawn_pallet def:<[loc]> save:result
                - define new <entry[result].created_queue.determination.first.if_null[null]>
                - if <[new]> == null:
                    - foreach next

                - define new_map.<[new].uuid> <[loc]>
                - define total <[total].add[1]>

            # replace the old map (old UUID keys are gone)
            - if <[new_map].is_empty>:
                - flag server blockout.object.<[t]>:!
            - else:
                - flag server blockout.object.<[t]>:<[new_map]>

        - narrate "<&a>Reset <&e><[total]> <&a>objects."

############
# Spawn helpers (take an exact location, hand the new entity back)
############

blockout_spawn_generator:
    type: task
    debug: false
    definitions: loc
    script:
        - spawn item_display[item=air] <[loc]> save:gen
        - define gen <entry[gen].spawned_entity>
        - determine <[gen]> passively
        - bmmodel entity:<[gen]> model:generator_temp
        - flag <[gen]> generator.progress:0
        - flag <[gen]> generator.workers:0

        - define spacing 1.5
        - define loc <[loc].above[0.5]>
        - spawn item_display[item=air] <[loc].left[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.1.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].right[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.2.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].forward_flat[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.3.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].backward_flat[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.4.seat:<entry[display].spawned_entity>

blockout_spawn_hook:
    type: task
    debug: false
    definitions: loc
    script:
        - spawn item_display[item=air] <[loc]> save:hook
        - define hook <entry[hook].spawned_entity>
        - determine <[hook]> passively
        - flag <[hook]> hook
        - bmmodel entity:<[hook]> model:hook

blockout_spawn_pallet:
    type: task
    debug: false
    definitions: loc
    script:
        - spawn item_display[item=air] <[loc]> save:pallet
        - define pallet <entry[pallet].spawned_entity>
        - determine <[pallet]> passively
        - bmmodel entity:<[pallet]> model:pallet
        - flag <[pallet]> pallet.damage:0
        - wait 1t
        - bmstate entity:<[pallet]> model:pallet state:start loop:hold
        - flag <[pallet]> facing_right_location:<[loc].yaw.add[90]>
