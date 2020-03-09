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

    property var unused_tile_idxs: []

    Grid {
        id: main_grid
        readonly property int grid_size: 21
        readonly property int max_tiles_amount: Math.pow(grid_size, 2)
        readonly property int start_tile_index: max_tiles_amount / 2
        columns: Math.sqrt(max_tiles_amount)
        rows: columns
        transform: Scale { id: main_grid_scale }

        Repeater {
            id: repeater
            model: main_grid.max_tiles_amount
            delegate: LandTile {
//                tile_type_idx: (index == main_grid.start_tile_index) ? 1 : 0
                tile_type_idx: {
                    if (index == main_grid.start_tile_index) {
                        return 1
                    }
                    if (index == (main_grid.start_tile_index-1)) {
                        return 6
                    }
                    if (index == (main_grid.start_tile_index-main_grid.grid_size)) {
                        return 5
                    }
                    if (index == (main_grid.start_tile_index-main_grid.grid_size*2)) {
                        return 5
                    }
                    if (index == (main_grid.start_tile_index-main_grid.grid_size*2-1)) {
                        return 5
                    }
                    return 0
                }
            }
        }
    }

    Component.onCompleted: {
        initUnusedTiles()
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

    Connections {
        target: current_tile
        onTapped: {
            current_tile.tile.edges = getNotUsedTile()
        }
    }

    function getTile(x, y) {
        return repeater.itemAt(x + (y * main_grid.grid_size))
    }

    function getUnusedTileIdx() {
        const random_id = Math.floor(Math.random() * unused_tile_idxs.length)
        const unused_idx = unused_tile_idxs[random_id]
        unused_tile_idxs.splice(unused_tile_idxs.indexOf(random_id), 1)
        return unused_idx
    }

    function findCandidateTiles() {
        let candidates = []
        for (var x = 0; x < main_grid.grid_size; ++x) {
            for (var y = 0; y < main_grid.grid_size; ++y) {
                const tile = getTile(x,y)
                if (!tile.isEmpty()) {
                    continue
                }
                const leftNearby    = getTile(x-1,y)
                const rightNearby   = getTile(x+1,y)
                const topNearby     = getTile(x,y-1)
                const downNearby    = getTile(x,y+1)
                const nearbyEdges = []


                if (topNearby && !topNearby.isEmpty()) {
                    nearbyEdges.push(topNearby.downEdge)
                } else {
                    nearbyEdges.push(LandTile.None)
                }

                if (rightNearby && !rightNearby.isEmpty()) {
                    nearbyEdges.push(rightNearby.leftEdge)
                } else {
                    nearbyEdges.push(LandTile.None)
                }

                if (downNearby && !downNearby.isEmpty()) {
                    nearbyEdges.push(downNearby.topEdge)
                } else {
                    nearbyEdges.push(LandTile.None)
                }

                if (leftNearby && !leftNearby.isEmpty()) {
                    nearbyEdges.push(leftNearby.rightEdge)
                } else {
                    nearbyEdges.push(LandTile.None)
                }

                let noNearbyTiles = true
                for (let i in nearbyEdges) {
                    if (nearbyEdges[i]) {
                        noNearbyTiles = false
                        break
                    }
                }
                if (noNearbyTiles) {
                    continue
                }

                for (let rot = 0; rot < 4; ++rot) {
                    const match =
                            ((current_tile.tile.edges[(rot + 0) % 4] === nearbyEdges[0]) || (nearbyEdges[0] === LandTile.None))
                        &&  ((current_tile.tile.edges[(rot + 1) % 4] === nearbyEdges[1]) || (nearbyEdges[1] === LandTile.None))
                        &&  ((current_tile.tile.edges[(rot + 2) % 4] === nearbyEdges[2]) || (nearbyEdges[2] === LandTile.None))
                        &&  ((current_tile.tile.edges[(rot + 3) % 4] === nearbyEdges[3]) || (nearbyEdges[3] === LandTile.None))

                    if (match) {
                        tile.setHighlight(true)
                        candidates.push(tile)
                        break
                    }
                }
            }
        }
        return candidates
    }

    function findApproachableTiles() {
        for (let tile_idx = 0
             ; tile_idx < main_grid.max_tiles_amount
             ; ++tile_idx) {
            const tile = repeater.itemAt(tile_idx)
            tile.setHighlight(false)
        }
        const candidates = findCandidateTiles()
        for (let i in candidates) {
            if (candidates[i]) {
                //
            }
        }
    }

}
