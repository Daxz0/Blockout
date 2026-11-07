survivor_hit:
    type: task
    debug: false
    definitions: target
    script:
        - flag <[target]> blockout.game.survivor.hits:++
        - adjust <[target].first> play_hurt_animation:0


        - if <[target].flag[blockout.game.survivor.hits]> >= 2:
            - flag <[target]> blockout.game.survivor.knocked
            - flag <[target]> blockout.game.survivor.hits:0
            - while <[target].has_flag[blockout.game.survivor.knocked]> && <[target].is_online>:
                - wait 1t
                - if <[target].location.above[1.5].material.name> == air :
                    - adjust <[target]> noclip:true
                    - showfake barrier <[target].location.above[1.5]> duration:1t
                    - showfake barrier <[target].location.above[1.5]> duration:1t


# survivor_handler:
#     type: world
#     debug: false
#     events:
        