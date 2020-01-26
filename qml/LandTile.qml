import QtQuick 2.13

Item {
    id: root
    width: 100
    height: 100

    property int tile_id: -1
    readonly property int start_tile_id: 14

    Rectangle {
        id: background
        anchors.fill: parent
        border.color: "#B3864F"
        color: "#B5C974"
    }
    Image {
        id: tile_texture
        anchors.fill: parent
        source: (tile_id == -1) ? "" : "qrc:/img/tiles/image_part_" + String(tile_id).padStart(3,'0') + ".jpg"
    }
}
