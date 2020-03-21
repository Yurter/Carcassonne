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

    readonly property int grid_size:        21
    readonly property int max_tiles_amount: Math.pow(grid_size, 2)
    readonly property int start_tile_index: max_tiles_amount / 2
    readonly property int start_tile_type_index: 1

    property var unused_tile_idxs: []

    Grid {
        id: main_grid
        columns: Math.sqrt(max_tiles_amount)
        rows: columns
        transform: Scale { id: main_grid_scale }

        Repeater {
            id: repeater
            model: max_tiles_amount
            delegate: LandTile {
                Text {
                    text: index
                    anchors.centerIn: parent
                    font.pixelSize: 20
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
        }
    }

    Component.onCompleted: {
        initStartTile()
        initUnusedTiles()
        nextStep()
    }

    function initStartTile() {
        tileAt(start_tile_index).setTile(start_tile_type_index)
    }

    function initUnusedTiles() {
        let i = 0
        for (i = 0; i < 9; ++i) unused_tile_idxs.push(2)
        for (i = 0; i < 4; ++i) unused_tile_idxs.push(3)
        for (i = 0; i < 2; ++i) unused_tile_idxs.push(4)
        for (i = 0; i < 8; ++i) unused_tile_idxs.push(5)
        for (i = 0; i < 3; ++i) unused_tile_idxs.push(6)
        for (i = 0; i < 4; ++i) unused_tile_idxs.push(7)
        for (i = 0; i < 3; ++i) unused_tile_idxs.push(8)
        for (i = 0; i < 3; ++i) unused_tile_idxs.push(9)
        for (i = 0; i < 5; ++i) unused_tile_idxs.push(10)
        for (i = 0; i < 3; ++i) unused_tile_idxs.push(11)
        for (i = 0; i < 5; ++i) unused_tile_idxs.push(12)
        for (i = 0; i < 4; ++i) unused_tile_idxs.push(13)
        for (i = 0; i < 3; ++i) unused_tile_idxs.push(14)
        for (i = 0; i < 3; ++i) unused_tile_idxs.push(15)
        for (i = 0; i < 2; ++i) unused_tile_idxs.push(16)
        for (i = 0; i < 3; ++i) unused_tile_idxs.push(17)
        for (i = 0; i < 2; ++i) unused_tile_idxs.push(18)

        console.log("Number of created tiles:", unused_tile_idxs.length)
    }

    function nextStep() {
        updateCurrentTile()
        highlightCandidates()
    }

    function tileAt(index) {
        return repeater.itemAt(index)
    }

    function getTile(x, y) {
        return tileAt(x + (y * grid_size))
    }

    function updateCurrentTile() {
        current_tile.tile.tile_type_idx = game_field.getUnusedTileIdx()
    }

    function getUnusedTileIdx() {
        const random_id = Math.floor(Math.random() * unused_tile_idxs.length)
        const unused_idx = unused_tile_idxs[random_id]
        unused_tile_idxs.splice(unused_tile_idxs.indexOf(random_id), 1)
        return unused_idx
    }

    function highlightCandidates() {
        const candidates = findCandidateTiles()
        console.log(candidates.length)
        for (let i in candidates) {
            const cand_idx = candidates[i].index
            const rot_list = candidates[i].rot_list
            tileAt(cand_idx).makeCandidate(rot_list)
        }
    }

    function findCandidateTiles() {
        let candidates = []

        for (let x = 0; x < grid_size; ++x) {
            for (let y = 0; y < grid_size; ++y) {

                const candidate_tile = getTile(x,y)
                if (!candidate_tile.isEmpty()) {
                    continue
                }

                const nearby_tiles = [
                    getTile(x,y-1)   // top
                    , getTile(x+1,y) // right
                    , getTile(x,y+1) // bottom
                    , getTile(x-1,y) // left
                ]

                let nearby_edges = []

                for (let i in nearby_tiles) {
                    if (nearby_tiles[i] && !nearby_tiles[i].isEmpty()) {
                        // bottom, left, top, right
                        const idx = (parseInt(i) + 2) % 4
                        nearby_edges.push(nearby_tiles[i].edges[idx])
                    } else {
                        nearby_edges.push(LandTile.None)
                    }
                }

                let no_nearby_tiles = true
                for (let j in nearby_edges) {
                    if (nearby_edges[j]) {
                        no_nearby_tiles = false
                        break
                    }
                }
                if (no_nearby_tiles) {
                    continue
                }

                let rotation_list = []
                for (let rot = 0; rot < 4; ++rot) {
                    const match =
                            ((current_tile.tile.edges[(rot + 0) % 4] === nearby_edges[0]) || (nearby_edges[0] === LandTile.None))
                        &&  ((current_tile.tile.edges[(rot + 1) % 4] === nearby_edges[1]) || (nearby_edges[1] === LandTile.None))
                        &&  ((current_tile.tile.edges[(rot + 2) % 4] === nearby_edges[2]) || (nearby_edges[2] === LandTile.None))
                        &&  ((current_tile.tile.edges[(rot + 3) % 4] === nearby_edges[3]) || (nearby_edges[3] === LandTile.None))

                    if (match) {
                        rotation_list.push(rot)
                    }
                }

                if (rotation_list.length !== 0) {
                    const current_tile_index = x + (y * grid_size)
                    candidates.push({
                        index: current_tile_index
                        , rot_list: rotation_list
                    })
                }
            }
        }

        return candidates
    }

}
