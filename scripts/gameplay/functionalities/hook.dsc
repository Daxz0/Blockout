summon_hook:
    type: task
    debug: false
    definitions: loc
    script:
        - define loc <player.location>
        - spawn item_display[item=air] <[loc]> save:hook
        - flag <entry[hook].spawned_entity> hook
        - bmmodel entity:<entry[hook].spawned_entity> model:hook

hook_handler:
    type: world
    debug: false
    events:
        on player right clicks entity_flagged:hook flagged:blockout.team.killer:
            - stop if:<player.has_flag[blockout.game.killer.pickup].not>
            - define killer <player>
            - define survivor <player.flag[blockout.game.killer.pickup]>
            - remove <[survivor].flag[blockout.game.survivor.pickup]>
            - flag <[survivor]> blockout.game.survivor.pickup:!
            - flag <[survivor]> blockout.game.survivor.wiggle:!
            - flag <[killer]> blockout.game.killer.pickup:!
            - flag <[survivor]> blockout.game.survivor.hooked expire:120s
            - bmstate entity:<[killer]> state:walk_pickup remove model:<player.bm_entity.model.name>
            - bmstate entity:<context.entity> model:hook state:activate loop:hold
            - run update_model_skin def:<context.entity>|hook|<[survivor]>
            - mount <[survivor]> cancel
            - mount <[survivor]>|<context.entity>
            - cast invisibility d:120 no_icon hide_particles <[survivor]>

            - flag <context.entity> hooked:<[survivor]> expire:120s

            - while <[survivor].has_flag[blockout.game.survivor.hooked]>:
                - flag <[survivor]> blockout.game.survivor.hook_count:+:1
                - wait 1s
                - if <[survivor].flag[blockout.game.survivor.hook_count]> >= 100:
                    - bmstate entity:<context.entity> model:hook state:activate remove
                    - wait 2t
                    - bmstate entity:<context.entity> model:hook state:death loop:hold
                    - adjust <[survivor]> gamemode:spectator
                    - while stop

            - cast invisibility remove <[survivor]>
            - mount <[survivor]> cancel
            - bmstate entity:<context.entity> model:hook state:activate loop:once
            - bmstate entity:<context.entity> model:hook state:activate remove
            - flag <[survivor]> blockout.game.survivor.hits:0


        on player input flagged:blockout.game.survivor.hooked:
            - determine passively cancelled

        on player right clicks entity_flagged:hook flagged:blockout.team.survivor:
            - stop if:<player.has_flag[blockout.game.killer.knocked]>
            - define hooked_player <context.entity.flag[hooked]>
            - flag <[hooked_player]> blockout.game.survivor.hooked:!

