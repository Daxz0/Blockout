killer_danger_radius:
    type: task
    debug: false
    definitions: loc|radius
    script:
        - foreach <[loc].find_players_within[<[radius]>].filter[has_flag[blockout.team.survivor]]> as:player:
            - run heartbeat_handler def:<[player]>|<[loc]>|<[radius]>

heartbeat_handler:
    type: task
    debug: false
    definitions: player|loc|radius
    script:
        - stop if:<[player].has_flag[heartbeat_active]>
        - flag <[player]> heartbeat_active expire:1

        - define heart <[player].flag[blockout.game.heart]>

        - adjust <[player]> show_entity:<[heart]>
        - repeat 2:
            - define dist <[player].location.distance[<[loc]>]>

            - if <[dist]> > <[radius].mul[0.75]>:
                - adjust <[heart]> glow_color:gray
                - adjust <[heart]> item:GRaY_CONCRETE
            - else:
                - adjust <[heart]> glow_color:red
                - adjust <[heart]> item:RED_CONCRETE

            - if <[dist]> > <[radius]>:
                - repeat stop

            - define ratio <[dist].div[<[radius]>]>

            - define interval <[ratio].mul[1.25].add[0.25]>

            - wait <[interval].mul[0.2]>s

            - adjust <[heart]> scale:0.2,0.35,0.2

            - wait <[interval].mul[0.6]>s
            - adjust <[heart]> scale:0.15,0.3,0.15

        - adjust <[player]> hide_entity:<[heart]>
        - flag <[player]> heartbeat_active:!

killer_swing_hitcone:
    type: task
    debug: false
    script:
        

killer_handler:
    type: world
    debug: false
    events:
        on delta time secondly every:1:
            - foreach <server.online_players_flagged[blockout.team.killer]> as:killer:
                - define data <[killer].flag[blockout.game.killer.data]>
                - run killer_danger_radius def:<[killer].location>|<[data.stats.stealth].mul[-1.8].add[30]>


        on player left clicks block flagged:blockout.team.killer:
            - define data <player.flag[blockout.game.killer.data]>
            - ratelimit <player> <[data.stats.swing_speed].mul[-0.15].add[3.5]>

            - bmstate entity:<player> model:<player.bm_entity.model.name> state:swing