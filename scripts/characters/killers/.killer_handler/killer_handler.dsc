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

        - bmstate entity:<player> model:<player.bm_entity.model.name> state:swing


        - wait 0.75

        - define startLoc <player.eye_location>
        - define beam <[startLoc].points_between[<[startLoc].forward[2.5]>].distance[0.5]>
        - foreach <[beam]> as:point:
            - define target <[point].find_players_within[0.5].exclude[<player>].exclude[<server.online_players_flagged[blockout.game.survivor.knocked]>]>
            - if <[target].any>:
                - foreach stop

        - if <[target].is_empty>:
            - flag <player> blockout.game.killer.swing_cd expire:<[data.stats.swing_speed].mul[-0.15].add[5]>s
        - else:
            - flag <player> blockout.game.killer.swing_cd expire:<[data.stats.swing_speed].mul[-0.15].add[3.5]>s
            - run survivor_hit def:<[target].first>
            - playsound sound:entity.zombie.break_wooden_door <[target].first.location> volume:5
            - stop if:<[target].flag[blockout.game.survivor.hits].is_more_than_or_equal_to[2]>
                - cast speed amplifier:2 duration:4s <[target].first> no_icon hide_particles




update_wiggle_bar:
    type: task
    debug: false
    definitions: amount|killer|survivor
    script:
        - flag <[survivor]> blockout.game.survivor.wiggle:+:<[amount]>
        - if <[survivor].flag[blockout.game.survivor.wiggle]> >= 105:
            - remove <[survivor].flag[blockout.game.survivor.pickup]>
            - flag <[survivor]> blockout.game.survivor.pickup:!
            - flag <[survivor]> blockout.game.survivor.wiggle:!
            - flag <[killer]> blockout.game.killer.pickup:!
            - bmstate entity:<[killer]> state:walk_pickup remove model:<player.bm_entity.model.name>
            - mount <[survivor]> cancel
            - stop
        - if <[survivor].flag[blockout.game.survivor.wiggle]> <= 0:
            - flag <[survivor]> blockout.game.survivor.wiggle:0

        - define repairing_ui <&chr[a002].font[bars]><&translate[space.33].font[space:default]>
        - define fillerChar <&translate[space.-1].font[space:default]><&chr[a010].font[bars]>

        - define fillerAmount <[survivor].flag[blockout.game.survivor.wiggle]>
        - define fillerWidth 26
        - define totalWidth 214
        - define defaultFillerPos 0
        - define defaultFillerBuffer <&translate[space.<[defaultFillerPos]>].font[space:default]>
        - define fillerCharNew <[fillerChar].repeat[<[fillerAmount]>]>

        - actionbar <&translate[space.<[fillerAmount].mul[2]>].font[space:default]><[repairing_ui]><&translate[space.-<[totalWidth].add[<[fillerWidth]>]>].font[space:default]><[defaultFillerBuffer]><[fillerCharNew]><&translate[space.-<[fillerWidth].add[<[defaultFillerPos]>]>].font[space:default]><&translate[space.<[totalWidth].add[<[fillerWidth]>]>].font[space:default]> targets:<[survivor]>

pickup_handler:
    type: task
    debug: false
    definitions: entity|player
    script:
        - if <[entity].has_flag[blockout.team.killer]> && <[player].has_flag[blockout.game.survivor.knocked]>:
            - cast slow d:0.75s no_icon hide_particles amplifier:255
            - define data <[entity].flag[blockout.game.killer.data]>
            - define model <[data.model_name]>
            - inject update_model_skin

            - bmstate entity:<[entity]> model:<[entity].bm_entity.model.name> state:pickup

            - spawn allay[visible=false;has_ai=false;silent=true] save:holder
            - flag <[player]> blockout.game.survivor.knocked:!
            - flag <[player]> blockout.game.survivor.pickup:<entry[holder].spawned_entity>
            - flag <[entity]> blockout.game.killer.pickup:<[player]>
            - bmstate entity:<[entity]> model:<[entity].bm_entity.model.name> state:walk_pickup loop:loop
            - mount <[player]>|<entry[holder].spawned_entity>|<[entity]>

        - while <[entity].has_flag[blockout.game.killer.pickup]> && <[player].is_online> && <[entity].is_online>:
            - cast invisibility d:5t no_icon hide_particles <[player]>
            - wait 5t
            - run update_wiggle_bar def:1|<[entity]>|<[player]>

        - flag <[player]> blockout.game.survivor.pickup:!


killer_handler:
    type: world
    debug: false
    events:
        on player right clicks block location_flagged:pickup:
            - ratelimit <player> 10t
            - stop if:<player.has_flag[blockout.game.killer.pickup]>
            - define player <context.location.flag[pickup]>
            - run pickup_handler def:<player>|<[player]>

        on player right clicks player priority:100:
            - ratelimit <player> 10t
            - stop if:<player.has_flag[blockout.game.killer.pickup]>
            - define player <context.entity>
            - run pickup_handler def:<player>|<[player]>

        on delta time secondly every:1:
            - foreach <server.online_players_flagged[blockout.team.killer]> as:killer:
                - define data <[killer].flag[blockout.game.killer.data]>
                - run killer_danger_radius def:<[killer]>|<[data.stats.stealth].mul[1.3].add[30]>


        on player left clicks block flagged:blockout.team.killer:
            - ratelimit <player> 10t
            - inject swing_runner
        on player damages player:
            - if <context.damager.has_flag[blockout.team.killer]>:
                - inject swing_runner
            - determine passively cancelled