
function moveArrayElementsForward(array, distance) {

    const buf = array.slice()
    const len = array.length
    for (let i = 0; i < len; ++i) {
        array[(distance + i) % len] = buf[i]
    }

}

function moveArrayElementsBackward(array, distance) {

    const buf = array.slice()
    const len = array.length
    for (let i = 0; i < len; ++i) {
        array[(len - distance + i) % len] = buf[i]
    }

}
