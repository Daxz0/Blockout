general_ui:
    type: task
    debug: false
    script:
        # - while <player.is_online>:

        - define generator_count 5
        - bossbar auto general_ui_<player.uuid> title:<element[<&lt>color:#aaaabc<&gt><&lt>bold<&gt><[generator_count]><&lt>color:#fffcfc<&gt><element[ ].repeat[2]><&lt>!shadow<&gt><&lt>font:primary_uis<&gt><&chr[a002]><&lt>/font<&gt>].parse_minimessage>

        - sidebar title:logo


        - define fake_player_list_for_testing <list[Daxz_|heypr|Notch|Bob]>
        - foreach <[fake_player_list_for_testing]> as:player:
            - sidebar set_line scores:<[loop_index]> "values:<element[<&lt>head:<[player]>:true<&gt>].parse_minimessage>"



        - wait 3t



ability_display_test:
    type: task
    debug: false
    script:
        # - while <player.is_online>:
            - bossbar <element[<&lt>color:#fffcfc<&gt><&lt>!shadow<&gt><&lt>font:killer_abilities<&gt><&chr[a001]><&chr[a002]><&lt>/font<&gt><element[ ].repeat[10]>4].parse_minimessage>

            # please paper just let me hide shadows

            # - actionbar <element[<&lt>shadow:yellow<&gt>text].parse_minimessage>
            - wait 3t