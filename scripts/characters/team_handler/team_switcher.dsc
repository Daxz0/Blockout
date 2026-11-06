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
                - run team_switcher_survivor
            - case k:
                - run team_switcher_killer
team_switcher_survivor:
    type: task
    debug: false
    script:
        - flag <player> blockout.team.killer:!
        - flag <player> blockout.team.survivor
        - adjust <player> attribute_base_values:<map[scale=1;camera_distance=2.5]>
        - adjust <player> speed:0.1

        - if <player.has_flag[blockout.game.heart]>:
            - remove <player.flag[blockout.game.heart]>

        - spawn item_display[item=red_concrete;glowing=true;translation=0,-0.8,0;glow_color=red;scale=0.15,0.3,0.15] <player.location.with_pitch[0].with_yaw[0]> save:heart

        - adjust <server.online_players> hide_entity:<entry[heart].spawned_entity>
        # - adjust <player> show_entity:<entry[heart].spawned_entity>

        - mount <entry[heart].spawned_entity>|<player> <player.location.with_pitch[0].with_yaw[0]>
        - flag <player> blockout.game.heart:<entry[heart].spawned_entity>
        - narrate "<&a>team set to survivor"
team_switcher_killer:
    type: task
    debug: false
    script:
        - flag <player> blockout.team.survivor:!
        - flag <player> blockout.team.killer

        - if <player.has_flag[blockout.game.heart]>:
            - remove <player.flag[blockout.game.heart]>

        - adjust <player> attribute_base_values:<map[scale=1.5;camera_distance=0]>
        - narrate "<&4>team set to killer"