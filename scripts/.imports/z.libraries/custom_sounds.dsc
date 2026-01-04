sound_list:
    type: data
    mera_mera_fire_fist_1:
        entity_ender_dragon_flap:
            pitch: 1
            volume: 1
        entity_zombie_villager_cure:
            pitch: 2
            volume: 1
        entity_iron_golem_hurt:
            pitch: 1
            volume: 1
    mera_mera_fire_pillar_1:
        item_trident_thunder:
            pitch: 1.5
            volume: 1
        item_trident_throw:
            pitch: 1.5
            volume: 1
        item_firecharge_use:
            pitch: 1
            volume: 1
    gura_gura_quake_break:
        item_trident_riptide_2:
            pitch: 1
            volume: 1
        item_trident_throw:
            pitch: 1
            volume: 1
        item_firecharge_use:
            pitch: 1
            volume: 1
        entity_zombie_villager_cure:
            pitch: 2
            volume: 0.5
    gura_gura_seaquake:
        item_trident_thunder:
            pitch: 2
            volume: 0.8
        item_trident_throw:
            pitch: 1
            volume: 1
        item_firecharge_use:
            pitch: 1
            volume: 1
        entity_zombie_villager_cure:
            pitch: 2
            volume: 0.5

sound_command:
    type: task
    definitions: sound|target|sl
    debug: false
    script:
    - define data <script[<[sl]>].data_key[<[sound]>]>
    - foreach <[data].keys> as:name:
        - playsound <[target].location> sound:<[name].replace[-]> pitch:<[data].get[<[name]>].get[pitch]> volume:<[data].get[<[name]>].get[volume]>