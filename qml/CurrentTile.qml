import QtQuick 2.13

Item {
    id: root
    width: 110
    height: 110

    property alias tile: tile

    signal tapped

    Rectangle {
        id: temporary_border
        width: 110
        height: 110

        TapHandler {
            onTapped: {
                tile.tile_type_idx = game_field.getUnusedTileIdx()
                game_field.findApproachableTiles(tile)
            }
        }

        LandTile {
            id: tile
            anchors.centerIn: parent
        }
    }
}
