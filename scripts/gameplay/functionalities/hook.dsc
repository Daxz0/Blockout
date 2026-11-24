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
            - narrate hooki
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