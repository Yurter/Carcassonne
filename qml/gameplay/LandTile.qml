import QtQuick 2.14
import "../../js/Utils.js" as Utils

Item {
    id: root
    width: 100
    height: 100

    property int type_idx: 0
    property var edges: tile_types[type_idx]

    property int topEdge:   edges[0]
    property int rightEdge: edges[1]
    property int downEdge:  edges[2]
    property int leftEdge:  edges[3]

    readonly property var tile_types: [
          [ LandTile.None,  LandTile.None,  LandTile.None,  LandTile.None  ] // 00 - empty tile
        , [ LandTile.City,  LandTile.Road,  LandTile.Field, LandTile.Road  ] // 01 - start tile
        , [ LandTile.City,  LandTile.Field, LandTile.Field, LandTile.Field ] // 02
        , [ LandTile.City,  LandTile.City,  LandTile.Field, LandTile.Field ] // 03
        , [ LandTile.Field, LandTile.City,  LandTile.City,  LandTile.City  ] // 04
        , [ LandTile.City,  LandTile.Field, LandTile.City,  LandTile.Field ] // 05
        , [ LandTile.Field, LandTile.Road,  LandTile.Road,  LandTile.Road  ] // 06
        , [ LandTile.City,  LandTile.City,  LandTile.Road,  LandTile.Road  ] // 07
        , [ LandTile.City,  LandTile.City,  LandTile.Field, LandTile.Field ] // 08
        , [ LandTile.Road,  LandTile.Road,  LandTile.Field, LandTile.City  ] // 09
        , [ LandTile.City,  LandTile.City,  LandTile.Road,  LandTile.City  ] // 10
        , [ LandTile.Road,  LandTile.Road,  LandTile.City,  LandTile.Field ] // 11
        , [ LandTile.Road,  LandTile.Road,  LandTile.Field, LandTile.Field ] // 12
        , [ LandTile.City,  LandTile.Road,  LandTile.Road,  LandTile.Road  ] // 13
        , [ LandTile.Field, LandTile.Road,  LandTile.Field, LandTile.Road  ] // 14
        , [ LandTile.Field, LandTile.City,  LandTile.Field, LandTile.City  ] // 15
        , [ LandTile.Field, LandTile.Field, LandTile.Field, LandTile.Field ] // 16
        , [ LandTile.Field, LandTile.Field, LandTile.Road,  LandTile.Field ] // 17
    ]

    function makeHighwaymanZone(pos_idx) {
        return { pos: pos_idx, type: LandTile.Road }
    }

    function makeKnightZone(pos_idx) {
        return { pos: pos_idx, type: LandTile.City }
    }

    function makeMonkZone(pos_idx) {
        return { pos: pos_idx, type: LandTile.Monastery }
    }


    readonly property var tile_zones_type: [
          [ ]
        , [ makeKnightZone(1), makeHighwaymanZone(4) ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
        , [ ]
    ]

    readonly property var tile_images: [
          "qrc:/img/tiles/00.jpg"
        , "qrc:/img/tiles/01.jpg"
        , "qrc:/img/tiles/02.jpg"
        , "qrc:/img/tiles/03.jpg"
        , "qrc:/img/tiles/04.jpg"
        , "qrc:/img/tiles/05.jpg"
        , "qrc:/img/tiles/06.jpg"
        , "qrc:/img/tiles/07.jpg"
        , "qrc:/img/tiles/08.jpg"
        , "qrc:/img/tiles/09.jpg"
        , "qrc:/img/tiles/10.jpg"
        , "qrc:/img/tiles/11.jpg"
        , "qrc:/img/tiles/12.jpg"
        , "qrc:/img/tiles/13.jpg"
        , "qrc:/img/tiles/14.jpg"
        , "qrc:/img/tiles/15.jpg"
        , "qrc:/img/tiles/16.jpg"
        , "qrc:/img/tiles/17.jpg"
    ]

    enum TileSegment { // usage ex.: LandTile.Road
          None
        , City
        , Road
        , Field
        , River
        , Monastery
    }

    state: "INACTIVE"
    states: [
        State {
            name: "INACTIVE"
            PropertyChanges {
                target: highlightRect
                color: "transparent"
                opacity: 0.0
            }
        }
        , State {
            name: "CANDIDATE"
            PropertyChanges {
                target: highlightRect
                color: "yellow"
                opacity: 0.5
            }
        }
        , State {
            name: "GOOD_CANDIDATE"
            PropertyChanges {
                target: highlightRect
                color: "green"
                opacity: 0.5
            }
        }
        , State {
            name: "BAD_CANDIDATE"
            PropertyChanges {
                target: highlightRect
                color: "red"
                opacity: 0.5
            }
        }
    ]

    function isEmpty() {
        return type_idx == 0
    }

    function setTile(idx) {
        type_idx = idx
        hover_handler.disable()
        const move_distance = (rotation / 90) % 360
        Utils.moveArrayElementsForward(edges, move_distance)
        reset()
    }

    function reset() {
        state = "INACTIVE"
    }

    function makeCandidate(rot_list) {
        state = "CANDIDATE"
        accepted_rotations = rot_list
    }

    Image {
        id: tile_texture
        anchors.fill: parent
        source: tile_images[type_idx]
    }

    Flow {
        id: tile_zones
        anchors.fill: parent

        readonly property real zone_size: root.width / 3

        Repeater {
            model: 9
            delegate: Item {
                width: tile_zones.zone_size
                height: tile_zones.zone_size

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: parent.height * 0.8
                    radius: width / 2
                    color: '#90FFFFFF'
                }
            }
        }
    }

    Rectangle {
        id: highlightRect
        anchors.fill: parent
    }

    HoverHandler {
        id: hover_handler
        enabled: root.state != "INACTIVE"
        property string prev_root_state: root.state
        property int prev_root_type_idx: root.type_idx
        onHoveredChanged: {
            if (hovered) {
                prev_root_state = root.state
                prev_root_type_idx = root.type_idx
                updateState()
            } else {
                root.state = prev_root_state
                root.type_idx = prev_root_type_idx
            }
        }
        function disable() {
            prev_root_state = "INACTIVE"
            prev_root_type_idx = root.type_idx
        }
    }

    TapHandler {
        enabled: root.state != "INACTIVE"
        onTapped: {
            if (root.state == "GOOD_CANDIDATE") {
                game_field.acceptCurrentTile(root)
            }
            else if (root.state == "BAD_CANDIDATE") {
                //
            }
        }
    }

    WheelHandler {
        enabled: root.state != "INACTIVE"
        onWheel: {
            const rot_delta = event.angleDelta.y > 0 ? 90 : -90
            let new_rot_value = (current_tile.rotation + rot_delta) % 360
            if (new_rot_value < 0) {
                new_rot_value = 360 + new_rot_value
            }
            current_tile.rotation = new_rot_value
            updateState()
        }
    }

    function updateState() {
        const current_tile_rot = current_tile.rotation
        if (accepted_rotations.includes(current_tile_rot)) {
            root.state = "GOOD_CANDIDATE"
        } else {
            root.state = "BAD_CANDIDATE"
        }
        rotation = current_tile.rotation
        type_idx = current_tile.type_idx
    }

    property var accepted_rotations: []

    Text {
        text: root.rotation
        color: "red"
        font {
            pixelSize: 16
            bold: true
        }
    }

    Text {
        text: type_idx
        color: "red"
        anchors.right: parent.right
        font {
            pixelSize: 16
            bold: true
        }
    }

    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: edgeToString(parent.edges[0])
        font.pixelSize: 12
        color: "blue"
    }
    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: edgeToString(parent.edges[1])
        font.pixelSize: 12
        color: "blue"
    }
    Text {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: edgeToString(parent.edges[2])
        font.pixelSize: 12
        color: "blue"
    }
    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: edgeToString(parent.edges[3])
        font.pixelSize: 12
        color: "blue"
    }

    function edgeToString(value) {
        switch (value) {
        case 0:
            return "None"
        case 1:
            return "City"
        case 2:
            return "Road"
        case 3:
            return "Field"
        case 4:
            return "River"
        }
        return "Invalid"
    }
}
