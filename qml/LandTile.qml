import QtQuick 2.13

Item {
    id: root
    width: 100
    height: 100

//    rotation: 90 // TODO bug: dysplay image on field's tile

    property int tile_type_idx: 0
    property var edges: tile_types[tile_type_idx]

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

    enum TileEdge { //usage ex.: LandTile.Road
        None,
        City,
        Road,
        Field,
        River
//        Monastery
    }

    function isAppropriate(other) {
        return false
    }

    function isEmpty() {
        return tile_type_idx == 0
    }

    function setHighlight(value) {
        highlightRect.opacity = value ? 0.5 : 0.0
    }

    Image {
        id: tile_texture
        anchors.fill: parent
        source: tile_images[tile_type_idx]

        Rectangle {
            width: 10
            height: 10
            color: "red"
            x: 10
            y: 10
        }
    }

    Rectangle {
        id: highlightRect
        anchors.fill: parent
        opacity: 0.0
        color: "yellow"
    }
}
