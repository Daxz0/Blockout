blockout_glow:
    type: task
    debug: false
    definitions: type|state|viewers
    script:
        - define type <[type].if_null[all]>
        - define state <[state].if_null[true]>
        - define defaults <map[generators=yellow;hooks=red;pallets=aqua]>

        - if <[type]> == all:
            - define type_list <list[generators|hooks|pallets]>
        - else:
            - define type_list <list[<[type]>]>

        - foreach <[type_list]> as:t:
            - define col <server.flag[blockout.glow_color.<[t]>].if_null[<[defaults].get[<[t]>]>]>

            - foreach <server.flag[blockout.object.<[t]>].if_null[<map>]> key:id as:loc:
                - define ent <entity[<[id]>].if_null[null]>
                - if <[ent]> == null || !<[ent].is_spawned>:
                    - foreach next

                - define fake <[ent].flag[glow_fake].if_null[null]>

                - if <[state]>:
                    - if <[fake]> != null:
                        - foreach next
                    - fakespawn item_display[item=snowball;glowing=true;glow_color=<[col]>;visible=false] <[loc].above[0.5]> players:<[viewers]> duration:99999 save:hb
                    - flag <[ent]> glow_fake:<entry[hb].faked_entity>
                - else:
                    - if <[fake]> != null:
                        - fakespawn <[fake]> cancel players:<[viewers]>
                    - flag <[ent]> glow_fake:!
remove_fake_ents:
    type: task
    debug: false
    script:
        - define ents <player.fake_entities>
        - foreach <[ents]> as:fake:
            - fakespawn <[fake]> cancel