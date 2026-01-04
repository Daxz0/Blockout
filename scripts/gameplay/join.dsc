disable_jump:
    type: task
    debug: false
    script:
        - definemap attributes:
                jump_strength:
                    1:
                        key: blockout:disable_jump
                        operation: ADD_NUMBER
                        amount: -1000
                        slot: head


        - adjust <player> attribute_modifiers:<[attributes]>