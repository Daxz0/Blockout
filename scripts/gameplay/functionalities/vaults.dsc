vaulting_detector:
    type: world
    debug: true
    events:
        on player right clicks PLAYER bukkit_priority:LOWEST:
            - determine cancelled
        on player right clicks *_carpet:

            - define loc <context.location.center.with_yaw[<player.location.yaw>].backward_flat[1].below[1.5]>
            - spawn item_display[item=air] save:holder <[loc]>
            - bmmodel entity:<entry[holder].spawned_entity> model:blockout_anims
            - bmstate model:blockout_anims state:vault entity:<entry[holder].spawned_entity>
            - inject update_model_skin
            - cast slow amplifier:255 <player> no_icon hide_particles d:1.1s
            # - bmmodel entity:<player> model:blockout_anims remove
            - cast invisibility amplifier:255 <player> no_icon hide_particles d:1.1s
            - wait 0.1

            - define target <context.location.with_yaw[<player.location.yaw>].forward_flat[2.5].find_blocks[air].within[2].first.center.below[0.4]>
            - spawn item_display[item=air] save:camera <[loc].above[2].backward_flat[1]>
            - flag <player> blockout.vaulting expire:1s
            - adjust <player> spectate:<entry[camera].spawned_entity>
            - wait 0.75s

            - flag <player> blockout.invulnerable.vault expire:0.35s

            - wait 0.2s
            - bmmodel entity:<entry[holder].spawned_entity>  model:blockout_anims remove
            - wait 0.05
            - remove <entry[camera].spawned_entity>
            - remove <entry[holder].spawned_entity>
            # - bmmodel entity:<player> model:blockout_anims
            - adjust <player> spectate:<player>



            - teleport <player> <[target].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]> relative
            - adjust <player> velocity:<player.location.sub[<player.location.backward_flat[1]>].mul[0.5]>

update_model_skin:
    type: task
    debug: false
    script:
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:head part:head from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:chest part:chest from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:left_arm part:left_arm from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:right_arm part:right_arm from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:right_forearm part:right_forearm from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:left_forearm part:left_forearm from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:chest part:chest from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:left_leg part:left_leg from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:right_leg part:right_leg from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:right_foreleg part:right_foreleg from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:left_foreleg part:left_foreleg from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:waist part:waist from:<player>
        - bmpart entity:<entry[holder].spawned_entity> model:blockout_anims bone:hip part:hip from:<player>