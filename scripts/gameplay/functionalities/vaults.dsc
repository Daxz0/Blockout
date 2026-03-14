vaulting_detector:
    type: world
    debug: false
    events:
        on player right clicks *_carpet:

            - bmmodel entity:<player> model:blockout_anims
            - bmstate model:blockout_anims state:vault entity:<player>
            - cast slow amplifier:255 <player> no_icon hide_particles d:1.1s

            - define target <context.location.with_yaw[<player.location.yaw>].forward_flat[2].above[1].with_pitch[90].ray_trace[range=3]>
            - spawn item_display[item=air] save:camera <player.location.above[2].backward_flat[0.5]>
            - adjust <player> spectate:<entry[camera].spawned_entity>
            - wait 0.75s

            - flag <player> blockout.invulnerable.vault expire:0.35s

            - wait 0.35s
            - adjust <player> spectate:<player>


            - teleport <player> <[target].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
            - bmmodel entity:<player> model:blockout_anims remove

