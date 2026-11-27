team_switch:
    type: command
    debug: false
    name: team_select
    description: switch teams yo
    permissions: op
    usage: /team_select s(survivor)|k(killer)
    tab completions:
        1: s|k
    aliases:
        - ts
    script:
        - choose <context.args.first>:
            - case s:
                - run team_switcher_survivor def:<player>
            - case k:
                # - run team_switcher_killer
                - run select_killer def:piglin def:<player>
team_switcher_survivor:
    type: task
    debug: false
    definitions: player
    script:
        - flag <[player]> blockout.team.killer:!
        - flag <[player]> blockout.game.survivor:!
        - flag <[player]> blockout.game.killer:!
        - flag <[player]> blockout.team.survivor
        - bmmodel model:piglin_killer remove entity:<[player]>
        - adjust <[player]> attribute_base_values:<map[scale=1;camera_distance=2.5]>
        - adjust <[player]> speed:0.1

        - if <[player].has_flag[blockout.game.heart]>:
            - remove <[player].flag[blockout.game.heart]>
            - flag <[player]> blockout.game.heart:!

        - spawn item_display[item=red_concrete;glowing=true;translation=0,-0.8,0;glow_color=red;scale=0.15,0.3,0.15] <[player].location.with_pitch[0].with_yaw[0]> save:heart

        - run blockout_glow def:all|false|<[player]>
        - adjust <server.online_players> hide_entity:<entry[heart].spawned_entity>
        # - adjust <[player]> show_entity:<entry[heart].spawned_entity>

        - mount <entry[heart].spawned_entity>|<[player]> <[player].location.with_pitch[0].with_yaw[0]>
        - flag <[player]> blockout.game.heart:<entry[heart].spawned_entity>
        - narrate "<&a>team set to survivor"
        - team name:survivor add:<[player]> option:name_tag_visibility status:never
        - team name:survivor add:<[player]> option:SEE_INVISIBLE status:never
team_switcher_killer:
    type: task
    debug: false
    definitions: player
    script:
        - flag <[player]> blockout.team.survivor:!
        - flag <[player]> blockout.team.killer

        - if <[player].has_flag[blockout.game.heart]>:
            - remove <[player].flag[blockout.game.heart]>
            - flag <[player]> blockout.game.heart:!

        - run blockout_glow def:generators|true|<[player]>

        - adjust <[player]> attribute_base_values:<map[scale=1.5;camera_distance=0]>
        - team name:killer add:<[player]> option:name_tag_visibility status:never
        - narrate "<&4>team set to killer"