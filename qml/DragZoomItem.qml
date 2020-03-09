import QtQuick 2.13

Item {
    id: root
    transform: Scale {
        id: scaler
        origin.x: pinch_area.m_x2
        origin.y: pinch_area.m_y2
        xScale: pinch_area.m_zoom2
        yScale: pinch_area.m_zoom2
        Behavior on xScale { PropertyAnimation { duration: 50 } }
        Behavior on yScale { PropertyAnimation { duration: 50 } }
    }

    property real min_x: 0
    property real min_y: 0
    property real max_x: 100
    property real max_y: 100

    property real min_zoom: 0.5
    property real max_zoom: 2.0
    property real zoom_step: 0

    PinchArea {
        id: pinch_area
        anchors.fill: parent
        property real m_x1: 0
        property real m_y1: 0
        property real m_x2: 0
        property real m_y2: 0
        property real m_zoom1: 1
        property real m_zoom2: 1

        property real local_min_x: min_x + (root.width  * (1 - scaler.xScale) * (root.width - scaler.origin.x)  / (root.width  + 1))
        property real local_min_y: min_y + (root.height * (1 - scaler.yScale) * (root.height - scaler.origin.y) / (root.height + 1))
        property real local_max_x: max_x - (root.width  * (1 - scaler.xScale) * (scaler.origin.x / (root.width  + 1)))
        property real local_max_y: max_y - (root.height * (1 - scaler.yScale) * (scaler.origin.y / (root.height + 1)))

        onPinchStarted: {
            console.log("Pinch Started")
            m_x1 = scaler.origin.x
            m_y1 = scaler.origin.y
            m_x2 = pinch.startCenter.x
            m_y2 = pinch.startCenter.y
            root.x = root.x + (pinch_area.m_x1-pinch_area.m_x2)*(1-pinch_area.m_zoom1)
            root.y = root.y + (pinch_area.m_y1-pinch_area.m_y2)*(1-pinch_area.m_zoom1)
        }

        onPinchUpdated: {
            console.log("Pinch Updated")
            m_zoom1 = scaler.xScale
            var dz = pinch.scale-pinch.previousScale
            var newZoom = m_zoom1+dz
            if (newZoom <= max_zoom && newZoom >= min_zoom) {
                m_zoom2 = newZoom
            }
        }

        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent
            drag.target: root
            drag.filterChildren: true
            onWheel: {
//                console.log("Wheel Scrolled")
                pinch_area.m_x1 = scaler.origin.x
                pinch_area.m_y1 = scaler.origin.y
                pinch_area.m_zoom1 = scaler.xScale

                pinch_area.m_x2 = mouseX
                pinch_area.m_y2 = mouseY

                var newZoom
                if (wheel.angleDelta.y > 0) {
                    newZoom = pinch_area.m_zoom1+0.1
                    if (newZoom <= max_zoom) {
                        pinch_area.m_zoom2 = newZoom
                    } else {
                        pinch_area.m_zoom2 = max_zoom
                    }
                } else {
                    newZoom = pinch_area.m_zoom1-0.1
                    if (newZoom >= min_zoom) {
                        pinch_area.m_zoom2 = newZoom
                    } else {
                        pinch_area.m_zoom2 = min_zoom
                    }
                }
                root.x = root.x + (pinch_area.m_x1 - pinch_area.m_x2) * (1 - pinch_area.m_zoom1)
                root.y = root.y + (pinch_area.m_y1 - pinch_area.m_y2) * (1 - pinch_area.m_zoom1)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Click in child")
            }
        }
    }

    Connections {
        target: scaler
        onXScaleChanged: checkXPos()
        onYScaleChanged: checkYPos()
    }

    onXChanged: checkXPos()
    onYChanged: checkYPos()

    function checkXPos() {
        if (pinch_area.local_min_x > pinch_area.local_max_x) { return }
        if (x < pinch_area.local_min_x) { x = pinch_area.local_min_x }
        if (x > pinch_area.local_max_x) { x = pinch_area.local_max_x }
    }

    function checkYPos() {
        if (pinch_area.local_min_y > pinch_area.local_max_y) { return }
        if (y < pinch_area.local_min_y) { y = pinch_area.local_min_y }
        if (y > pinch_area.local_max_y) { y = pinch_area.local_max_y }
    }
}
