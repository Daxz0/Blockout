dvreload:
    type: command
    name: dvreload
    debug: false
    description: Reloads Denizen scripts
    usage: /dvreload
    permission: valor.dvreload
    aliases:
        - dv
    script:
        - reload
        - narrate "<gold>Denizen has been reloaded!"