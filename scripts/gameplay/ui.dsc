ability_display_test:
    type: task
    debug: false
    script:
        # - while <player.is_online>:
            - actionbar <element[<&lt>color:#fffcfc<&gt><&lt>!shadow<&gt><&lt>font:killer_abilities<&gt><&chr[a001]><&chr[a002]><&lt>/font<&gt><element[ ].repeat[10]>4].parse_minimessage>
            # - actionbar <element[<&lt>shadow:yellow<&gt>text].parse_minimessage>
            - wait 3t