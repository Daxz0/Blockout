mapcreate:
    type: world
    debug: false
    events:
        on server prestart:
            - createworld Ormond

        on player joins priority:10:
            - teleport <player> <world[Ormond].spawn_location>