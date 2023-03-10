local glowstick_visual = {
    sprite='crash/tg_items/tg_items_glowstick',
    glow=true,
    light={
        format='float',
        r=0.8,
        g=0.8,
        b=0.6,
    }
}

return {
    items={
        glowstick={
            name='Glowstick',
            desc='A glowstick. Leave them on the ship to help light it up',
            visual=glowstick_visual,
            default_action='throw',
        },
    },
    actors={
        glowstick={
            name='Glowstick',
            visual=glowstick_visual,
            env_interact={
                static_light=true,
                lights={
                    glowstick_visual.light
                }
            },
            pickable={
                autopickup=false,
                item='glowstick',
            },
            blocks=false,
            destructible={
                type='basic',
                max_hp=1,
                defense=1,
                xp=1,
            }
        }
    },
    tiles={
        glowstick_juice={
            display_name='Glowstick Juice',
            sprite='crash/tg_world/tg_world_glowstick_juice',
            layer='upper',
            tool={type='explosive', hardness=1, hp=1},
            light=glowstick_visual.light,
        }
    }
}