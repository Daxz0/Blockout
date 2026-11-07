vaulting_detector:
    type: world
    debug: false
    events:
        on player right clicks entity_flagged:pallet.used flagged:blockout.team.survivor:
            - define loc <context.entity.location.with_yaw[<player.location.yaw>].backward_flat[1.8]>
            - spawn item_display[item=air] save:holder <[loc]>
            - bmmodel entity:<entry[holder].spawned_entity> model:blockout_anims

            - define right_loc <context.entity.flag[facing_right_location].if_null[0]>
            - define low_bound <[right_loc].sub[45]>
            - define upper_bound <[right_loc].add[45]>


            - if <[low_bound]> < <player.location.yaw> && <[upper_bound]> > <player.location.yaw> :
                - bmstate model:blockout_anims state:pallet_vault2 entity:<entry[holder].spawned_entity>
            - else:
                - bmstate model:blockout_anims state:pallet_vault entity:<entry[holder].spawned_entity>
            - inject update_model_skin
            - cast slow amplifier:255 <player> no_icon hide_particles d:1.8s
            # - bmmodel entity:<player> model:blockout_anims remove
            - cast invisibility amplifier:255 <player> no_icon hide_particles d:1s
            - wait 0.1

            - define target <context.entity.location.with_yaw[<player.location.yaw>].forward_flat[2.5].find_blocks[air].within[2].first.center.below[0.4]>
            - define cameraLoc <[loc].above[2].backward_flat[1]>
            - spawn item_display[item=air] save:camera <[cameraLoc]>
            - flag <player> blockout.vaulting expire:1s
            - adjust <player> spectate:<entry[camera].spawned_entity>
            - showfake barrier d:2s barrier <[cameraLoc].backward[1]>
            - wait 0.75s

            - flag <player> blockout.invulnerable.vault expire:0.35s

            - wait 1.1s
            - bmmodel entity:<entry[holder].spawned_entity>  model:blockout_anims remove
            - adjust <player> spectate:<player>
            - teleport <player> <[target].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]> relative
            - adjust <player> velocity:<player.location.sub[<player.location.backward_flat[0.5]>].mul[0.1]>
            - wait 0.05
            - remove <entry[camera].spawned_entity>
            - remove <entry[holder].spawned_entity>





        on player right clicks *_carpet:

            - if <player.has_flag[blockout.team.killer]>:
                - define loc <context.location.center.with_yaw[<player.location.yaw>].backward_flat[1]>
                - spawn item_display[item=air] save:holder <[loc].below[1]>
                - define model <player.bm_entity.model.name>
                - bmmodel entity:<entry[holder].spawned_entity> model:<[model]>

                - bmstate model:<[model]> state:vault entity:<entry[holder].spawned_entity>
                - foreach <entry[holder].spawned_entity.bm_entity.model.bones> as:bone:
                    - adjust <[bone]> scale:1.5,1.5,1.5

                - cast slow amplifier:255 <player> no_icon hide_particles d:1.75s
                # - bmmodel entity:<player> model:blockout_anims remove
                - cast invisibility amplifier:255 <player> no_icon hide_particles d:2s
                - wait 0.1

                - define target <context.location.with_yaw[<player.location.yaw>].forward_flat[1.5].find_blocks[air].within[2].first.center.below[0.1]>
                - define cameraLoc <[loc].above[1.25].backward_flat[1].with_pitch[45]>
                - spawn item_display[item=air] save:camera <[cameraLoc]>
                - flag <player> blockout.vaulting expire:1s
                - adjust <player> spectate:<entry[camera].spawned_entity>
                - showfake barrier d:1.8s <[cameraLoc]>
                - wait 1.75s
                - cast invisibility remove <player>

                - wait 0.1s
                - teleport <player> <[target].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]> relative
                - adjust <player> spectate:<player>
                - adjust <player> velocity:<player.location.sub[<player.location.backward_flat[0.5]>].mul[0.1]>
                - bmmodel entity:<entry[holder].spawned_entity>  model:<[model]> remove
                - wait 0.05
                - remove <entry[camera].spawned_entity>
                - remove <entry[holder].spawned_entity>


            - else if <player.has_flag[blockout.team.survivor]>:
                - define loc <context.location.center.with_yaw[<player.location.yaw>].backward_flat[1].below[1.5]>
                - spawn item_display[item=air] save:holder <[loc]>
                - bmmodel entity:<entry[holder].spawned_entity> model:blockout_anims
                - bmstate model:blockout_anims state:vault entity:<entry[holder].spawned_entity>
                - inject update_model_skin
                - cast slow amplifier:255 <player> no_icon hide_particles d:1.1s
                # - bmmodel entity:<player> model:blockout_anims remove
                - cast invisibility amplifier:255 <player> no_icon hide_particles d:1.1s
                - adjust <player> hide_entity:<player.flag[blockout.game.heart]>
                - wait 0.1

                - define target <context.location.with_yaw[<player.location.yaw>].forward_flat[1.5].find_blocks[air].within[2].first.center.below[0.1]>
                - define cameraLoc <[loc].above[2].backward_flat[1]>
                - spawn item_display[item=air] save:camera <[cameraLoc]>
                - flag <player> blockout.vaulting expire:1s
                - adjust <player> spectate:<entry[camera].spawned_entity>
                - showfake barrier d:0.9s <[cameraLoc].backward[1]>
                - wait 0.75s

                - flag <player> blockout.invulnerable.vault expire:0.35s

                - wait 0.1s
                - adjust <player> show_entity:<player.flag[blockout.game.heart]>
                - teleport <player> <[target].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]> relative
                - adjust <player> spectate:<player>
                - adjust <player> velocity:<player.location.sub[<player.location.backward_flat[0.5]>].mul[0.1]>
                - bmmodel entity:<entry[holder].spawned_entity>  model:blockout_anims remove
                - wait 0.05
                - remove <entry[camera].spawned_entity>
                - remove <entry[holder].spawned_entity>
                # - bmmodel entity:<player> model:blockout_anims




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