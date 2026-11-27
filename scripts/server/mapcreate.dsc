mapcreate:
    type: world
    debug: false
    events:
        on server prestart:
            - createworld farm
            - createworld lobby

        on player joins priority:10:
            - teleport <player> <world[lobby].spawn_location>