summon_pallet:
    type: task
    debug: false
    definitions: loc
    script:
        - define loc <player.location>
        - spawn item_display[item=air] <[loc]> save:pallet
        - megmodel entity:<entry[pallet].spawned_entity> model:pallet
        - flag <entry[pallet].spawned_entity> used:false