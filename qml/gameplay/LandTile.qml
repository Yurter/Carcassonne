import QtQuick 2.14
import "../../js/Utils.js" as Utils

Item {
    id: root

    property int type_idx: 0
    readonly property var edges: tile_prototypes[type_idx].edges

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

    width:  100
    height: 100
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

    Image {
        id: tile_texture
        anchors.fill: parent
        source: tile_prototypes[type_idx].image
    }

    Flow {
        id: tile_zones
        anchors.fill: parent

        readonly property real zone_size: root.width / 3

        Repeater {
            model: {
                const ZONES_COUNT = 9
                var zones = new Array(ZONES_COUNT)
                for (let i = 0; i < ZONES_COUNT; ++i) {
                    zones[i] = { type: LandTile.None };
                }
                const prototype_zones = tile_prototypes[type_idx].zones
                for (let j in prototype_zones) {
                    const zone = prototype_zones[j]
                    zones[parseInt(zone.pos)].type = zone.type
                }
                return zones
            }

            delegate: Item {
                width: tile_zones.zone_size
                height: tile_zones.zone_size

                Rectangle {
                    visible: modelData.type !== LandTile.None
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: parent.height * 0.8
                    radius: width / 2
                    color: {
                        switch (modelData.type) {
                            case LandTile.City:      return '#9000FFFF'
                            case LandTile.Road:      return '#90FF0000'
                            case LandTile.Field:     return '#9000FF00'
                            case LandTile.Monastery: return '#90FFFFFF'
                            default: return '#000000'
                        }
                    }

                    Text { // debug item
                        text: modelData.type
                        anchors.centerIn: parent
                    }
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

    Text { // debug item
        text: root.rotation
        color: "red"
        font {
            pixelSize: 16
            bold: true
        }
    }
    Text { // debug item
        text: type_idx
        color: "red"
        anchors.right: parent.right
        font {
            pixelSize: 16
            bold: true
        }
    }
    Text { // debug item
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: edgeToString(parent.edges[0])
        font.pixelSize: 12
        color: "blue"
    }
    Text { // debug item
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: edgeToString(parent.edges[1])
        font.pixelSize: 12
        color: "blue"
    }
    Text { // debug item
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: edgeToString(parent.edges[2])
        font.pixelSize: 12
        color: "blue"
    }
    Text { // debug item
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

    enum TileZone { // usage ex.: LandTile.Road
          None
        , City
        , Road
        , Field
        , River
        , Monastery
    }

    readonly property var tile_prototypes: [
        {
              edges: [ LandTile.None, LandTile.None, LandTile.None, LandTile.None ]
            , image: 'qrc:/img/tiles/00.jpg'
            , zones: []
        }
        , {
              edges: [ LandTile.City, LandTile.Road, LandTile.Field, LandTile.Road ]
            , image: 'qrc:/img/tiles/01.jpg'
            , zones: [ makeKnightZoneAt(1), makeHighwaymanZoneAt(4), makeFarmerZoneAt(7) ]
        }
        , {
              edges: [ LandTile.City, LandTile.Field, LandTile.Field, LandTile.Field ]
            , image: 'qrc:/img/tiles/02.jpg'
            , zones: [ makeKnightZoneAt(1), makeFarmerZoneAt(7) ]
        }
        , {
              edges: [ LandTile.City, LandTile.City,  LandTile.Field, LandTile.Field ]
            , image: 'qrc:/img/tiles/03.jpg'
            , zones: [ makeKnightZoneAt(1), makeKnightZoneAt(5), makeFarmerZoneAt(6) ]
        }
        , {
              edges: [ LandTile.Field, LandTile.City, LandTile.City, LandTile.City ]
            , image: 'qrc:/img/tiles/04.jpg'
            , zones: [ makeFarmerZoneAt(1), makeKnightZoneAt(4) ]
        }
        , {
              edges: [ LandTile.City, LandTile.Field, LandTile.City, LandTile.Field ]
            , image: 'qrc:/img/tiles/05.jpg'
            , zones: [ makeKnightZoneAt(1), makeFarmerZoneAt(4), makeKnightZoneAt(7)]
        }
        , {
              edges: [ LandTile.Field, LandTile.Road, LandTile.Road, LandTile.Road ]
            , image: 'qrc:/img/tiles/06.jpg'
            , zones: [ makeFarmerZoneAt(1), makeHighwaymanZoneAt(3), makeHighwaymanZoneAt(5), makeFarmerZoneAt(6), makeHighwaymanZoneAt(7), makeFarmerZoneAt(8), ]
        }
        , {
              edges: [ LandTile.City, LandTile.City, LandTile.Road, LandTile.Road ]
            , image: 'qrc:/img/tiles/07.jpg'
            , zones: [ makeKnightZoneAt(2), makeFarmerZoneAt(4), makeHighwaymanZoneAt(3), makeFarmerZoneAt(6) ]
        }
        , {
              edges: [ LandTile.City, LandTile.City, LandTile.Field, LandTile.Field ]
            , image: 'qrc:/img/tiles/08.jpg'
            , zones: [ makeKnightZoneAt(2), makeFarmerZoneAt(6) ]
        }
        , {
              edges: [ LandTile.Road, LandTile.Road, LandTile.Field, LandTile.City ]
            , image: 'qrc:/img/tiles/09.jpg'
            , zones: [ makeHighwaymanZoneAt(1), makeFarmerZoneAt(2),  makeKnightZoneAt(3), makeFarmerZoneAt(7) ]
        }
        , {
              edges: [ LandTile.City, LandTile.City, LandTile.Road, LandTile.City  ]
            , image: 'qrc:/img/tiles/10.jpg'
            , zones: [ makeKnightZoneAt(1), makeFarmerZoneAt(6), makeHighwaymanZoneAt(7), makeFarmerZoneAt(8) ]
        }
        , {
              edges: [ LandTile.Road, LandTile.Road, LandTile.City, LandTile.Field ]
            , image: 'qrc:/img/tiles/11.jpg'
            , zones: [ makeHighwaymanZoneAt(1), makeFarmerZoneAt(2), makeFarmerZoneAt(3), makeKnightZoneAt(7) ]
        }
        , {
              edges: [ LandTile.Road, LandTile.Road, LandTile.Field, LandTile.Field ]
            , image: 'qrc:/img/tiles/12.jpg'
            , zones: [ makeFarmerZoneAt(2), makeHighwaymanZoneAt(4), makeFarmerZoneAt(6) ]
        }
        , {
              edges: [ LandTile.City, LandTile.Road, LandTile.Road,  LandTile.Road ]
            , image: 'qrc:/img/tiles/13.jpg'
            , zones: [ makeKnightZoneAt(1), makeHighwaymanZoneAt(3), makeHighwaymanZoneAt(5), makeFarmerZoneAt(6), makeHighwaymanZoneAt(7), makeFarmerZoneAt(8) ]
        }
        , {
              edges: [ LandTile.Field, LandTile.Road, LandTile.Field, LandTile.Road ]
            , image: 'qrc:/img/tiles/14.jpg'
            , zones: [ makeFarmerZoneAt(1), makeHighwaymanZoneAt(4), makeFarmerZoneAt(7) ]
        }
        , {
              edges: [ LandTile.Field, LandTile.City, LandTile.Field, LandTile.City ]
            , image: 'qrc:/img/tiles/15.jpg'
            , zones: [ makeFarmerZoneAt(1), makeKnightZoneAt(4), makeFarmerZoneAt(7) ]
        }
        , {
              edges: [ LandTile.Field, LandTile.Field, LandTile.Field, LandTile.Field ]
            , image: 'qrc:/img/tiles/16.jpg'
            , zones: [ makeFarmerZoneAt(2), makeMonkZoneAt(4) ]
        }
        , {
              edges: [ LandTile.Field, LandTile.Field, LandTile.Road, LandTile.Field ]
            , image: 'qrc:/img/tiles/17.jpg'
            , zones: [ makeFarmerZoneAt(2), makeMonkZoneAt(4), makeHighwaymanZoneAt(7) ]
        }
    ]

    function makeFarmerZoneAt(pos_idx) {
        return { pos: pos_idx, type: LandTile.Field }
    }

    function makeHighwaymanZoneAt(pos_idx) {
        return { pos: pos_idx, type: LandTile.Road }
    }

    function makeKnightZoneAt(pos_idx) {
        return { pos: pos_idx, type: LandTile.City }
    }

    function makeMonkZoneAt(pos_idx) {
        return { pos: pos_idx, type: LandTile.Monastery }
    }
}
