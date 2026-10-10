class_name Util

static func get_closest_enemy(enemies: Array, global_position: Vector2) -> Node2D:
    var closest_enemy: Node2D = null
    var closest_distance: float = 10000000

    for enemy in enemies:
        var distance = enemy.global_position.distance_squared_to(global_position)
        if distance < closest_distance && is_instance_valid(enemy):
            closest_enemy = enemy
            closest_distance = distance


    return closest_enemy