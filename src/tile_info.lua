local tile_info = {}

tile_info.wall_types = {
    {base='wall_bay_v_d', variants={
        'wall_bay_v_a',
        'wall_bay_v_b',
        'wall_bay_v_c',
        'wall_bay_v_crack',
        'wall_bay_v_e',
    }},
    {base='wall_derelict_v_a', variants={
        'wall_derelict_v_b',
        'wall_derelict_v_c',
        'wall_derelict_v_crack',
        'wall_derelict_v_d',
        'wall_derelict_v_e',
    }},
    {base='wall_lab_v_a', variants={
        'wall_lab_v_b',
        'wall_lab_v_c',
        'wall_lab_v_e',
        'wall_lab_v_crack',
    }},
    {base='wall_metal_v_a', variants={
        'wall_metal_v_b',
        'wall_metal_v_c',
        'wall_metal_v_d',
        'wall_metal_v_crack',
        'wall_rust_v_a',
        'wall_rust_v_b',
        'wall_rust_v_c',
        'wall_rust_v_d',
        'wall_rust_v_crack',
    }},
}

tile_info.floor_types = {
    {base='floor_quad_checker_a', variants={
        'floor_quad_checker_b',
        'floor_quad_checker_c',
        'floor_quad_checker_d',
    }},
    {base='floor_quad_green_a', variants={
        'floor_quad_green_b',
        'floor_quad_green_c',
        'floor_quad_green_d',
    }},
    {base='floor_quad_grey_a', variants={
        'floor_quad_grey_b',
        'floor_quad_grey_c',
        'floor_quad_grey_d',
    }},
    {base='floor_quad_teal_a', variants={
        'floor_quad_teal_b',
        'floor_quad_teal_c',
        'floor_quad_teal_d',
    }},
    {base='floor_tile_blue_a', variants={
        'floor_tile_blue_b'
    }},
    {base='floor_tile_green_a', variants={
        'floor_tile_green_b',
        'floor_tile_green_c',
    }}
}

return tile_info