// file:///H:\data\2023\pwsh\notebooks\js\dates\Cult%20Info%20Intl.js
// cult info intl8.js
// some of the code is weird, because it's meant for an interactive "Qoukka.js" notebook

let cultInfo = Intl.DateTimeFormat('en-US')
let _ = cultInfo


// test 1: as integers
const now = new Date();
let d0 = new Date(2020, 1, 1) // feb  1 2020
d0;
d0 = new Date(2020, 0, 1) // jan  1 2020
d0;
d0 = new Date(2020, 0, 0) // dec 31 2019
d0;
d0 = new Date(2020, 1, 0) // jan 31 2020
d0;

let samples_0 = [
    { y: 2020, m: 1, d: 1 }, // feb  1 2020
    { y: 2020, m: 0, d: 0 }, // feb  1 2020
    { y: 2020, m: 0, d: 1 }, // feb  1 2020
    { y: 2020, m: 1, d: 0 }, // feb  1 2020
    { y: 2020, m: '1', d: '1' },
    { y: 2020, m: '0', d: '0' },
    { y: 2020, m: '0', d: '1' },
    { y: 2020, m: '1', d: '0' },
]

cultInfo;
let parts = cultInfo.formatToParts( now )
parts;
_ = JSON.stringify( parts )
_;

let fin = parts.reduce( (acc, part) => { return `_${ acc } ; ${ part.value }` } )
fin;

_ = parts.reduce( (acc, part) => { return `_${ acc } ; ${ part.value }` } )

