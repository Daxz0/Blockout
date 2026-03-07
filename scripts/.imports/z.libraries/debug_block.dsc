## made by ikuria

show_debugblock:
    type: task
    debug: false
    definitions: location|sides|color|alpha|duration|targets
    script:
        # defaults
        - stop if:!<[location].exists>

        - if !<[sides].exists>:
            - define sides <list[UP|DOWN|NORTH|EAST|SOUTH|WEST]>

        - define sc.UP.offset       0.49,1.001,1
        - define sc.UP.yaw          0
        - define sc.UP.pitch        -90
        - define sc.UP.color        lime

        - define sc.DOWN.offset     0.49,-0.001,0
        - define sc.DOWN.yaw        0
        - define sc.DOWN.pitch      90
        - define sc.DOWN.color      orange

        - define sc.NORTH.offset    0.51,0,-0.001
        - define sc.NORTH.yaw       180
        - define sc.NORTH.pitch     0
        - define sc.NORTH.color     aqua

        - define sc.EAST.offset     1.001,0,0.5
        - define sc.EAST.yaw        -90
        - define sc.EAST.pitch      0
        - define sc.EAST.color      red

        - define sc.SOUTH.offset    0.49,0,1.001
        - define sc.SOUTH.yaw       0
        - define sc.SOUTH.pitch     0
        - define sc.SOUTH.color     blue

        - define sc.WEST.offset     -0.001,0,0.49
        - define sc.WEST.yaw        90
        - define sc.WEST.pitch      0
        - define sc.WEST.color      fuchsia

        - define alpha 200 if:!<[alpha].exists>

        - stop if:!<[targets].exists>

        - define duration 5s if:!<[duration].exists>

        - if <[location].blocks.size.exists>:
            - foreach <[location].blocks> as:b:
                - foreach <[sides]> as:s:
                    - fakespawn text_display[text=<element[ ].repeat[10]><&nl><&nl><&nl>;background_color=<color[<[color].if_null[<[sc].get[<[s]>].get[color]>]>].with_alpha[<[alpha]>].rgba>] <[b].add[<[sc].get[<[s]>].get[offset]>].with_yaw[<[sc].get[<[s]>].get[yaw]>].with_pitch[<[sc].get[<[s]>].get[pitch]>]> players:<[targets]> duration:<[duration]>
        - else:
            - foreach <[sides]> as:s:
                - fakespawn text_display[text=<element[ ].repeat[10]><&nl><&nl><&nl>;background_color=<color[<[color].if_null[<[sc].get[<[s]>].get[color]>]>].with_alpha[<[alpha]>].rgba>] <[location].add[<[sc].get[<[s]>].get[offset]>].with_yaw[<[sc].get[<[s]>].get[yaw]>].with_pitch[<[sc].get[<[s]>].get[pitch]>]> players:<[targets]> duration:<[duration]>