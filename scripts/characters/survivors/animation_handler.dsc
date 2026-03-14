# survivor_animation_handler:
#     type: world
#     debug: false
#     events:
#         on player starts sneaking:
#             - bmstate model:blockout_anims state:sneak entity:<player> loop:hold
#         on player stops sneaking:
#             - bmstate model:blockout_anims state:sneak entity:<player> remove
#             - bmstate model:blockout_anims state:unsneak entity:<player> remove