import QtQuick 2.13

DragZoomItem {
    id: root
    x: (width - main_window.width) / (-2)
    y: (height - main_window.height) / (-2)
    width: main_grid.width
    height: main_grid.height
    min_x: main_window.width - main_grid.width
    min_y: main_window.height - main_grid.height
    max_x: 0
    max_y: 0

    Grid {
        id: main_grid
        readonly property int max_tiles_amount: 441
        readonly property int start_tile_index: max_tiles_amount / 2
        columns: Math.sqrt(max_tiles_amount)
        rows: columns
        transform: Scale { id: main_grid_scale }

        Repeater {
            model: main_grid.max_tiles_amount
            delegate: LandTile {
                tile_id: (index == main_grid.start_tile_index) ? 0 : -1

                Text {
                    id: debug_text
                    text: index
                    anchors.centerIn: parent
                    font {
                        bold: true
                        pixelSize: 25
                    }
                }
            }
        }
    }
}
