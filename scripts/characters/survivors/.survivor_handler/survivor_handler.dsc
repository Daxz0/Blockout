survivor_hit:
    type: task
    debug: false
    definitions: target
    script:
        - flag <[target]> blockout.game.survivor.hits:+:1
        - adjust <[target]> play_hurt_animation:0


        - if <[target].flag[blockout.game.survivor.hits]> >= 2:
            - flag <[target]> blockout.game.survivor.knocked
            - flag <[target]> blockout.game.survivor.hits:0
            - while <[target].has_flag[blockout.game.survivor.knocked]> && <[target].is_online>:
                - define loc <[target].location.above[1]>
                - flag <[loc]> knocked_player expire:2t
                - if <[loc].material.name> == air:
                    - adjust <[target]> noclip:false
                    - modifyblock barrier <[loc]> players:<server.online_players>
                    - wait 1t
                    - modifyblock air <[loc]> players:<server.online_players>

                # - adjust <[target]> swimming:true


# survivor_handler:
#     type: world
#     debug: false
#     events:
        