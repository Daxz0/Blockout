select_killer:
    type: task
    debug: false
    definitions: killer
    script:
        - run team_switcher_killer
        - inject blockout_<[killer]>_killer
        - flag <player> blockout.game.killer.data:<[data]>

        - adjust <player> speed:<[data.stats.speed].mul[0.01].add[0.110]>

        - bmmodel entity:<player> model:<[data.model_name]>
        - wait 2t
        - adjust <player.bm_entity.model.bone[head]> visible:false|<player>