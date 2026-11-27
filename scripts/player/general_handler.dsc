general_handlers:
    type: world
    debug: false
    events:
        on player damaged:
            - if <context.cause> == FALL:
                - cast slow amplifier:1 d:2s <player> no_icon hide_particles
            - determine passively cancelled
        on player right clicks block priority:10:
            - stop if:<context.location.material.advanced_matches[*_door]>
            - stop if:<player.gamemode.equals[creative]>
            - determine passively cancelled

        on player changes food level:
            - determine passively cancelled