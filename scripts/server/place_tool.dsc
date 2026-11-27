##############################################
# Blockout Tool
# Right click  -> open menu (Generator / Hook / Pallet)
# Sneak + left click -> remove nearest placed object
#
# Server flags (maps keyed by entity UUID, value = location incl. pitch + yaw):
#   blockout.object.generators.<uuid>
#   blockout.object.hooks.<uuid>
#   blockout.object.pallets.<uuid>
##############################################

blockout_wand:
    type: item
    material: blaze_rod
    display name: <&6><&l>Blockout Tool
    lore:
    - <&7>Right click: open object menu
    - <&7>Sneak + left click: remove nearest object

blockout_wand_events:
    type: world
    debug: false
    events:
        on player right clicks block with:blockout_wand:
        - ratelimit <player> 5t
        - determine cancelled passively
        - inventory open d:blockout_menu

        on player left clicks block with:blockout_wand:
        - stop if:<player.is_sneaking.not>
        - determine cancelled passively
        - run blockout_remove_nearest

############
# SUMMON TASKS
############

summon_generator:
    type: task
    debug: false
    definitions: loc
    script:
        - define loc <player.location>
        - spawn item_display[item=air] <[loc]> save:gen
        - define gen <entry[gen].spawned_entity>
        - bmmodel entity:<[gen]> model:generator_temp
        - flag <[gen]> generator.progress:0
        - flag <[gen]> generator.workers:0

        # save location (includes pitch + yaw) to the server
        - flag server blockout.object.generators.<[gen].uuid>:<[loc]>

        - define spacing 1.5

        - define loc <[loc].above[0.5]>
        - spawn item_display[item=air] <[loc].left[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.1.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].right[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.2.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].forward_flat[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.3.seat:<entry[display].spawned_entity>
        - spawn item_display[item=air] <[loc].backward_flat[<[spacing]>].face[<[loc]>]> save:display
        - flag <[gen]> seats.4.seat:<entry[display].spawned_entity>

        - narrate "<&a>Generator placed."

summon_hook:
    type: task
    debug: false
    definitions: loc
    script:
        - define loc <player.location>
        - spawn item_display[item=air] <[loc]> save:hook
        - define hook <entry[hook].spawned_entity>
        - flag <[hook]> hook
        - bmmodel entity:<[hook]> model:hook

        - flag server blockout.object.hooks.<[hook].uuid>:<[loc]>

        - narrate "<&a>Hook placed."

summon_pallet:
    type: task
    debug: false
    definitions: loc
    script:
        - define loc <player.location.backward_flat[0.7]>
        - spawn item_display[item=air] <[loc]> save:pallet
        - define pallet <entry[pallet].spawned_entity>
        - bmmodel entity:<[pallet]> model:pallet
        - flag <[pallet]> pallet.damage:0

        - flag server blockout.object.pallets.<[pallet].uuid>:<[loc]>

        - wait 1t
        - bmstate entity:<[pallet]> model:pallet state:start loop:hold
        - flag <[pallet]> facing_right_location:<[loc].yaw.add[90]>

        - narrate "<&a>Pallet placed."

############
# MENU
############

blockout_menu:
    type: inventory
    inventory: chest
    title: <&6>Blockout Objects
    size: 9
    gui: true
    slots:
    - [] [] [blockout_icon_generator] [] [blockout_icon_hook] [] [blockout_icon_pallet] [] []

blockout_icon_generator:
    type: item
    material: redstone_lamp
    display name: <&e>Summon Generator

blockout_icon_hook:
    type: item
    material: tripwire_hook
    display name: <&e>Summon Hook

blockout_icon_pallet:
    type: item
    material: oak_planks
    display name: <&e>Summon Pallet


blockout_menu_events:
    type: world
    debug: false
    events:
        on player clicks blockout_icon_generator in blockout_menu:
        - inventory close
        - run summon_generator
        on player clicks blockout_icon_hook in blockout_menu:
        - inventory close
        - run summon_hook
        on player clicks blockout_icon_pallet in blockout_menu:
        - inventory close
        - run summon_pallet


blockout_remove_nearest:
    type: task
    debug: false
    script:
        - define best_dist 999999
        - define best_id null
        - define best_type null

        - foreach generators|hooks|pallets as:type:
            - foreach <server.flag[blockout.object.<[type]>].if_null[<map>]> key:id as:saved_loc:
                - if <[saved_loc].world.name> != <player.location.world.name>:
                    - foreach next
                - define dist <[saved_loc].distance[<player.location>]>
                - if <[dist]> < <[best_dist]>:
                    - define best_dist <[dist]>
                    - define best_id <[id]>
                    - define best_type <[type]>

        - if <[best_id]> == null:
            - narrate "<&c>No objects to remove."
            - stop

        # Remove the entity (and generator seats) if it is currently loaded
        - define ent <entity[<[best_id]>].if_null[null]>
        - if <[ent]> != null && <[ent].is_spawned>:
            - foreach <[ent].flag[seats].if_null[<map>]> as:seat_data:
                - define seat <[seat_data].get[seat].if_null[null]>
                - if <[seat]> != null && <[seat].is_spawned>:
                    - remove <[seat]>
            - remove <[ent]>
        - else:
            - narrate "<&e>Entity was not loaded, only the saved entry was removed."

        - flag server blockout.object.<[best_type]>.<[best_id]>:!
        - narrate "<&c>Removed nearest <[best_type].before_last[s]> <&7>(<[best_dist].round_to[1]> blocks away)."
