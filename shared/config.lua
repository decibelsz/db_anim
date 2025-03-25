Config = {}
Config.command = 'animacao'
Config.minHealth = 101
Config.debug = true
Config.loadDistance = 50.0
Config.list = {
    ['beberagua'] = {
        animDictionary = 'mp_player_intdrink',
        animationName = 'loop_bottle',
        -- flag = 49,
        loop = false,
        prop = {
            model = 'prop_ld_flow_bottle',
            bone = 18905,
            pos = {x = 0.12, y = 0.02, z = 0.03},
            rot = {x = -90.0, y = 0.0, z = 0.0}
        }
    },
    ['pescar'] = {
        animDictionary = 'amb@world_human_stand_fishing@idle_a',
        animationName = 'idle_c',
        loop = true,
        prop = {
            model = 'prop_fishing_rod_01',
            bone = 60309,
            pos = {x = 0.1, y = 0.05, z = 0.0},
            rot = {x = -80.0, y = 0.0, z = 10.0}
        }
    }
}