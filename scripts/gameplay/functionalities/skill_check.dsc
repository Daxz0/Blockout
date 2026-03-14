skill_check_points:
    type: data
    debug: false
    check_points:
        01:
            base:
                min: 23
                max: 37
            crit:
                min: 20
                max: 22
        02:
            base:
                min: 43
                max: 54
            crit:
                min: 55
                max: 58
        03:
            base:
                min: 161
                max: 177
            crit:
                min: 178
                max: 181
        04:
            base:
                min: 147
                max: 158
            crit:
                min: 143
                max: 146
        05:
            base:
                min: 124
                max: 138
            crit:
                min: 119
                max: 123
        06:
            base:
                min: 96
                max: 109
            crit:
                min: 92
                max: 97
        07:
            base:
                min: 63
                max: 77
            crit:
                min: 78
                max: 81
        08:
            base:
                min: 20
                max: 33
            crit:
                min: 34
                max: 38
        09:
            base:
                min: 47
                max: 57
            crit:
                min: 43
                max: 46
        10:
            base:
                min: 168
                max: 181
            crit:
                min: 163
                max: 167
        11:
            base:
                min: 144
                max: 154
            crit:
                min: 155
                max: 158
        12:
            base:
                min: 120
                max: 133
            crit:
                min: 134
                max: 138
        13:
            base:
                min: 92
                max: 105
            crit:
                min: 106
                max: 111
        14:
            base:
                min: 68
                max: 81
            crit:
                min: 63
                max: 67
skill_check:
    type: task
    debug: false
    script:
        - define check <util.random.int[1].to[14]>
        - define check 0<[check]> if:<[check].is_less_than[10]>
        - flag <player> blockout.skill_check.check:<[check]>
        - define speed <util.random.int[3].to[6]>
        - playsound sound:entity.wither.spawn pitch:2 <player>
        - wait 5t
        - if <util.random_chance[50]>:
            - repeat 2:
                - repeat 200:
                    - if <[value]> < 10:
                        - define value 00<[value]>
                    - else if <[value]> < 100:
                        - define value 0<[value]>

                    - stop if:<player.has_flag[blockout.skill_check].not>
                    - flag <player> blockout.skill_check.value:<[value]> expire:1s
                    - title title:<&chr[a001].font[primary_uis]><&translate[key=space.-40].font[space:default]><&chr[a0<[check]>].font[checks]><&translate[key=space.-40].font[space:default]><&chr[a<[value]>].font[skillchecks]> fade_in:0s fade_out:0s stay:4t
                    - if <[value].mod[<[speed]>]> == 0:
                        - wait 1t
                - wait 1t
            - flag <player> blockout.skill_check.fail expire:30s
        - else:
            - repeat 2:
                - repeat 200:
                    - if <[value]> < 10:
                        - define value 00<[value]>
                    - else if <[value]> < 100:
                        - define value 0<[value]>

                    - stop if:<player.has_flag[blockout.skill_check].not>
                    - flag <player> blockout.skill_check.value:<[value]> expire:1s
                    - title title:<&chr[a001].font[primary_uis]><&translate[key=space.-40].font[space:default]><&chr[a0<[check]>].font[checks]><&translate[key=space.-40].font[space:default]><&chr[a<[value]>].font[skillchecks]> fade_in:0s fade_out:0s stay:2t
                    - if <[value].mod[<[speed]>]> == 0:
                        - wait 1t
                - wait 1t
            - flag <player> blockout.skill_check.fail expire:30s

        - wait 2t
        - title title:<empty> fade_in:0 fade_out:0 stay:1t
