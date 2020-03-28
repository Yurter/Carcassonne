import QtQuick 2.13

Item {
    id: root
    width: 110
    height: 110

    property alias tile: tile

    Rectangle {
        id: temporary_border
        width: 110
        height: 110

        LandTile {
            id: tile
            anchors.centerIn: parent
        }
    }
}
