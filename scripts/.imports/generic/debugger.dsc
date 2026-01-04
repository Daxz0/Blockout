debugger_command:
    type: command
    usage: /debugger
    name: debugger
    description: Developer Debugger
    permission: op
    debug: false
    tab completions:
        1: slots|damage
    aliases:
        - db
    script:
        - define arg <context.args.first.if_null[0]>

        - stop if:<[arg].equals[0]>

        - choose <[arg]>:
            - case slots:
                - if <player.has_flag[debugger.slots]>:
                    - flag <player> debugger.slots:!
                    - narrate "<&c><&l>DEBUGGER: SLOTS DEACTIVATED"
                - else:
                    - narrate "<&a><&l>DEBUGGER: SLOTS ACTIVATED"
                    - flag <player> debugger.slots expire:12h
            - case damage:
                - if <player.has_flag[debugger.damage]>:
                    - flag <player> debugger.damage:!
                    - narrate "<&c><&l>DEBUGGER: DAMAGE DEACTIVATED"
                - else:
                    - narrate "<&a><&l>DEBUGGER: DAMAGE ACTIVATED"
                    - flag <player> debugger.damage expire:12h


debugger_handler:
    type: world
    debug: false
    events:
        after player clicks item in inventory flagged:debugger.slots:
            - narrate "<&2><&l>DEBUGGER: SLOT <context.slot>"
        after player_flagged:debugger.damage damages entity:
            - narrate "<&2><&l>DEBUGGER: DAMAGE <context.damage>"