team_switch:
    type: command
    debug: false
    name: team_select
    description: switch teams yo
    permissions: op
    usage: /team_select s(survivor)|k(killer)
    tab completions:
        1: s|k
    aliases:
        - ts
    script:
        - choose <context.args.first>:
            - case s:
                - flag <player> blockout.teams.survivor
                - narrate "<&a>team set to survivor"
            - case k:
                - flag <player> blockout.teams.killer
                - narrate "<&4>team set to killer"