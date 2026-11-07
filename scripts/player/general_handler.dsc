general_handlers:
    type: world
    debug: false
    events:
        on player damaged:
            - determine passively cancelled
        on player right clicks block priority:10:
            - stop if:<player.gamemode.equals[creative]>
            - determine passively cancelled

        on player changes food level:
            - determine passively cancelled