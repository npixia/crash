local items = {}

items['oxygen_pack'] = {
    desc='An oxygen pack',
    visual={
        sprite='crash/tg_items/tg_items_flask_blue',
    },
    stats={
        {
            name='Oxygen Content',
            has_value=true,
            key='oxygen_amount',
            show_value_in_item_name=true,
        }
    },
    attributes={
        oxygen_amount=40,
    }
}

return {items=items}