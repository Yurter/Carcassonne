import QtQuick 2.13

Item {
    id: root
    transform: Scale {
        id: scaler
        origin.x: pinch_area.m_x2
        origin.y: pinch_area.m_y2
        xScale: pinch_area.m_zoom2
        yScale: pinch_area.m_zoom2
    }

    PinchArea {
        id: pinch_area
        anchors.fill: parent
        property real m_x1: 0
        property real m_y1: 0
        property real m_y2: 0
        property real m_x2: 0
        property real m_zoom1: 1
        property real m_zoom2: 1
        property real m_max: 2
        property real m_min: 0.5

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
            if (newZoom <= m_max && newZoom >= m_min) {
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
                console.log("Wheel Scrolled")
                pinch_area.m_x1 = scaler.origin.x
                pinch_area.m_y1 = scaler.origin.y
                pinch_area.m_zoom1 = scaler.xScale

                pinch_area.m_x2 = mouseX
                pinch_area.m_y2 = mouseY

                var newZoom
                if (wheel.angleDelta.y > 0) {
                    newZoom = pinch_area.m_zoom1+0.1
                    if (newZoom <= pinch_area.m_max) {
                        pinch_area.m_zoom2 = newZoom
                    } else {
                        pinch_area.m_zoom2 = pinch_area.m_max
                    }
                } else {
                    newZoom = pinch_area.m_zoom1-0.1
                    if (newZoom >= pinch_area.m_min) {
                        pinch_area.m_zoom2 = newZoom
                    } else {
                        pinch_area.m_zoom2 = pinch_area.m_min
                    }
                }
                root.x = root.x + (pinch_area.m_x1-pinch_area.m_x2)*(1-pinch_area.m_zoom1)
                root.y = root.y + (pinch_area.m_y1-pinch_area.m_y2)*(1-pinch_area.m_zoom1)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Click in child")
            }
        }
    }
}
