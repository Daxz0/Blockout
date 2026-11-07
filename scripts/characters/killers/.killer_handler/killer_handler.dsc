killer_danger_radius:
    type: task
    debug: false
    definitions: killer|radius
    script:
        - define loc <[killer].location>
        - foreach <[loc].find_players_within[<[radius]>].filter[has_flag[blockout.team.survivor]].filter[has_flag[blockout.heartbeat_active].not]> as:player:
            - run heartbeat_handler def:<[player]>|<[killer]>|<[radius]>

heartbeat_handler:
    type: task
    debug: false
    definitions: player|killer|radius
    script:
        - define loc <[killer].location>
        - stop if:<[player].has_flag[blockout.heartbeat_active]>
        - flag <[player]> blockout.heartbeat_active

        - define heart <[player].flag[blockout.game.heart]>

        - adjust <[player]> show_entity:<[heart]>
        - define dist <[player].location.distance[<[loc]>]>
        - while <[dist]> < <[radius]> && <[player].is_online> && <[killer].is_online>:
            - define loc <[killer].location>
            - define dist <[player].location.distance[<[loc]>]>

            - if <[dist]> > <[radius].mul[0.75]>:
                - adjust <[heart]> glow_color:gray
                - adjust <[heart]> item:GRaY_CONCRETE
            - else:
                - adjust <[heart]> glow_color:red
                - adjust <[heart]> item:RED_CONCRETE

            - if <[dist]> > <[radius]>:
                - while stop

            - define ratio <[dist].div[<[radius]>]>

            - define interval <[ratio].mul[1.25].add[0.1]>

            - wait <[interval].mul[0.2]>s

            - adjust <[heart]> scale:0.2,0.35,0.2

            - wait <[interval].mul[0.6]>s
            - adjust <[heart]> scale:0.15,0.3,0.15

        - adjust <[player]> hide_entity:<[heart]>
        - flag <[player]> blockout.heartbeat_active:!



swing_runner:
    type: task
    debug: false
    script:
        - stop if:<player.has_flag[blockout.game.killer.swing_cd]>
        - define data <player.flag[blockout.game.killer.data]>
        - flag <player> blockout.game.killer.swing_cd expire:<[data.stats.swing_speed].mul[-0.15].add[3.5]>s

        - bmstate entity:<player> model:<player.bm_entity.model.name> state:swing


        - wait 0.75

        - define startLoc <player.eye_location>
        - define beam <[startLoc].points_between[<[startLoc].forward[2.5]>].distance[0.5]>
        - foreach <[beam]> as:point:
            - define target <[point].find_players_within[0.5].exclude[<player>]>
            - if <[target].any>:
                - foreach stop

        - if <[target].first.if_null[true]>:
            - flag <player> blockout.game.killer.swing_cd expire:<[data.stats.swing_speed].mul[-0.15].add[5]>s
        - else:
            - run survivor_hit def:<[target]>



killer_handler:
    type: world
    debug: false
    events:
        on delta time secondly every:1:
            - foreach <server.online_players_flagged[blockout.team.killer]> as:killer:
                - define data <[killer].flag[blockout.game.killer.data]>
                - run killer_danger_radius def:<[killer]>|<[data.stats.stealth].mul[1.3].add[30]>


        on player left clicks block flagged:blockout.team.killer:
            - inject swing_runner

        on player damages player:
            - determine passively cancelled
            - if <player.has_flag[blockout.team.killer]>:
                - inject swing_runner