import QtQuick 2.13

DragZoomItem {
    id: root
    x: (width - main_window.width) / (-2)
    y: (height - main_window.height) / (-2)
    onXChanged: console.log(x, y)
    width: main_grid.width
    height: main_grid.height

    Grid {
        id: main_grid
        readonly property int max_tiles_amount: 2500
        columns: Math.sqrt(max_tiles_amount)
        rows: columns
        transform: Scale { id: main_grid_scale }

        Repeater {
            model: main_grid.max_tiles_amount
            delegate: LandTile {
                Text {
                    text: index
                    anchors.centerIn: parent
                }
            }
        }
    }
}
