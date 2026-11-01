killer_danger_radius:
    type: task
    debug: false
    definitions: loc|radius
    script:
        - define playersInRange <[loc].find_players_within[<[radius]>]>
        - foreach <[playersInRange]> as:player:
            - fakespawn item_display[item=red_concrete;glowing=true;translation=0,-0.7,0;glow_color=red;scale=0.2,0.35,0.2] d:9999 mount_to:<[player]> <[player].location.with_pitch[0]> save:heart
            - run heartbeat_handler def:<[player]>|<[loc]>|<entry[heart].faked_entity>

heartbeat_handler:
    type: task
    debug: false
    definitions: player | loc | heart
    script:
        - define rate <[player].location.distance[<[heart]>].div[4]>

# killer_handler:
#     type: world
#     debug: false
#     events:
#         on delta time secondly every:1:
#             - define killerPlayer <server.flag[blockout.game.killer]>


