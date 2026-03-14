summon_pallet:
    type: task
    debug: false
    definitions: loc
    script:
        - define loc <player.location.backward_flat[0.7]>
        - spawn item_display[item=air] <[loc]> save:pallet
        - megmodel entity:<entry[pallet].spawned_entity> model:pallet
        - flag <entry[pallet].spawned_entity> pallet.used:false
        - flag <entry[pallet].spawned_entity> pallet.broken:false
        - flag <entry[pallet].spawned_entity> pallet.damage:0
        - wait 1t
        - megstate model:<entry[pallet].spawned_entity.modeled_entity.model> state:start



pallet_handler:
    type: world
    debug: true
    events:
        on player right clicks entity_flagged:pallet:
            - ratelimit <player> 1s
            - define pallet_model <context.entity.modeled_entity.model>
            - define loc <context.entity.location>


            - if <context.entity.flag[pallet.used].not>  && <player.has_flag[blockout.team.survivor]>:
                - megstate model:<[pallet_model]> state:start remove
                - megstate model:<[pallet_model]> state:activate
                - flag <context.entity> pallet.used:true

                - define blocks <[loc].find_blocks[air].within[1.5].filter[y.equals[<[loc].y>]]>
                - modifyblock <[blocks]> barrier
                - flag <[blocks]> pallet_blocking

            - else if <context.entity.flag[pallet.used]> && <context.entity.flag[pallet.broken].not> && <player.has_flag[blockout.team.killer]>:
                - if <context.entity.flag[pallet.damage]> >= 3:
                    - megstate model:<[pallet_model]> state:break
                    - define blocks <[loc].find_blocks[barrier].within[2]>
                    - modifyblock <[blocks]> air
                    - flag <[blocks]> pallet_blocking:!
                    - flag <context.entity> pallet.broken:true
                - else:
                    - megstate model:<[pallet_model]> state:kick
                    - flag <context.entity> pallet.damage:++



