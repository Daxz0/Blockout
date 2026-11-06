mapcreate:
    type: world
    debug: false
    events:
        on server prestart:
            - createworld farm

        on player joins priority:10:
            - teleport <player> <world[farm].spawn_location>